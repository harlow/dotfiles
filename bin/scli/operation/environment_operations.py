#!/usr/bin/env python
#==============================================================================
# Copyright 2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================

import logging as _logging

from scli import prompt
from scli import config_file 
from scli.constants import ParameterName
from scli.constants import ParameterSource
from scli.constants import EnvironmentHealth
from scli.constants import EnvironmentStatus
from scli.constants import ServiceDefault
from scli.constants import ServiceRegionId
from scli.constants import ValidationSeverity
from scli.exception import EBSCliException
from scli.operation.base import OperationBase
from scli.operation.base import OperationResult
from scli.parameter import Parameter
from scli.resources import CreateEnvironmentOpMessage
from scli.resources import DescribeEnvironmentOpMessage
from scli.resources import TerminateEnvironmentOpMessage
from scli.resources import UpdateEnvironmentOptionSettingOpMessage
from scli.resources import ValidationMessage
from scli.resources import WaitForCreateEnvironmentFinishOpMessage
from scli.resources import WaitForTerminateEnvironmentFinishOpMessage
from scli.resources import WaitForUpdateEnvOptionSettingFinishOpMessage
from scli.terminal.base import TerminalBase
from lib.elasticbeanstalk.exception import AlreadyExistException
from lib.elasticbeanstalk.request import TemplateSpecification
from lib.rds import rds_utils
from lib.utility import misc

log = _logging.getLogger('cli.op')



class DescribeEnvironmentOperation(OperationBase):
    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.ApplicationName,
                         ParameterName.EnvironmentName,
                        }
    
    _output_parameters = {
                          ParameterName.EnvironmentName
                         }
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        app_name = parameter_pool.get_value(ParameterName.ApplicationName)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        prompt.action(DescribeEnvironmentOpMessage.Start.format(env_name))

        response = eb_client.describe_environments(app_name, 
                                                   env_name, 
                                                   include_deleted = u'false')
        log.info(u'Received response for DescribeEnvironemnts call.')
        self._log_api_result(self.__class__.__name__, u'DescribeEnvironments', response.result)            

        if len(response.result) > 0:    # If have result 
            env_info = response.result[0]
            message = DescribeEnvironmentOpMessage.Result.format(env_info.cname, 
                                                                 env_info.status, 
                                                                 env_info.health)          
            prompt.result(message)
            prompt.info(DescribeEnvironmentOpMessage.Detail.format(env_info.environment_name, 
                                                                   env_info.environment_id, 
                                                                   env_info.solution_stack_name, 
                                                                   env_info.version_label, 
                                                                   env_info.date_created, 
                                                                   env_info.date_updated, 
                                                                   env_info.description))

            # If not Green, pull the most recent warning and error events
            if env_info.health in [EnvironmentHealth.Red, EnvironmentHealth.Yellow] \
                or (env_info.status == EnvironmentStatus.Ready \
                    and env_info.health == EnvironmentHealth.Grey):
                events = eb_client.describe_events(app_name, 
                                                   env_name, 
                                                   max_records = ServiceDefault.STATUS_EVENT_MAX_NUM, 
                                                   severity = ServiceDefault.STATUS_EVENT_LEVEL)
                if len(events.result) > 0:
                    # Having one error event
                    for event in events.result:
                        msg = u'{0}\t{1}\t{2}'.format(event.event_date, 
                                                      event.severity, 
                                                      event.message)
                        log.info(u'Found last error event: {0}'.format(msg))
                        prompt.plain(msg)                
                        
                        
            # Display RDS instance host info
            try:
                logical_id, rds_property = rds_utils.retrieve_rds_instance_property\
                                                        (parameter_pool, env_name)
                if rds_property is not None:
                    prompt.result(DescribeEnvironmentOpMessage.RdsInfo.format\
                                  (logical_id, 
                                   rds_property.endpoint.address, 
                                   rds_property.endpoint.port))
                    prompt.info(DescribeEnvironmentOpMessage.RdsDetail.format\
                                  (rds_property.engine + u' ' + rds_property.engine_version, 
                                   rds_property.allocated_storage, 
                                   rds_property.db_instance_class, 
                                   rds_property.multi_az, 
                                   rds_property.master_username, 
                                   rds_property.instance_create_time, 
                                   rds_property.db_instance_status))
                        
            except BaseException as ex:
                log.error(u'Encountered error when retrieve environment resources: {0}.'.format(ex))
                raise
                        
        else:
            # No result. Environment not exist.
            message = DescribeEnvironmentOpMessage.NoEnvironment.format(env_name) 
            prompt.result(message)
            
        ret_result = OperationResult(self, response.request_id, message, response.result)
        return ret_result



class CreateEnvironmentOperation(OperationBase):

    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.ApplicationName,
                         ParameterName.ApplicationVersionName,
                         ParameterName.EnvironmentName,
                         ParameterName.SolutionStack,
                         ParameterName.RdsEnabled,
                        }
    
    _output_parameters = {
                          ParameterName.EnvironmentName,
                          ParameterName.EnvironmentId,
                          ParameterName.CreateEnvironmentRequestID,
                         }
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        app_name = parameter_pool.get_value(ParameterName.ApplicationName)
        version_name = parameter_pool.get_value(ParameterName.ApplicationVersionName)        
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        stack_name = parameter_pool.get_value(ParameterName.SolutionStack)

        # Try load option setting file if exist
        option_file_location = parameter_pool.get_value(ParameterName.OptionSettingFile)             
        option_settings = config_file.load_env_option_setting_file(option_file_location,
                                                                   quiet = True)
        if option_settings is not None and len(option_settings) > 0:
            prompt.info(CreateEnvironmentOpMessage.UsingOptionSetting.format(option_file_location))
        else:
            option_settings = []

        option_remove = set()
        spec = TemplateSpecification()
        rds_utils.rds_handler(parameter_pool, spec, stack_name, option_settings, option_remove)
        self._option_setting_handler(option_settings, option_remove)
                 
        prompt.action(CreateEnvironmentOpMessage.Start.format(env_name))
        try:
            response = eb_client.create_environment(application = app_name,
                                                    environment = env_name,
                                                    solution_stack = stack_name,
                                                    version_label = version_name,
                                                    option_settings = option_settings,
                                                    option_remove = option_remove,
                                                    template_specification = spec,
                                                    )
        except AlreadyExistException:
            log.info(u'Environment "{0}" already exist.'.format(env_name))
            prompt.result(CreateEnvironmentOpMessage.AlreadyExist.format(env_name))
   
            ret_result = OperationResult(self, 
                                         None, 
                                        CreateEnvironmentOpMessage.AlreadyExist.format(env_name), 
                                         None)
        else:
            log.info(u'Received response for CreateEnvironemnt call.')
            prompt.info(CreateEnvironmentOpMessage.Succeed)
            prompt.result(CreateEnvironmentOpMessage.WaitAfterLaunch.format(env_name))
            self._log_api_result(self.__class__.__name__, u'CreateEnvironment', response.result)            
            
            parameter_pool.put(Parameter(ParameterName.CreateEnvironmentRequestID,
                                         response.request_id,
                                         ParameterSource.OperationOutput))
            
            ret_result = OperationResult(self,
                                         response.request_id, 
                                         CreateEnvironmentOpMessage.Succeed,
                                         response.result)
        return ret_result


    def _rds_creation(self):
        pass
    
    
class WaitForCreateEnvironmentFinishOperation(OperationBase):
    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.EnvironmentName,
                         ParameterName.CreateEnvironmentRequestID,
                         ParameterName.WaitForFinishTimeout,
                         ParameterName.PollDelay,
                        }
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        wait_timeout = parameter_pool.get_value(ParameterName.WaitForFinishTimeout)
        poll_delay = parameter_pool.get_value(ParameterName.PollDelay)
        create_request_id = parameter_pool.get_value(ParameterName.CreateEnvironmentRequestID)\
            if parameter_pool.has(ParameterName.CreateEnvironmentRequestID) else None

        result = self._wait_for_env_operation_finish(
                         eb_client = eb_client, 
                         env_name = env_name, 
                         original_request_id = create_request_id,
                         pending_status = EnvironmentStatus.Launching,
                         expected_health = None,
                         operation_name = self.__class__.__name__, 
                         action_name = WaitForCreateEnvironmentFinishOpMessage.Action,
                         wait_timeout = wait_timeout, 
                         poll_delay = poll_delay, 
                         include_deleted = u'false',
                         initial_delay = 0)

        # After polling
        status = result[0].status
        health = result[0].health
        cname = result[0].cname 
        log.info(u'Stopped polling. Environment "{0}" is now {1}, health is {2}.\nURL is "{3}".'.\
                 format(env_name, status, health, cname))
        
        if status.lower() == EnvironmentStatus.Ready.lower() \
            and health.lower() == EnvironmentHealth.Green.lower():
            prompt.info(WaitForCreateEnvironmentFinishOpMessage.Succeed.format(env_name))
            prompt.result(WaitForCreateEnvironmentFinishOpMessage.Result.format(cname))
        else:
            prompt.info(WaitForCreateEnvironmentFinishOpMessage.Timeout.format(env_name))

        ret_result = OperationResult(self,
                                     None,
                                     WaitForCreateEnvironmentFinishOpMessage.Result.\
                                        format(cname, status, health),
                                     result)

        return ret_result
    
    
class TerminateEnvironmentOperation(OperationBase):

    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.EnvironmentName,
                        }
    
    _output_parameters = {
                          ParameterName.TerminateEnvironmentRequestID,
                         }
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        prompt.action(TerminateEnvironmentOpMessage.Start.format(env_name))
        
        try:
            response = eb_client.terminate_environment(env_name)
        except:
            raise
        else:
            log.info(u'Received response for TerminateEnvironemnt call.')
            prompt.result(TerminateEnvironmentOpMessage.Succeed.format(env_name))
            
            self._log_api_result(self.__class__.__name__, u'TerminateEnvironment', response.result)            
            
            parameter_pool.put(Parameter(ParameterName.TerminateEnvironmentRequestID,
                                         response.request_id,
                                         ParameterSource.OperationOutput))
            
            ret_result = OperationResult(self,
                                         response.request_id, 
                                         TerminateEnvironmentOpMessage.Succeed,
                                         response.result)
        return ret_result
    
        
    
class WaitForTerminateEnvironmentFinishOperation(OperationBase):
    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.EnvironmentName,
                         ParameterName.TerminateEnvironmentRequestID,
                         ParameterName.WaitForFinishTimeout,
                         ParameterName.PollDelay,
                        }
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        wait_timeout = parameter_pool.get_value(ParameterName.WaitForFinishTimeout)
        poll_delay = parameter_pool.get_value(ParameterName.PollDelay)
        terminate_request_id = parameter_pool.get_value(ParameterName.TerminateEnvironmentRequestID)\
            if parameter_pool.has(ParameterName.TerminateEnvironmentRequestID) else None
        
        result = self._wait_for_env_operation_finish(
                         eb_client = eb_client, 
                         env_name = env_name, 
                         original_request_id = terminate_request_id,
                         pending_status = EnvironmentStatus.Terminating,
                         expected_health = None,
                         operation_name = self.__class__.__name__, 
                         action_name = WaitForTerminateEnvironmentFinishOpMessage.Action,
                         wait_timeout = wait_timeout, 
                         poll_delay = poll_delay, 
                         include_deleted = u'true',
                         initial_delay = ServiceDefault.TERMINATE_ENV_POLL_DELAY)                                                     

        # After polling
        status = result[0].status
        health = result[0].health
        log.info(u'Stopped polling. Environment "{0}" is now {1}, health is {2}.'.format\
                 (env_name, status, health))
        
        if status.lower() == EnvironmentStatus.Terminated.lower():
            prompt.result(WaitForTerminateEnvironmentFinishOpMessage.Succeed.format(env_name))
        else:
            prompt.result(WaitForTerminateEnvironmentFinishOpMessage.Timeout.format(env_name))
            prompt.result(WaitForTerminateEnvironmentFinishOpMessage.Status.format(status, health))

        ret_result = OperationResult(self,
                                     None,
                                     WaitForTerminateEnvironmentFinishOpMessage.Result.format(status),
                                     result)

        return ret_result
    

class UpdateEnvOptionSettingOperation(OperationBase):

    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.EnvironmentName,
                         ParameterName.OptionSettingFile,
                         ParameterName.RdsEnabled,
                        }
    
    _output_parameters = {
                          ParameterName.TerminateEnvironmentRequestID,
                         }
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        app_name = parameter_pool.get_value(ParameterName.ApplicationName)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        stack_name = parameter_pool.get_value(ParameterName.SolutionStack)
        prompt.action(UpdateEnvironmentOptionSettingOpMessage.Start.format(env_name))
        
        location = parameter_pool.get_value(ParameterName.OptionSettingFile)            
        option_settings = config_file.load_env_option_setting_file(location, quiet = True)        
        if option_settings is not None and len(option_settings) > 0:
            prompt.info(UpdateEnvironmentOptionSettingOpMessage.UsingOptionSetting.format(location))
        else:
            option_settings = []

        option_remove = set()
        spec = TemplateSpecification() 
        rds_utils.rds_handler(parameter_pool, spec, stack_name, option_settings, option_remove)
        self._option_setting_handler(option_settings, option_remove)
        
        self._validate_change(parameter_pool, eb_client, app_name, env_name, 
                              option_settings, option_remove, spec)

        try:
            response = eb_client.update_environment(env_name, 
                                                    option_settings = option_settings,
                                                    option_remove = option_remove,
                                                    template_specification = spec)
        except:
            raise
        else:
            log.info(u'Received response for UpdateEnvironemnt call.')
            prompt.result(UpdateEnvironmentOptionSettingOpMessage.Succeed.format(env_name))
            
            self._log_api_result(self.__class__.__name__, u'UpdateEnvironment', response.result)            
            
            parameter_pool.put(Parameter(ParameterName.UpdateEnvironmentRequestID,
                                         response.request_id,
                                         ParameterSource.OperationOutput))            
            
            ret_result = OperationResult(self,
                                         response.request_id, 
                                         UpdateEnvironmentOptionSettingOpMessage.Succeed.format(env_name),
                                         response.result)
        return ret_result


    def _validate_change(self, parameter_pool, eb_client, app_name, env_name, 
                         option_settings, option_remove, template_spec):
        response = eb_client.validate_configuration_settings(app_name, option_settings, 
                                                             environment_name = env_name,
                                                             option_remove = option_remove,
                                                             template_specification = template_spec)
        warning_count = 0
        error_count = 0
        for message in response.result:
            if misc.string_equal_ignore_case(message.severity, ValidationSeverity.SeverityError):
                error_count = error_count + 1
            else:
                warning_count = warning_count + 1
            prompt.error(ValidationMessage.ValidateSettingError.format\
                         (message.severity, message.namespace, message.option_name, message.message))
            
        if error_count > 0:            
            log.info(u'Validating configuration setting failed. Abort command.')
            raise EBSCliException()
        elif warning_count > 0:
            if parameter_pool.has(ParameterName.Force) \
                and parameter_pool.get_value(ParameterName.Force) == ServiceDefault.ENABLED:
                pass
            elif not TerminalBase.ask_confirmation(UpdateEnvironmentOptionSettingOpMessage.Continue):
                log.info(u'User cancelled command.')
                raise EBSCliException()
        else:
            log.info(u'Validating configuration setting passed.')
    
    
class WaitForUpdateEnvOptionSettingFinishOperation(OperationBase):
    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.EnvironmentName,
                         ParameterName.WaitForFinishTimeout,
                         ParameterName.PollDelay,
                        }
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        wait_timeout = parameter_pool.get_value(ParameterName.WaitForUpdateTimeout)
        poll_delay = parameter_pool.get_value(ParameterName.PollDelay)
#        update_request_id = parameter_pool.get_value(ParameterName.UpdateEnvironmentRequestID)\
#            if parameter_pool.has(ParameterName.UpdateEnvironmentRequestID) else None

        result = self._wait_for_env_operation_finish(
                         eb_client = eb_client, 
                         env_name = env_name, 
                         original_request_id = None,
                         pending_status = EnvironmentStatus.Updating,
                         expected_health = EnvironmentHealth.Green,
                         operation_name = self.__class__.__name__, 
                         action_name = WaitForUpdateEnvOptionSettingFinishOpMessage.Action,
                         wait_timeout = wait_timeout, 
                         poll_delay = poll_delay, 
                         include_deleted = u'false',
                         initial_delay = ServiceDefault.UPDATE_ENV_POLL_DELAY)                                                     
                                                     
        # After polling
        status = result[0].status
        health = result[0].health
        cname = result[0].cname 
        log.info(u'Stopped polling. Environment "{0}" is now {1}, health is {2}.\nURL is "{3}".'.\
                 format(env_name, status, health, cname))
        
        if status.lower() == EnvironmentStatus.Ready.lower() \
            and health.lower() == EnvironmentHealth.Green.lower():
            prompt.result(WaitForUpdateEnvOptionSettingFinishOpMessage.Succeed.format(env_name))
        else:
            prompt.result(WaitForUpdateEnvOptionSettingFinishOpMessage.Timeout.format(env_name))

        prompt.info(WaitForUpdateEnvOptionSettingFinishOpMessage.Result.\
                    format(cname, status, health))
        ret_result = OperationResult(self,
                                     None,
                                     WaitForUpdateEnvOptionSettingFinishOpMessage.Result.\
                                        format(cname, status, health),
                                     result)

        return ret_result
        