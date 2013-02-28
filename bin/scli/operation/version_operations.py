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
from scli.operation.base import OperationBase
from scli.operation.base import OperationResult
from scli.parameter import Parameter
from scli.constants import ParameterName
from scli.resources import CreateApplicationVersionOpMessage
from lib.elasticbeanstalk import eb_utils
from lib.elasticbeanstalk.exception import AlreadyExistException

log = _logging.getLogger('cli.op')


class CreateApplicationVersionOperation(OperationBase):

    _input_parameters = {
                         ParameterName.AwsAccessKeyId, 
                         ParameterName.AwsSecretAccessKey,
                         ParameterName.ServiceEndpoint, 
                         ParameterName.Region,
                         ParameterName.SolutionStack,
                         ParameterName.ApplicationName,
                         ParameterName.ApplicationVersionName
                        }
    
    _output_parameters = {
                          ParameterName.ApplicationVersionName
                         }

   
    def execute(self, parameter_pool):
        eb_client = self._get_eb_client(parameter_pool)
        app_name = parameter_pool.get_value(ParameterName.ApplicationName)
        version_name = parameter_pool.get_value(ParameterName.ApplicationVersionName)
        solution_stack = parameter_pool.get_value(ParameterName.SolutionStack)

        container_name = eb_utils.match_solution_stack(solution_stack)
        log.info(u'App container is "{0}".'.format(container_name))

        try:
            response = eb_client.create_application_version(app_name, 
                                                            version_name)
        except AlreadyExistException:
            log.info(u'Version "{0}" of Application "{1}" already exists.'.\
                     format(version_name, app_name))
            prompt.info(CreateApplicationVersionOpMessage.AlreadyExist.format(version_name))
   
            ret_result = OperationResult(self,
                                         None, 
                                         CreateApplicationVersionOpMessage.AlreadyExist.\
                                            format(version_name),
                                         None)
        else:        
            log.info(u'Received response for CreateApplicationVersion call.')
            prompt.info(CreateApplicationVersionOpMessage.Succeed.format(version_name))
            self._log_api_result(self.__class__.__name__, u'CreateApplicationVersion', response.result)            

            ret_result = OperationResult(self,
                                         response.request_id, 
                                         CreateApplicationVersionOpMessage.Succeed.\
                                            format(version_name),
                                         response.result)

        if eb_utils.has_default_app(parameter_pool, solution_stack):
            log.info(u'Solution stack "{0}" has default sample app.'.format(solution_stack))
            prompt.info(CreateApplicationVersionOpMessage.HasDefaultAppSource.format(solution_stack))
        else:
            # Set version to None
            source = parameter_pool.get_source(ParameterName.ApplicationVersionName) 
            parameter_pool.put(Parameter(ParameterName.ApplicationVersionName, 
                                         None,
                                         source),
                               True)
            
        return ret_result


    
    