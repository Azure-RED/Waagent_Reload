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

# Test for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
        echo "This script must be executed with super-user privileges."
        exit 1
fi

# Check for systemctl
if [ ! -e /sbin/service ]; then
        echo "Wrong control verion, missing service utility."
        exit 2
fi

#show version number of current Waagent
echo $(/usr/sbin/waagent2.0 -version)

sudo /sbin/service waagent stop
sleep 1

# Remove the waagent (force if needed)
zypper -n rm python-azure-agent

# Double check to see if the binary is gone.
if [ -e /usr/sbin/waagent2.0 ]; then
        rm /usr/sbin/waagent*
        echo "Waagent2.0 found: Removing waagent2.0 binary"
fi

#Update the repo to get the latest waagent
sudo zypper -n refresh

# Now, install the waagent
sudo zypper -n install python-azure-agent
echo "** Waiting for completion. **"
sleep 15

# Lastly verify that the waagent is active
/usr/sbin/waagent2.0 -version

#set to run on boot
# When the agent is up and running then enable it to start on boot.
# Make sure waagent is on.
/sbin/chkconfig waagent on

# Verify that the waagent is enabled for the needed runlevels
/sbin/chkconfig | grep waagent
echo "** Complete **"

