# Waagent_Reload

##These scripts are to reload waagent from various Linux distros. 

More importantly, these scripts automate the removal and re-installation of the Waagent from the VM.   The scripts are built for five common variations of Linux in Azure.

###Note:
   - They need to be run as superuser and I will error out if not.
   - There are no extra arguments (at this time).
   - All but the Sles script expects a upto date repos     
   - All script will log the changes in /var/log/message or syslog 
   
##The scripts are:
   - RHEL/CentOS 6x (using service for process control)
   - RHEL/ CentOS 7x (using systemctl for process control)
   - Ubuntu 12-14 (using service for process control)
   - Ubuntu 16x (using systemctl for process control)
   - Sles 11 sp4 (using service for process control)


CentOS will remove the binaries and active files for Waagent.
For Ubuntu VM there is an added benefit the apt-get handler purge option to remove the binaries and library files.
