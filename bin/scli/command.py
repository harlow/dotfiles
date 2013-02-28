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

from scli.resources import CommandType
from scli.operation_queue import OperationQueue
from scli.operation.application_operations import CreateApplicationOperation, \
    DeleteApplicationOperation 
from scli.operation.environment_operations import CreateEnvironmentOperation, \
    DescribeEnvironmentOperation, TerminateEnvironmentOperation, UpdateEnvOptionSettingOperation, \
    WaitForCreateEnvironmentFinishOperation, WaitForTerminateEnvironmentFinishOperation, \
    WaitForUpdateEnvOptionSettingFinishOperation
from scli.operation.file_operations import CheckGitIgnoreFileOperation, \
    ReadAwsCredentialFileOperation, LoadEbConfigFileOperation, TryGetCurrentBranchOperation, \
    TryLoadEbConfigFileOperation, SaveConfigurationSettingOperation, SaveEbConfigFileOperation, \
    RotateOptionsettingFileOperation, UpdateDevToolsConfigOperation, UpdateAwsCredentialFileOperation
from scli.operation.pseudo_operations import AskConfirmationOperation, SleepOperation, \
    SanitizeBranchOperation, SanitizeRdsPasswordOperation, ValidateParameterOperation
from scli.operation.terminal_operations import AskForMissiongParameterOperation, \
    AskForConfigFileParameterOperation, RegisterBranchOperation
from scli.operation.version_operations import CreateApplicationVersionOperation



def compile_operation_queue(command):
    queue = OperationQueue()
    
    if command == CommandType.INIT:
        queue.add(TryLoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(AskForConfigFileParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(RotateOptionsettingFileOperation(queue))
        queue.add(SanitizeBranchOperation(queue))
        queue.add(UpdateAwsCredentialFileOperation(queue))
        queue.add(SaveEbConfigFileOperation(queue))
        queue.add(UpdateDevToolsConfigOperation(queue))
        queue.add(CheckGitIgnoreFileOperation(queue))    
    
    elif command == CommandType.START:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(TryGetCurrentBranchOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
#        queue.add(SaveEbConfigFileOperation(queue))
        queue.add(UpdateDevToolsConfigOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(CreateApplicationOperation(queue))
        queue.add(CreateApplicationVersionOperation(queue))
        queue.add(CreateEnvironmentOperation(queue))
        queue.add(SleepOperation(queue))
        queue.add(SaveConfigurationSettingOperation(queue))
        queue.add(WaitForCreateEnvironmentFinishOperation(queue))
        
    elif command == CommandType.UPDATE:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(TryGetCurrentBranchOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(AskConfirmationOperation(queue))
        queue.add(UpdateEnvOptionSettingOperation(queue))
        queue.add(WaitForUpdateEnvOptionSettingFinishOperation(queue))
            
    elif command == CommandType.STATUS:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(TryGetCurrentBranchOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(DescribeEnvironmentOperation(queue))
        
    elif command == CommandType.STOP:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(TryGetCurrentBranchOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(AskConfirmationOperation(queue))
        queue.add(SaveConfigurationSettingOperation(queue))
        queue.add(TerminateEnvironmentOperation(queue))
        queue.add(WaitForTerminateEnvironmentFinishOperation(queue))
        
    elif command == CommandType.DELETE:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
#        queue.add(TryGetCurrentBranchOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(AskConfirmationOperation(queue))
        queue.add(DeleteApplicationOperation(queue))
#        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(SanitizeRdsPasswordOperation(queue))
    
    elif command == CommandType.BRANCH:
        queue.add(CheckGitIgnoreFileOperation(queue))
        queue.add(LoadEbConfigFileOperation(queue))
        queue.add(ReadAwsCredentialFileOperation(queue))
        queue.add(AskForMissiongParameterOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(RegisterBranchOperation(queue))
        queue.add(ValidateParameterOperation(queue))
        queue.add(UpdateAwsCredentialFileOperation(queue))
        queue.add(SaveEbConfigFileOperation(queue))

    else:
        AttributeError(unicode.format("Not supported command: {0}", command))
        
    return queue
    

