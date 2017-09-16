#!/bin/bash

#
# Waagent reload script for Redhat and CentOS 7+
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
# 
# Richard Eeske
# July 13th 2017
#
# 1.0 Inital release
# 1.1 Clean up and tuning : added logger
#
# Test for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
	echo "Waagent reload : This script must be executed with super-user privileges." | tee /dev/tty | logger
	exit 1
fi
# check for systemctl
if [ ! -e /bin/systemctl ]; then
	echo "Waagent reload : Wrong OS verion, missing systemctl." | tee /dev/tty | logger
	exit 2
fi
# Stop and wait for waagent to stop
systemctl stop waagent
	sleep 1
# Remove the waagent
yum remove WALinuxAgent.noarch -y
	sleep 5
# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent ]; then
	rm /usr/sbin/waagent*
	echo "Waagent reload : Waagent found: Removing waagent binary" | tee /dev/tty | logger
fi
# Now install the waagent
yum install WALinuxAgent.noarch -y
	sleep 1
# Lastly verify that the waagent is active
systemctl start waagent
echo  "Waagent reload : waagent status." $(systemctl status waagent | grep active) | tee /dev/tty | logger
	sleep 1
# When the agent is up and running then enable it to start on boot.
systemctl enable waagent
Version=$(waagent -version | grep Agent | cut -c1-19)
echo "Waagent reload : $Version installed" | tee /dev/tty | logger
# End
