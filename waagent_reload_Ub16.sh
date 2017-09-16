#!/bin/bash
#
# Waagent reload script for Ubuntu 14+ and later Debian
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
#
# Richard Eeske
# July 13th 2017
#
# 1.0 Inital release
# 1.1 Clean up and tuning : added logger
#
#check for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
	echo "Waagent reload : This script must be executed with super-user privileges." | tee /dev/tty | logger -s
	exit 1
fi
#check for systemctl
if [ ! -e /bin/systemctl ]; then
	echo "Waagent reload : Wrong OS verion, missing systemctl." | tee /dev/tty | logger -s
	exit 2
fi
systemctl stop walinuxagent
	sleep 1
#Remove the waagent (force if needed)....
apt-get purge walinuxagent -y
	sleep 1
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
systemctl start walinuxagent.service
echo  "Waagent reload : waagent status." $(systemctl status walinuxagent.service | grep active) | tee /dev/tty | logger
	sleep 1
# When the agent is up and running then enable it to start on boot.
systemctl enable walinuxagent.service
Version=$(waagent -version | grep -i agent | cut -c1-19)
echo "Waagent reload : $Version installed" | tee /dev/tty | logger
# End
