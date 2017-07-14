#!/bin/bash

#
# Waagent reload script for Ubuntu 14+ and later Debian
# This script will remove Waagent and then reistall it.
# It will also enable the waagent on boot.
#
# Richard Eeske
# July 13th 2017



#check for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
        echo "This script must be executed with super-user privileges."
        exit 1
fi
#check for systemctl
if [ ! -e /bin/systemctl ]; then
        echo "Wrong OS verion, missing systemctl."
        exit 2
fi
systemctl stop walinuxagent
sleep 1
#Remove the waagent (force if needed)
apt-get purge walinuxagent -y
echo "** Wait for completion. **"
sleep 15

#Double check to see if the binary is gone.
#print in the serila log if it needs to

if [ -e /usr/sbin/waagent ]; then
        rm /usr/sbin/waagent*
        echo "Waagent found: Removing waagent binary"
fi
 
# Now, install the waagent
apt-get install walinuxagent -y
echo "** Wait for completion. **"
sleep 15

# Lastly verify that the waagent is active
systemctl start walinuxagent
echo `(systemctl status walinuxagent | grep active)`
sleep 1
# When the agent is up and running then enable it to start on boot.
systemctl enable walinuxagent.service

