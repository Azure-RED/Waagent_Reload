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

# Test for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
        echo "This script must be executed with super-user privileges."
        exit 1
fi

# Check for systemctl
if [ ! -e /sbin/service ]; then
        echo "Wrong OS verion, missing service utility."
        exit 1
fi

sudo service waagent stop
sleep 1

# Remove the waagent (force if needed)
yum remove WALinuxAgent.noarch -y
echo "** Wait for completion. **"
sleep 15

# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent ]; then
        rm /usr/sbin/waagent*
        echo "Waagent found: Removing waagent binary"
fi
 
# Now, install the waagent
yum install WALinuxAgent.noarch -y
echo "** Wait for completion. **"
sleep 15

# Lastly verify that the waagent is active
service waagent start
echo `(service waagent status | grep running)`
sleep 1

# When the agent is up and running then enable it to start on boot.
# Make sure waagent is on.
chkconfig waagent on

# Verify that the waagent is enabled for the needed runlevels
chkconfig | grep waagent
