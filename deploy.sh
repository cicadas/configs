#!/bin/bash

cp vim_runtime.tar.gz ~/
if [[ -e ~/bin ]]; then
    cp -r bin/* ~/bin
else:
    cp -r bin ~/
fi

cp -r ./.[^.]* ~/

cd ~/
tar -zxvf vim_runtime.tar.gz
