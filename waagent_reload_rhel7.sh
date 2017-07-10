#!/bin/bash

#
# Waagent reload script for Redhat and CentOS 7+
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
# 
# Richard Eeske
#

# Test for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
	echo "This script must be executed with super-user privileges."
	exit 1
fi

# check for systemctl
if [ ! -e /bin/systemctl ]; then
        echo "Wrong OS verion, missing systemctl."
        exit 2
fi

# Stop and wait for waagent to stop
systemctl stop waagent
sleep 1

# Remove the waagent
yum remove WALinuxAgent.noarch -y
echo "** Wait for completion. **"
sleep 15

# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent ]; then
        rm /usr/sbin/waagent*
        echo "Waagent found: Removing waagent binary"
fi
 
# Now install the waagent
yum install WALinuxAgent.noarch -y
echo "** Wait for completion. **"
sleep 15

# Lastly verify that the waagent is active
systemctl start waagent
echo `(systemctl status waagent | grep active)`
sleep 1

# When the agent is up and running then enable it to start on boot.
systemctl enable waagent

# End
