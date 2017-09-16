#!/bin/bash

#
# Waagent reload script for Ubuntu 12 and eariler Debian
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
#
# For early Debian VM, make sure that the VM is upto date.
#
# Richard Eeske
# July 13th 2017
#
# 1.0 Inital release
# 1.1 Clean up and tuning : added logger

# check for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
	echo "Waagent reload : This script must be executed with super-user privileges." | tee /dev/tty | logger -s
	exit 1
fi
# check for service
if [ ! -e /usr/bin/service ]; then
	echo "Waagent reload : Wrong OS verion, missing service." | tee /dev/tty | logger -s
	exit 2
fi
service walinuxagent stop
	sleep 1
# Remove the waagent (force if needed)
apt-get purge walinuxagent -y
	sleep 5
#Double check to see if the binary is gone.
#print in the serila log if it needs to
if [ -e /usr/sbin/waagent ]; then
	rm /usr/sbin/waagent*
	echo "Waagent reload : Waagent found: Removing waagent binary" | tee /dev/tty | logger -s
fi
# Now, install the waagent
apt-get install walinuxagent -y
	sleep 5
# Lastly verify that the waagent is active
If
service walinuxagent start
echo `(service status walinuxagent | grep active)`
	sleep 1
# Show waagent version
Version=$(waagent -version | grep -i agent | cut -c1-19)
echo "$Version installed"  | tee /dev/tty | logger 
# End

