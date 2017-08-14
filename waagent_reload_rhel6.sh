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
        logger -s "This script must be executed with super-user privileges."
        exit 1
fi

# Check for systemctl
if [ ! -e /sbin/service ]; then
        logger -s"Wrong OS verion, missing service utility."
        exit 2
fi

sudo service waagent stop
echo "Please wait."
sleep 1

# Remove the waagent (force if needed)
yum remove WALinuxAgent.noarch -y
logger "** Wait for completion. **"
sleep 5

# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent ]; then
        rm /usr/sbin/waagent*
        logger "Waagent found: Removing waagent binary"
fi

# Now, install the waagent
yum install WALinuxAgent.noarch -y
logger "** Wait for completion. **"
sleep 5

# Lastly verify that the waagent is active
service waagent start
logger $(service waagent status | grep running)
sleep 1

# When the agent is up and running then enable it to start on boot.
# Make sure waagent is on.
logger $(chkconfig waagent on)

# Verify that the waagent is enabled for the needed runlevels
logger $(chkconfig | grep waagent)
Version=$(waagent -version | grep Agent | cut -c1-19)
logger "$Version installed"
echo "Reinstall Script Complete."
