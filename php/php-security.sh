#!/bin/sh
#
# Originally created by biapy.org

txtrst=$(tput sgr0) 	 # Text reset
txtgreen=$(tput setaf 2) # Green

if [ -d '/etc/php5/conf.d' ]; then
echo '; Harden PHP5 security

; Disable PHP exposure
expose_php = Off

;Dangerous : disable system functions. This can break some administration softwares.
;disable_functions = symlink,shell_exec,exec,proc_close,proc_open,popen,system,dl,passthru,escapeshellarg,escapeshellcmd
' > '/etc/php5/conf.d/security-hardened.ini'

echo -e "PHP5 configuration security\t${txtgreen}[OK]${txtrst}"
fi