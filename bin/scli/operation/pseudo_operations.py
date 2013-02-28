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
import logging
import time as _time

from lib.rds import rds_utils
from scli import config_file, prompt
from scli.constants import EbConfigFile, ParameterName, RdsDefault, ServiceDefault
from scli.exception import EBSCliException
from scli.operation.base import OperationBase, OperationResult
from scli.resources import AskConfirmationOpMessage, CommandType, ConfigFileMessage
from scli.terminal.base import TerminalBase


log = logging.getLogger('cli.op')


class ValidateParameterOperation(OperationBase):
    ''' Validate all required parameters and verify all have value'''
    _input_parameters = set()
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        
        # Update parameter
        self._update_timeout_thresholds(parameter_pool)
        
        # Checking parameters
        required_params = self._operation_queue.required_parameters
        missing_params = required_params - parameter_pool.parameter_names 
        if len(missing_params) > 0:
            raise EBSCliException(u'Missing required parameter. "{0}"'.format(missing_params))
        
        log.debug(u'Finished gathering required parameter')

        ret_result = OperationResult(self, None, None, None)
        return ret_result

    
    def _update_timeout_thresholds(self, parameter_pool):
        parameter_pool.update(ParameterName.WaitForFinishTimeout,
                              parameter_pool.get_value(ParameterName.WaitForFinishTimeout)\
                                + self._rds_time_out(parameter_pool))

        parameter_pool.update(ParameterName.WaitForUpdateTimeout,
                              parameter_pool.get_value(ParameterName.WaitForUpdateTimeout)\
                                + self._rds_time_out(parameter_pool))

    
    def _rds_time_out(self, parameter_pool):
        if parameter_pool.has(ParameterName.RdsEnabled)\
            and parameter_pool.get_value(ParameterName.RdsEnabled):
            return ServiceDefault.RDS_ADDITION_TIMEOUT_IN_SEC
        else:
            return 0
            
    
class AskConfirmationOperation(OperationBase):
    ''' Ask for user's confirmation'''
    _input_parameters = set()
    
    _output_parameters = set()    
    

    def execute(self, parameter_pool):
        command = parameter_pool.get_value(ParameterName.Command)
        self._probe_rds_change(parameter_pool, command)
        
        if (parameter_pool.has(ParameterName.Force) \
                and parameter_pool.get_value(ParameterName.Force) == ServiceDefault.ENABLED) \
            or TerminalBase.ask_confirmation(AskConfirmationOpMessage.CommandConfirmation[command]):
            ret_result = OperationResult(self, None, None, None)
            return ret_result
        else:
            log.info(u'User cancelled command.')
            raise EBSCliException()
        
        
    def _probe_rds_change(self, parameter_pool, command):
        
        if parameter_pool.has(ParameterName.ApplicationName)\
            and parameter_pool.has(ParameterName.EnvironmentName):

            app_name = parameter_pool.get_value(ParameterName.ApplicationName)
            env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
            
            policy = rds_utils.is_rds_delete_to_snapshot(parameter_pool, app_name, env_name)
            local_rds_switch = parameter_pool.get_value(ParameterName.RdsEnabled)

            if policy is not None and not RdsDefault.del_policy_to_bool(policy):
                if command == CommandType.UPDATE:
                    if local_rds_switch:
                        pass
                    else:
                        prompt.result(AskConfirmationOpMessage.CommandWarning[command])
                else:
                    prompt.result(AskConfirmationOpMessage.CommandWarning[command])
        

        
class SleepOperation(OperationBase):
    ''' Idle sleep'''
    _input_parameters = set()
    
    _output_parameters = set()    

    def execute(self, parameter_pool):
        create_request_id = parameter_pool.get_value(ParameterName.CreateEnvironmentRequestID)\
            if parameter_pool.has(ParameterName.CreateEnvironmentRequestID) else None
        delay = ServiceDefault.CREATE_ENV_POLL_DELAY if create_request_id is not None else 0
        _time.sleep(delay)
                 
        ret_result = OperationResult(self, None, None, None)
        return ret_result
    

class SanitizeBranchOperation(OperationBase):
    ''' Remove branch registrations if critical parameters are changed.'''
    _input_parameters = set()
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        command = parameter_pool.get_value(ParameterName.Command)
        if command == CommandType.INIT:
            sanitize = False
            for name, ori_name in EbConfigFile.BranchResetParameters.iteritems():
                if parameter_pool.has(ori_name) and \
                    parameter_pool.get_value(name) != parameter_pool.get_value(ori_name):
                    sanitize = True
                    break

            blast = False
            if sanitize:
                if parameter_pool.has(ParameterName.Branches):
                    parameter_pool.remove(ParameterName.Branches)
                    blast = True
                if parameter_pool.has(ParameterName.BranchMapping):
                    parameter_pool.remove(ParameterName.BranchMapping)
                    blast = True
                
                if blast:
                    prompt.error(ConfigFileMessage.BranchResetWarning);



class SanitizeRdsPasswordOperation(OperationBase):
    ''' Remove Rds master passwords from credential file'''
    _input_parameters = set()
    
    _output_parameters = set()
    
    def execute(self, parameter_pool):
        command = parameter_pool.get_value(ParameterName.Command)
        if command == CommandType.DELETE:
            # Remove RDS master password from crential file    
            credential_file_loc = config_file.default_aws_credential_file_location()
            # default environment
            env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
            param_list = [rds_utils.password_key_name(env_name)]
            # branch environment
            if parameter_pool.has(ParameterName.Branches)\
                and parameter_pool.get_value(ParameterName.Branches) is not None:
                branches = parameter_pool.get_value(ParameterName.Branches)
                for branch in branches.values():
                    env_name = branch[ParameterName.EnvironmentName]
                    param_list.append(rds_utils.password_key_name(env_name))
            # Remove passwords
            config_file.trim_aws_credential_file(credential_file_loc, param_list, True)

                                