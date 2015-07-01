# -*- coding: utf-8 -*-
'''
Script to auto load python interpreter with useful symbols.

reload this file with rconfig()

# Additional config files
## ~/.pythonrc_local.py
run as if within this file after this file is loaded

## cwd/interactive.py
if this file exists in the cwd where the python interpreter is launched,
it is automatically loaded after everything else


# Secret settings
Settings are stored in config files in the ~/.secret directory. Use these
to automatically connect and authenticate to your favorite databases

'''

from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

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
import itertools
import traceback
tb = traceback                      # Note: tb.format_tb(exc.__traceback__)
it = itertools
from imp import reload

import re
import pprint
path = os.path
psplit = path.split
# better abspath  (expands user automatically)
abspath = lambda p: path.abspath(path.expanduser(p))
p = print
pp = pprint.pprint

from yaml import safe_load as yaml_load
def yload(fname):
    with open(fname) as f:
        return yaml_load(f)

try:
    configfile = __file__
except NameError:
    configfile = abspath(sys.argv[0])


def filestr(filepath):
    '''read file contents into a string'''
    filepath = abspath(filepath)
    with open(filepath, 'r') as f:
        return f.read()


def rconfig():
    '''Reload the config file for the python interpreter'''
    print("Reloading {}".format(configfile))
    exec(filestr(configfile))


##################################################
# ## python2 compatibility (more to be added)
pyversion = sys.version_info.major
if pyversion < 3:
    pyversion = 2
    range = xrange


##################################################
# ## basic scientific libraries

tryimp = '''
try:
    loaded = False
    import {0}
    loaded = True
except ImportError as E:
    if pyversion > 2:
        print('[WARN ] Module "{0}" could not be loaded: {{}}: {{}}'.format(
            type(E), E))
'''.format

exec(tryimp("cloudtb as tb"))
if loaded:
    from cloudtb.builtin import *

import math

# data to play with
r = range(10)
l = list(r)
d = dict((key, key) for key in r)
s = set(r)

# Load optional scientific packages
exec(tryimp("statistics"))
if loaded:
    stats = statistics

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
'''
## ~/.secret/mongo.cfg         # Example MongoDB config file
local:
    host: 127.0.0.1            # default ip address of server
    port: 27017                # default port of server
    database: mydb             # your database name. Loaded as `mdb`
    username: admin            # default username. Leave these lines out if no pwd
    password: admin            # your mongo db password
    source: admin              # default source for authentication
'''
exec(tryimp('pymongo'))
if loaded:
    try:
        lp = abspath("~/.secret/mongo.cfg")
        if not path.exists(lp):
            raise SystemError
        config = yload(lp)
        # Load keys as local variables
        for key, settings in config.items():
            client = pymongo.MongoClient(settings['host'],
                                         int(settings['port']))
            mdb = client[settings['database']]
            if 'username' in settings:
                mdb.authenticate(settings['username'], settings['password'],
                                source=lp['source'])
            exec("{}=mdb".format(key))  # dump into namespace
            print("[ OK  ] loaded {} = {}".format(key, mdb))
    except SystemError:
        pass  # config file doesn't exist
    except Exception as E:
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
print("[ OK  ] loaded {}".format(configfile))
pythonrc = True
del loaded, lp, config, tryimp
