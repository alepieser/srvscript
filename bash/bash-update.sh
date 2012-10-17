#!/bin/sh

txtrst=$(tput sgr0) 	 # Text reset
txtgreen=$(tput setaf 2) # Green

cp ~/.bashrc ~/.bashrc.bck
sed -i 's/# export LS_OPTIONS/export LS_OPTIONS/g' /root/.bashrc
sed -i 's/# eval/eval/g' /root/.bashrc
sed -i 's/# alias ls/alias ls/g' /root/.bashrc
sed -i 's/# alias ll/alias ll/g' /root/.bashrc
sed -i 's/# alias l/alias l/g' /root/.bashrc
source /root/.bashrc
echo -e "Update bash configuration \t ${txtgreen}[OK]${txtrst}"