#!/bin/sh

url="https://raw.github.com/weilex/srvscript/master"
txtrst=$(tput sgr0) 	 # Text reset
txtred=$(tput setaf 1)   # Red
txtgreen=$(tput setaf 2) # Green

if [ -d '/etc/php5/conf.d' ]; then
  echo '; Set mbstring defaults to UTF-8
mbstring.language=UTF-8
mbstring.internal_encoding=UTF-8
mbstring.http_input=UTF-8
mbstring.http_output=UTF-8
mbstring.detect_order=auto' \
    > '/etc/php5/conf.d/mbstring.ini'
  echo -e "PHP5 mbstring configuration\t${txtgreen}[OK]${txtrst}"
fi