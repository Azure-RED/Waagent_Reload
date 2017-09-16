#!/bin/bash

#
# Waagent reload script for for Redhat and CentOS 6x
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
#
# For early Debian VM, make sure that the VM is upto date.
#
# Richard Eeske
# July 15th 2017
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
sudo service waagent stop
	sleep 1
# Remove the waagent (force if needed)
yum remove WALinuxAgent.noarch -y
	sleep 5
# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent ]; then
	rm /usr/sbin/waagent*
	echo "Waagent reload : Waagent found: Removing waagent binary" | tee /dev/tty | logger -s
fi
# Now, install the waagent
yum install WALinuxAgent.noarch -y
	sleep 5
# Lastly verify that the waagent is active
service waagent start
echo $(service waagent status | grep running) | tee /dev/tty | logger 
	sleep 1
# When the agent is up and running then enable it to start on boot.
# Make sure waagent is on.
chkconfig waagent on
echo $(chkconfig | grep waagen) | tee /dev/tty | logger 
# Show waagent version
Version=$(waagent -version | grep -i agent | cut -c1-19)
echo "$Version installed"  | tee /dev/tty | logger 
#End
