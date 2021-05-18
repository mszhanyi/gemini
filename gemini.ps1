#
# Author: Yi Zhang
# Version: 0.1
# 
# Start Notebook in WSL.
#
param(
    [switch]$help, # show help message
    [string]$name, # virtual environment, mandantory.
    [string]$dependps,     # run some custom commands in WSL, such as install packages, optional.
    [switch]$nobrowser     # don't start browser.
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
if ($dependps) {
    write-host $dependps
    & $PSScriptRoot\$dependps
}

if ($nobrowser) {
    bash -c -i "jupyter notebook --no-browser"
}
else{
    # start jupyter server
    $task = {Set-Location $using:PWD; bash -c -i "conda activate $name && jupyter notebook --no-browser"}
    $job = Start-Job -ScriptBlock $task

    Receive-Job -Job $job -Keep -ErrorVariable job_output
    $urls = $job_output | Select-String -Pattern 'http:\/\/\w+(\.\w+)*(:[0-9]+)?(\/.*)?$'

    # the port might be occupied, we need to continue to select a new port.
    $ErrorActionPreference = "Continue"
    $startDate = Get-Date

    do {
        if ($startDate.AddMinutes(1) -lt (Get-Date)) {
            write-host "It is time out to start browser, please try using -nobrowser"
            exit 1
        }
        
        if ($urls.Matches.count -gt 0) {
            break;
        }
        Receive-Job -Job $job -Keep -ErrorVariable job_output
        $urls = $job_output | Select-String -Pattern 'http:\/\/\w+(\.\w+)*(:[0-9]+)?(\/.*)?$'
        Start-Sleep -s 2
    } while($urls.Matches.count -lt 1)
    Start-Process $urls.Matches[0].Value
}


