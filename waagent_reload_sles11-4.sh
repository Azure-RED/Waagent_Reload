#!/bin/bash
#
# Waagent reload script for for SELS 11 (sp 4)
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
#
# For early Debian VM, make sure that the VM is upto date.
#
# Richard Eeske
# August 5th 2017
#
# 1.0 Inital release
# 1.1 Clean up and tuning : added logger
#
# Test for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
	echo "Waagent reload : This script must be executed with super-user privileges." | tee /dev/tty | logger -s
	exit 1
fi
# Check for systemctl
if [ ! -e /sbin/service ]; then
	echo "Waagent reload : Wrong OS verion, missing service." | tee /dev/tty | logger -s
	exit 2
fi
sudo /sbin/service waagent stop
	sleep 1
# Remove the waagent (force if needed)
zypper -n rm python-azure-agent

# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent2.0 ]; then
	rm /usr/sbin/waagent*
	echo "Waagent reload : Waagent found: Removing waagent binary" | tee /dev/tty | logger -s
fi
#Update the repo to get the latest waagent
sudo zypper -n refresh
# Now, install the waagent
sudo zypper -n install python-azure-agent
	sleep 5
/sbin/service waagent start
echo $(/sbin/service waagent status | grep running) | tee /dev/tty | logger 
	sleep 1
# Lastly verify that the waagent is active
/usr/sbin/waagent2.0 -version
#set to run on boot
# When the agent is up and running then enable it to start on boot.
# Make sure waagent is on.
/sbin/chkconfig waagent 235
# Verify that the waagent is enabled for the needed runlevels
echo $(/sbin/chkconfig -t waagent) | tee /dev/tty | logger 
# End

