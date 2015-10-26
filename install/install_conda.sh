set -e
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

mini_install="Miniconda-latest-Linux-x86_64.sh"

if [[ ! -e "$HOME/software/pyconda" ]]; then
    if [[ ! -e "/tmp/$mini_install" ]]; then
        cd /tmp
        wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
    fi
    bash $mini_install -b -p ~/software/pyconda
fi

conda_dir=~/software/pyconda
conda=$conda_dir/bin/conda
envs_dir=$conda_dir/envs

py2_bin=$envs_dir/python2/bin
py2=$py2_bin/python
pip2=$py2_bin/pip

py3_bin=$envs_dir/python3/bin
py3=$py3_bin/python
pip3=$py3_bin/pip

conda_packages="\
    numpy pandas \
    matplotlib bokeh \
    ipython-notebook ipython \
    psutil pyzmq \
    flask "

if [[ ! -e $HOME/projects/cloudtb ]]; then
    cd ~/projects
    git clone git@github.com:vitiral/cloudtb.git
fi
cd ~/projects/cloudtb

# python2 install
if [[ ! -e $py2 ]]; then
    $conda create -y -n python2 python=2 $conda_packages
else
    $conda install -n python2 python=2 $conda_packages
fi
if [[ ! -e $py2_bin/pip2 ]]; then
    ln -s $py2_bin/pip $py2_bin/pip2
fi
$pip2 install -r $SCRIPTPATH/python.txt
$py2 setup.py develop

# python3 install
if [[ ! -e $py3 ]]; then
    $conda create -y -n python3 python=3 $conda_packages
else
    $conda install -n python3 python=3 $conda_packages
fi
if [[ ! -e $py3_bin/pip3 ]]; then
    ln -s $py3_bin/pip $py3_bin/pip3
fi
$pip3 install -r $SCRIPTPATH/python.txt
$py3 setup.py develop

