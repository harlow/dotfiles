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

import re
import logging

from lib.elasticbeanstalk.model import OptionSepcification
from lib.utility import misc
from scli import api_wrapper
from scli.parameter import Parameter
from scli.constants import DevToolsEndpoint, DefaultAppSource, KnownAppContainers,\
    OptionSettingVPC, ParameterName, ServiceEndpoint


log = logging.getLogger('eb')


def match_solution_stack(solution_stack):
    for container in KnownAppContainers:
        if re.match(container.Regex, solution_stack, re.UNICODE):
            return container.Name
    return None

def generate_endpoint(parameter_pool, region, source, force = False):
    parameter_pool.put(Parameter(ParameterName.ServiceEndpoint, 
                                 ServiceEndpoint[region], 
                                 source))     
    parameter_pool.put(Parameter(ParameterName.DevToolsEndpoint, 
                                 DevToolsEndpoint[region], 
                                 source))      



def has_default_app(parameter_pool, solution_stack, eb_client = None):
    appsource = OptionSepcification(DefaultAppSource.Namespace, DefaultAppSource.OptionName)
    
    options = api_wrapper.retrieve_configuration_options(parameter_pool, 
                                            solution_stack = solution_stack,
                                            options = [appsource],
                                            eb_client = eb_client)
    for option in options:
        if misc.string_equal_ignore_case(DefaultAppSource.Namespace, option.namespace) \
            and misc.string_equal_ignore_case(DefaultAppSource.OptionName, option.name):
            return True
        
    return False

def trim_vpc_options(option_settings, option_to_remove):
    no_vpc = False
    vpc_options = set();
    trim_options = set();
    for option in option_settings:
        
        if option.namespace == OptionSettingVPC.Namespace:
            vpc_options.add(option)
                
            if option.value is None or len(option.value) < 1:
                if option.option_name == OptionSettingVPC.MagicOptionName:
                    no_vpc = True
                trim_options.add(option)

        if option.namespace in OptionSettingVPC.TrimOption\
            and option.option_name in OptionSettingVPC.TrimOption[option.namespace]:
                trim_options.add(option)
                
    if no_vpc:
        for option in vpc_options:
            option_settings.remove(option)
            option_to_remove.add(OptionSepcification(option.namespace, option.option_name))
    else:
        for option in trim_options:
            option_settings.remove(option)
            option_to_remove.add(OptionSepcification(option.namespace, option.option_name))
        
            
        
                
        
    
