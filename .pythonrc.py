from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

# user, user local, and cwd configurations
# stored as ~/.pythonrc.py, ~/.pythonrc_local.py, cwd/interactive.py
pythonrc, localrc, interactiverc = False, False, False

loaded, lp, config = (None,) * 3  # deleted at end

try:
    __IPYTHON__
    # Nothing here yet
except NameError:
    pass

##################################################
# ## basic namespace

import sys
import os
import configparser
from imp import reload
rl = reload


import re
import pprint
path = os.path
psplit = path.split
abspath = lambda p: path.abspath(path.expanduser(p))
p = print
pp = pprint.pprint


def filestr(filepath):
    '''read file contents'''
    filepath = abspath(filepath)
    with open(filepath, 'r') as f:
        return f.read()


##################################################
# ## python2 compatibility (more to be added)
if sys.version_info.major < 3:
    range = xrange
    del xrange


##################################################
# ## basic scientific libraries

import math
import statistics
stats = statistics

# data to play with
r = range(10)
l = list(r)
d = {key: key for key in r}
s = set(r)

# Load optional scientific packages
tryimp = '''
try:
    loaded = False
    import {0}
    loaded = True
except ImportError:
    print('[WARN ] Module "{0}" could not be loaded')
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
exec(tryimp("cloudtb as tb"))
if loaded:
    from cloudtb.builtin import *


##################################################
# ## database tools
exec(tryimp('pymongo'))
if loaded:
    try:
        lp = abspath("~/.secret/mongo.cfg")
        config = configparser.ConfigParser()
        config.read(lp)
        lp = dict(config['creds'])
        client = pymongo.MongoClient(lp['host'], int(lp['port']))
        db = client[lp['database']]
        db.authenticate(lp['username'], lp['password'],
                        source=lp['source'])
    except Exception as e:
        print("[WARN ] Could not completely load mongo database {}: {}".
              format(type(E), E))


##################################################
# ## load local and cwd configs
try:
    # import ipdb; ipdb.set_trace()
    lp = "~/.pythonrc_local.py"
    exec(filestr(lp))
    print("[OK   ] loaded {}".format(lp))
    localrc = True
except: pass
try:
    exec(filestr("interactive.py"))
    print("[OK   ] loaded cwd/interactive.py")
    interactiverc = True
except: pass


##################################################
# ## cleanup
pythonrc = True
del loaded, lp, config
