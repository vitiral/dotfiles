from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

loaded = False  # used to detect tryimp loading
rcloaded = False

try:
    __IPYTHON__
    # Nothing here yet
except NameError:
    pass

# python2 interface
import sys
import os

# python 2 compatibility
if sys.version_info.major < 3:
    range = xrange
    del xrange

# basic
import re
import pprint
path = os.path
psplit = path.split
p = print
pp = pprint.pprint

# basic scientific libraries

# data to play with
r = range(10)
l = list(r)
d = {key: key for key in r}
s = set(r)
tryimp = '''  # exec lines to try importing modules into namespace
try:
    loaded = False
    import {0}
    loaded = True
except ImportError:
    print(' - Module "{0}" could not be loaded')
'''.format

exec(tryimp('numpy as np'))
if loaded:
    a = np.array(r)  # play with data
exec(tryimp('pandas as pd'))
if loaded:
    idx = pd.IndexSlice
    df = pd.DataFrame({'x': l, 'y': l})  # play with data
exec(tryimp('bokeh'))
if loaded:
    import bokeh.plotting as plt

import math
import statistics
stats = statistics

# toolbox
exec(tryimp("cloudtb as tb"))
if loaded:
    from cloudtb.builtin import *  # import should be builtins

rcloaded = True
del loaded
