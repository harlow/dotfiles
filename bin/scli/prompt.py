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

import sys as _sys
from lib.utility import misc
from scli.constants import OutputLevel

_EMPTY_PROMPT = u''
_STAR_PROMPT = u'* '
_DASH_PROMPT = u'--'
_EXCLA_PROMPT = u'! '
_ARROW_PROMPT = u'> '

class _OutputStream(object):

    def __init__(self, stream = _sys.stdout):
        self._out_stream = stream

    def write(self, msg):
        if self._out_stream is not None:
            self._out_stream.write(u'{0}\n'.format(msg))
            self._out_stream.flush()

    def set_stream(self, stream = _sys.stdout):
        self._out_stream = stream


_std_out = _OutputStream(_sys.stdout)
_err_out = _OutputStream(_sys.stderr)
_null_out = _OutputStream(None)

_info = _std_out
_result = _std_out
_err = _err_out

def set_level(level):
    global _std_out, _err_out, _null_out
    global _info, _result, _err
    
    if level == OutputLevel.Info:
        _info = _result = _std_out
        _err = _err_out
    elif level == OutputLevel.ResultOnly:
        _info = _null_out 
        _result = _std_out
        _err = _err_out
    elif level == OutputLevel.Quite:
        _info = _result = _null_out
        _err = _err_out
    elif level == OutputLevel.Silence:
        _info = _result = _err = _null_out

def plain(message):
    global _info, _result, _err
    _result.write(misc.to_unicode(message))

def action(message):
    global _info, _result, _err
    _info.write(_EMPTY_PROMPT + misc.to_unicode(message))

def info(message):
    global _info, _result, _err
    _info.write(_EMPTY_PROMPT + misc.to_unicode(message))
    
def result(message):
    global _info, _result, _err
    _result.write(_EMPTY_PROMPT + misc.to_unicode(message))    

def error(message):
    global _info, _result, _err
    _err.write(_EMPTY_PROMPT + misc.to_unicode(message))
    
    