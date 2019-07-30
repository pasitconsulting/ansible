#!/usr/bin/env bash
# Inspired by https://gist.github.com/cha55son/6042560

# Check for interactive shell
if [ ! -z "${PS1}" ]; then

RELEASE=`timeout 1 bash -c 'cat /etc/system-release 2>/dev/null || cat /etc/redhat-release 2>/dev/null || cat /etc/lsb-release | grep DISTRIB_DESCRIPTION | cut -d '=' -f 2 | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g" 2>/dev/null'`
USER=`timeout 1 bash -c 'whoami'`
HOSTNAME=`timeout 1 bash -c 'uname -n'`
PSA=`timeout 1 bash -c 'ps -Afl | wc -l'`

#System uptime
uptime=`timeout 1 bash -c 'cat /proc/uptime | cut -f1 -d.'`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

#System load
LOAD1=`timeout 1 bash -c 'cat /proc/loadavg | awk {"print $1"}'`
LOAD5=`timeout 1 bash -c 'cat /proc/loadavg | awk {"print $2"}'`
LOAD15=`timeout 1 bash -c 'cat /proc/loadavg | awk {"print $3"}'`

#Mem Usage
MEM=`timeout 1 bash -c 'free -t -m'`

#Disk Usage
DISK=`timeout 2 bash -c 'df -h | grep --invert "^none\|tmpfs\|udev"'`

echo "===========================================================================
- Hostname............: $HOSTNAME
- Release.............: $RELEASE
- Users...............: Currently `users | wc -w` user(s) logged on
- Current user........: $USER
===========================================================================
- CPU usage...........: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)
- Processes...........: $PSA running
- System uptime.......: $upDays days $upHours hours $upMins minutes $upSecs seconds
===========================================================================
- Mem usage (MB):
$MEM
===========================================================================
- Disk usage:
$DISK
===========================================================================
"
fi
