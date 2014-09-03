
# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH

alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias minicom=/opt/minicom/2.2/bin/minicom
alias ssh_test="ssh -A -i ~/.ssh/identity.pem ubuntu@54.197.147.153"
alias ssh_rp="ssh pi@192.168.100.68"
alias ssh_bench="ssh -A -i ~/.ssh/identity.pem ubuntu@54.210.161.163"
alias ssh_results="scp -i ~/.ssh/identity.pem ubuntu@54.197.147.153:/home/ubuntu/code/scripts/nio-testing/results.csv ~/Downloads/results.csv ;\
    scp -i ~/.ssh/identity.pem ubuntu@54.197.147.153:/home/ubuntu/code/scripts/nio-testing/results_raw.csv ~/Downloads/results_raw.csv "

