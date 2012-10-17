#!/bin/bash
#
# Cron Script - run from /etc/crontab or /etc/cron.daily
#
# Runs "apt-get update" and prints the output of a simulated
# dist-upgrade if new packages are found.

if [[ `apt-get update 2>&1 | grep Get` ]]; then
  if [[ `apt-get --simulate dist-upgrade 2>&1 | grep Inst` ]]; then
    apt-get --simulate dist-upgrade
  fi
fi
