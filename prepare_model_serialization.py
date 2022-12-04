#!/usr/bin/env python

'''
Helper script taken from  
langid.py library. Disclaimer below:

Language Identifier by Marco Lui April 2011

Based on research by Marco Lui and Tim Baldwin.

Copyright 2011 Marco Lui <saffsd@gmail.com>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of the copyright holder.

'''

from __future__ import print_function
try:
  # if running on Python2, mask input() with raw_input()
  input = raw_input
except NameError:
  pass


import base64
import bz2
import json
import optparse
import sys
import logging
import numpy as np
from wsgiref.simple_server import make_server
from wsgiref.util import shift_path_info
from collections import defaultdict

try:
  from urllib.parse import parse_qs
except ImportError:
  from urlparse import parse_qs

try:
  from cPickle import loads
except ImportError:
  from pickle import loads

logger = logging.getLogger(__name__)

model=b"""
"""


import json
import sys
b = base64.b64decode(model)
z = bz2.decompress(b)
loaded_model = loads(z)
nb_ptc, nb_pc, nb_classes, tk_nextmove, tk_output = loaded_model

nb_numfeats = int(len(nb_ptc) / len(nb_pc))

# reconstruct pc and ptc
# num feats = 7480
nb_pc = np.array(nb_pc)
nb_ptc = np.array(nb_ptc).reshape(nb_numfeats, len(nb_pc))

np.save('models/nb_pc', nb_pc, allow_pickle=False, fix_imports=False) #Save 'bias'
np.save('models/nb_ptc', nb_ptc, allow_pickle=False, fix_imports=False) #Save 'linear layer'

classes_info = {'classes': nb_classes}
with open('models/classes_info.json', 'w') as f:
    json.dump(classes_info, f)

data = {'tk_nextmove' : tk_nextmove.tolist(), 'tk_output': tk_output}
with open('models/fst_feature_model_info.json', 'w') as f:
    json.dump(data, f)