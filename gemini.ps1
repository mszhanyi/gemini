#
# Author: Yi Zhang
# Version: 0.1
# 
# Windows browser with Notebook in WSL.
#

$ErrorActionPreference = "Stop"

param (
	[switch]$help,          # show help message
	[string]$name,          # virtual environment, mandantory.
    [string]$dependfile     # run some custom commands in WSL, such as install packages, optional. 
)

if ($help)
{
    write-host "gemini -n {virtual name} -d {addtional commands file}"
	exit
}

if (!($name))
{
	write-host "Please specify virtual environment name, -n {name}"
}

# install mini conda, jupyter and create virtual environment
bash -c -i "conda --version || ( wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh && source $HOME/.bashrc )"
bash -c -i "conda env list | grep $name || conda create -n $name python=3.8"
bash -c -i "conda activate $name"
bash -c -i "conda list | grep jupyter || conda install -c anaconda jupyter"

# run addtional commands
if ($dependfile)
{
	write-host $dependfile
	& $dependfile
}

# start jupyter server
$ret = bash -c -i "jupyter notebook --no-browser --port=8080"

$url = $ret | Select-String -Pattern '^http:\/\/\w+(\.\w+)*(:[0-9]+)?(\/.*)?$'
start $url