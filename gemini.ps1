#
# Author: Yi Zhang
# Version: 0.1
# 
# Start Notebook in WSL.
#
param(
    [switch]$help, # show help message
    [string]$name, # virtual environment, mandantory.
    [string]$dependfile     # run some custom commands in WSL, such as install packages, optional. 
)

$ErrorActionPreference = "Stop"

if ($help) {
    write-host "gemini -n {virtual name} -d {addtional commands file}"
    exit
}

if (!($name)) {
    write-host "Please specify virtual environment name, -n {name}"
}

# install mini conda, jupyter and create virtual environment
bash -c -i "conda --version || ( curl --retry 3 -o $HOME/install_miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash $HOME/install_miniconda.sh -b && source $HOME/miniconda3/bin/activate)"
bash -c -i "conda env list | grep $name || conda create -n $name python=3.8 -y -q"
bash -c -i "conda activate $name"
bash -c -i "conda list | grep jupyter || conda install -c anaconda jupyter -y -q"

# run addtional commands
if ($dependfile) {
    write-host $dependfile
    & $PSScriptRoot\$dependfile
}

# start jupyter server
$ret = bash -c -i "jupyter notebook --no-browser --port=8080"