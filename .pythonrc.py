'''
Script to auto load python interpreter with useful symbols.

# system
sys, os, configparser, reload (rl), re, pprint

p=print, pp=pprint.pprint
path=os.path, pslit=path.split, abspath=better form os path.abspath

# Scientific
math, statistics (stats)
numpy as np (A = np.carray)
pandas as pd (DF = pd.DataFrame, idx=pd.IndexSlice)
cloudtb as tb, from cloudtb.builtin import *  # tons of useful functions

Data to play with:
    r = range(10), l = list(r), d = {n: n for n in r}
    a = np.array(r), df = pd.DataFrame({'x': l, 'y': l})

# visualization
matplotlib as mpl,  bokeh as bk (plt=bk.plotting, fig=plt.figure)
'''

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

exec(tryimp("cloudtb as tb"))
if loaded:
    from cloudtb.builtin import *

exec(tryimp('numpy as np'))
if loaded:
    A = np.array
    a = A(r)  # play with data
exec(tryimp('pandas as pd'))
if loaded:
    DF = pd.DataFrame
    idx = pd.IndexSlice
    df = DF({'x': l, 'y': l})  # play with data

# visualization
exec(tryimp('matplotlib as mpl'))
exec(tryimp('bokeh'))
if loaded:
    bk = bokeh
    import bokeh.plotting as plt
    fig = plt.figure

##################################################
# ## database tools
exec(tryimp('pymongo'))
if loaded:
    try:
        lp = abspath("~/.secret/mongo.cfg")
        if not path.exists(lp):
            raise SystemError
        config = configparser.ConfigParser()
        config.read(lp)
        lp = config['creds']
        client = pymongo.MongoClient(lp['host'], int(lp['port']))
        db = client[lp['database']]
        db.authenticate(lp['username'], lp['password'],
                        source=lp['source'])
        print("[ OK  ] loaded db = {}".format(db))
    except SystemError:
        pass  # config file doesn't exist
    except Exception as e:
        print("[ERROR] loading mongo db: {}: {}".
              format(type(E), E))


##################################################
# ## load local and cwd configs.
# ##    Pass them if they don't exist
try:
    lp = "~/.pythonrc_local.py"
    exec(filestr(lp))
    print("[ OK  ] loaded {}".format(lp))
    localrc = True
except Exception as e:
    if path.exists(abspath(lp)):
        print("[ERROR] could not load {}: {}: {}".format(lp, type(e), e))
try:
    lp = "interactive.py"
    exec(filestr(lp))
    print("[ OK  ] loaded cwd/interactive.py")
    interactiverc = True
except Exception as e:
    if path.exists(abspath(lp)):
        print("[ERROR] could not load {}: {}: {}".format(lp, type(e), e))


##################################################
# ## cleanup
pythonrc = True
del loaded, lp, config, tryimp
