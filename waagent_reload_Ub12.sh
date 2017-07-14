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


# check for root or sudo
if [[ "$(id -u)" -ne "$ROOTUID" ]] ; then
        echo "This script must be executed with super-user privileges."
        exit 1
fi
# check for service
if [ ! -e /usr/bin/service ]; then
        echo "Wrong OS verion, missing service utility."
        exit 2
fi
echo "Stopping waagent."
service walinuxagent stop
sleep 5
# Remove the waagent (force if needed)
apt-get purge walinuxagent -y
echo "** Wait for completion. **"
sleep 10
 
# Now, install the waagent
apt-get install walinuxagent -y
echo "** Wait for completion. **"
sleep 5

# Lastly verify that the waagent is active
If
service walinuxagent start
echo `(status walinuxagent | grep active)`
sleep 1
# When the agent is up and running then enable it to start on boot.
update-rc.d walinuxagent defaults

