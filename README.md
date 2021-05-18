# gemini
For the well know reason, Jupyter Notebook doesn't support python multiprocessing.
Some functions, like pytorch dataloader, will trigger some issues in Notebook on Windows.
The goal of gemini is to help users can run Jupyter Notebook on Windows as well as on Linux.

## Prerequisite

[The WSL and one Linux distribution](https://docs.microsoft.com/en-us/windows/wsl/install-win10) should be be installed in your windows 10 machine.

## How to use

Fast.ai is fully built on Jupyter notebooks. 
Let's use fastai as the example.
1. cd d:\git, git clone https://github.com/fastai/fastai
2. download gemini.ps1 and installdeps.ps1
3. powershell gemini.ps1 -name fastai -dependps installdeps.ps1
4. try fastai/nbs/08_vision.data.ipynb 

`-d installdeps.ps1` is optional, it is only used when you want to run some additional commands, such as install packages.


## Limitations
Only WSL2 supports GPU and only Geforce Cards are supported.

## Refs
https://github.com/pytorch/pytorch/issues/51344<br>
https://github.com/mszhanyi/pymultiprocessdemo<br>
https://github.com/microsoft/WSL/issues/5546



