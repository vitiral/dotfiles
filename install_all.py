#!/usr/bin/python
'''Install all dependencies for my computer
'''
import sys
import os
import subprocess as subp

FNULL = open(os.devnull, 'w')

sudo = 'sudo '
pipstr = 'pip install -U {}'
if sys.platform.lower() == 'linux':
    if not subp.call("apt-get --help", shell=True, stdout=FNULL, stderr=FNULL):
        installer = 'apt-get install -U'
    elif not subp.call("pacman --get --help", shell=True, stdout=FNULL, stderr=FNULL):
        installer = 'pacman install -U'
    else:
        print("Installer Unknown")
        sys.exit(1)

    installfmt = ('sudo %s {}' % installer).format
    pipfmt = (sudo + pipstr).format
    system_packages.extend(linux_packages)
    zshpath = '/usr/bin/zsh'
elif 'darwin' in sys.platform.lower():
    installfmt = 'brew install {}'.format
    pipfmt = pipstr.format
    zshpath = '/usr/local/bin/zsh'
else:
    print("Platform Unknown. Exiting")
    sys.exit(1)

pip_packages = [
    'virtualenv',
    'numpy',
    'pandas',
    'ipython[notebook]',
    'statistics',
    'requests',
    'flask',
]

system_packages = [
    'python',
    'python3',
    'cython',
    'zsh',
    'openssh',
]

linux_packages = [
    'vim',
    # python
    'python-pip',
    'python-dev',
    'python3-dev',
    'libxml2-dev libxslt1-dev',  # annoyingly required for some python libs

    # c development
    'build-essential',
    'valgrind',
]

extras = [
    'ipython3 profile create',
    # dotfiles
    'curl https://raw.githubusercontent.com/cloudformdesign/spf13-vim/master/'
        'spf13-vim.sh -L > spf13-vim.sh && sh spf13-vim.sh',
    # zsh
    'mkdir ~/.antigen && cd ~/.antigen && '
        'git clone https://github.com/zsh-users/antigen.git",
    'sudo chsh -s ' + zshpath + ' $USER',  # change default shell to zsh
]


def installall():
    subp.check_call(installfmt(' '.join(system_packages), shell=True))
    subp.check_call(pipfmt(' '.join(pip_packages), shell=True))


if __name__ == '__main__':
    installall()
