# It's a example script to run custom commands in virtural environment of WSL.
bash -c -i "pip list | grep fastai || pip install -e fastai"
bash -c -i "pip list | grep nbdev || pip install nbdev"