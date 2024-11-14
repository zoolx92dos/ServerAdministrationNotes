## RHCE - RHEL 7 Notes

______________________________________________________________________________________

## Task 1

# Selinux must be in enforcing mode

# getenforce
View current mode of SELinux, if it isn't enforcing, set it to enforcing
by following steps below.

# vim /etc/selinux/config (OR) vim /etc/sysconfig/selinux
open any one of the configuration file of selinux via vim
SELINUX=enforcing
Change value to 'enforcing' as shown above
:wq!
Save your file and quit vim

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR NOT

Note: (Verfiy your changes as shown below)
# getenforce
Confirm your SELinux mode, it must be enforcing

______________________________________________________________________________________

## Task 2

# Configure SSH access. Users must have remote SSH access to your virtual systems from within example.com (172.25.X.0/24)
# Clients within my133t.org (172.24.0.0/16) should NOT have access to SSH Server running on your systems.

# firewall-cmd --list-all
Take an overview of current firewall settings (for default zone i.e. public)

# firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=172.25.X.0/24
service name=ssh accept'
To allow SSH Server access to users from example.com domain.

# firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=172.24.0.0/16
service name=ssh reject'
To deny SSH Server access to users from my133t.org domain.
Note: When no zone is explicitly specified by user (--zone=ZONE_NAME), then rule get
added to current default zone.

# firewall-cmd --reload
Reloading firewall with updated settings

# firewall-cmd --list-rich-rules
Confirm whether added rich rules exist or not

______________________________________________________________________________________

## Task 3

# Create a custom command called qstat on both systems. This command must be available to all the users on both the systems.
# qstat command does following: /bin/ps -Ao pid,tt,user,fname,rsz

# vim /usr/bin/qstat
Create qstat file and add content shown below

#!/bin/bash
/bin/ps -Ao pid,tt,user,fname,rsz
:wq
Save and quit

# chmod a+x /usr/bin/qstat
Give executable permission to all the users

# qstat
Execute to find whether command is working fine or not.

______________________________________________________________________________________

## Task 4

# Configure port forwaring on serverX according to the following requirements:
# The local port 5423 is forwarded to port 80 on serverX for systems in the 172.24.0.0/24 network.
# This setting must be available to all users on the system.
# All traffic of port number 2222 on serverX should be forwarded to 9898 port of serverX

# firewall-cmd --list-all
Take an overview of current firewall settings (for default zone i.e. public)

# firewall-cmd --permanent --add-masquerade
Configure masquerading for a zone

# firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=172.24.0.0/24 forward-port port=5423 protocol=tcp to-port=80'
Forwarding traffic to port number 80 which is coming from network 172.24.0.0/24 on your system port 5423

# firewall-cmd --permanent --add-forward-port=port=2222:proto=tcp:toport=9898
Forwarding all traffic to port number 9898 which is coming on your system port 2222

# firewall-cmd --reload
Reloading firewall with updated settings

# firewall-cmd --list-rich-rules
Confirm whether added rich rules exist or not

# firewall-cmd --list-forward-ports
Confirm whether added forwarding rules exist or not

# firewall-cmd --list-all
Confirm whether all added rules exist or not (Short Way)

______________________________________________________________________________________

## Task 5

# Configure link aggregation Configure a network link between serverX.example.com and desktopX.example.com according to the following requirements:
# The link uses the interfaces eno1 and eno2
# The link will continue to function even if one of the underlying interfaces or network is down
# The link interface on serverX has the address 192.168.0.100/255.255.255.0
# The link interface on desktopX has the address 192.168.0.200/255.255.255.0
# The link is active after a system reboot.

# ip link
# ip addr show
Query current state for the existing network interfaces

# nmcli con add con-name team0 type team ifname team0i config '{"runner":
{"name":"activebackup"}}'

# nmcli con mod team0 ipv4.addresses "192.168.0.100/24" ipv4.method manual (do this for
serverX only)
Configuring IPv4 address/Netmask and setting things to static

# nmcli con mod team0 ipv4.addresses "192.168.0.200/24" ipv4.method manual (do this for
desktopX only)
Configuring IPv4 address/Netmask and setting things to static
Note: There is no need to mention "connection.autoconnect yes", becuase that's the default.

# nmcli con add con-name team0-slave1 type team-slave ifname eno1 master team0i
Adding slave1 to team0 interface i.e. eno1

# nmcli con add con-name team0-slave2 type team-slave ifname eno2 master team0i
Adding slave2 to team0 interface i.e. eno2
Note:
To bring team0 interface up bring one or more slave interfaces up
To bring team0 interface down, just bring team0 down (will automatically bring down the slave interfaces down)
# nmcli con up team0
Bring team0 interface up with all the newly applied settings.
Execution makes sense if one or more slave interfaces are up, otherwise meaningless

# teamdctl team0i state
Check the current state fo the teamed interfaces on the system

# ping -I team0i 192.168.0.100
# ping -I team0i 192.168.0.200
# ping -I team0i 192.168.0.254 (hidden host in hidden namespace)
Execute both after configuring on both the systems, to find whether everything is working fine or not.

______________________________________________________________________________________

## Task 6

# Configure IPv6 addresses Configure the eth0 on your exam systems with the following
# IPv6 addresses:
# serverX should have the address 2001:ac18::132/64
# desktopX should have the address 2001:ac18::13c/64
# Both systems should be reachable from systems in the 2001:ac18/64 network.
# The address assignments should persist across system reboots.
# Both systems must also remain reachable via IPv4 at their current addresses

# nmcli con show
List current connections

# nmcli con mod "System eth0" ipv6.addresses 2001:ac18::132/64 ipv6.method manual
(only on serverX system)
Configure ipv6 on serverX

# nmcli con mod "System eth0" ipv6.addresses 2001:ac18::13c/64 ipv6.method manual
(only on desktopX system)
Configure ipv6 on desktopX

# nmcli con down "System eth0"
# nmcli con up "System eth0"
Restarting interface eth0 to upload new settings

# ip addr show dev eth0
Confirm the interface configuration, must show both ipv4 and ipv6 addresses

# ping -I eth0 172.25.X.11 (server IP)
# ping -I eth0 172.25.X.10 (desktop IP)
# ping6 -I eth0 2001:ac18::132 (server IP)
# ping6 -I eth0 2001:ac18::13c (desktop IP)
Ping to all four destinations from both the systems, to find out whether everything is
working or not.

______________________________________________________________________________________

## Task 7

# Configure local mail server on both the systems as null client according to the following requirements:
# The systems do not accept incoming email from external sources.
# Any mail sent locally on these systems is automatically forwarded to and relayed via smtpX.example.com
# You may test your configuration by sending email to the local user student@desktopX.example.com
# Mail sent from these systems shows up as coming from desktopX.example.com
# Note: In Exam you can check your email by clicking on the link given at bottom of the question

# yum -y install postfix

# systemctl enable postfix

# systemctl start postfix

# firewall-cmd --permanent --add-service=smtp

# firewall-cmd --reload

# postconf -e "relayhost=[smtpX.example.com]"
Configuring mail server responsible for relaying messages to the mail server of the intended receipient.
relayhost name is enclosed in square brackets to prevent an MX record lookup with the DNS Server

# postconf -e "inet_interfaces=loopback-only"
Making null client listen on loopback interface only, to make sure it does not accept incoming email from external sources configured on other interfaces.

# postconf -e "mynetworks=127.0.0.0/8 [::1]/128"
Making sure only messages originating form local system to be forwarded to the relay host Which hosts can relay there messages through this null client (only localhost)

# postconf -e "myorigin=desktop1.example.com"
Setting desktop1.example.com as organisation's domain name on outgoing mail
Domain name to be mentioned in FROM: field, when viewed by recepient.

# postconf -e "mydestination="
Configure which domain the local mail server is an end point for. Email addressed to
these domains are delievered into the local mailboxes. Here in case no end point i.e. we have to left this field blank

# postconf -e "local_transport=error: local delivery disabled"
Prevent local null client from sorting any mail into mailboxes on the serverX system
Setting this to error disables the local delivery completely.

# systemctl restart postfix
# mail -s "serverX null client" student@desktopX.example.com
null client test
.
EOT
Send a test mail to student@desktopX.example.com to find everything is working fine or not.

$ mutt -f imaps://imapX.example.com
Username: student
Password: student
Verify the message arrived in the mail account of student, then exit mutt with q key.

[[CONFIGURE ON desktopX VIRTUAL MACHINE)]]
Repeat the same steps on desktopX virtual machine

______________________________________________________________________________________

## Task 8

# Configure SMB services on server as follows:
# Your SMB server must be a member of the STAFF workgroup
# The service must share the /groupdir directory. The share's name must be common2
# The common2 share must be available to example.com domain clients only
# The common2 share must be browseable
# The user barney must have read access to the share, authencating with the password "redhat" if necessary

# yum -y install samba

# systemctl enable smb nmb

# systemctl start smb nmb
This will start process daemon:
smbd (listening on TCP/445 for SMB Connections and TCP/139 for NetBIOS over TCP for backward compatibility)
nmbd (listening on UDP/137 UDP/138 to provide NetBIOS over TCP/IP network browsing support)

# firewall-cmd --permanent --add-service=samba

# firewall-cmd --reload

# mkdir -p /groupdir

# semanage fcontext -a -t samba_share_t '/groupdir(/.*)?'

# restorecon -vvFR /groupdir

# vim /etc/samba/smb.conf

[global]
workgroup = STAFF
hosts allow = 127. .example.com

[common2]
path = /groupdir
valid users = barney

:wq

# yum -y install samba-client

# useradd -s /sbin/nologin barney (if samba only user is asked)
Note: This is not required if user barney already exist

# smbpasswd -a barney
New SMB password: redhat
Retype new SMB password: redhat
Added user barney

[[VERIFY(OPTIONAL) ON serverX/desktopX VIRTUAL MACHINE)]]

# yum -y install cifs-utils

# smbclient -L //server0/common2 -U barney
Verifying whether browserable or not, sharename common2 must get displayed

# mkdir /mnt/barney

# mount -o username=barney //server0/common2 /mnt/barney
Password for barney@//server0/common2: redhat
Verify whether barney has only read access to samba share by creating a blank file
And share must not be accessible to any other user.

______________________________________________________________________________________

## Task 9

# Create a multiuser SMB mount on server and share the /data directory as follows:
# The share should be named data
# The data share must only be available to clients within example.com domain
# The data share must be browseable
# harry must have read access to the share, authenticating with the password "redhat"
# sarah must have read and write access to the share, authenticating with the password "redhat"
# The SMB share is permanently mounted on desktop at /mnt/multi using the credentials of harry.
# The share must allow anyone who can authenticate as sarah to temporarily acquire write permissions.

# mkdir /data

# semanage fcontext -a -t samba_share_t '/data(/.*)?'

# restorecon -vvFR /data

# vim /etc/samba/smb.conf

Note: Here I'm adding to previous configuration done in above question, showing only
changes

[data]
path = /data
write list = sarah
valid users = harry, sarah

:wq

# useradd -s /sbin/nologin harry (if samba only user is asked)
Note: This is not required if user harry already exist

# smbpasswd -a harry
New SMB password: redhat
Retype new SMB password: redhat
Added user harry

# useradd -s /sbin/nologin sarah (if samba only user is asked)
Note: This is not required if user sarah already exist

# smbpasswd -a sarah
New SMB password: redhat
Retype new SMB password: redhat
Added user sarah

[[CONFIGURE ON desktopX VIRTUAL MACHINE)]]
Note: Most probably user harry and sarah must be existing on desktop machine, otherwise create them, give them a proper shell, and a password (if specified any), becuase it's a necessary  requrirement on desktop side. Here we have considered they already exist.

# yum -y install cifs-utils

# mkdir /mnt/multi

# vim /root/multicreds.txt

username=harry
password=redhat

:wq

# chmod 600 /root/multicreds.txt

# vim /etc/fstab

//serverX/data   /mnt/multi   cifs   credentials=/root/multicreds.txt,multiuser,sec=ntlmssp 0 0
:wq

# su - sarah

$ touch /mnt/multi/testfile.sarah
touch: cannot touch 'tesfile.sarah': Permission Denied

$ cifscreds add server0
Password: redhat

$ touch /mnt/multi/testfile.sarah
Now file must be created

$ echo "I can write to this share" >> /mnt/multi/testfile.sarah
$ cat /mnt/multi/testfile.sarah
I can write to this share

$ exit
# su - harry

$ cifscreds add server0
Password: redhat

$ touch /mnt/multi/testfile.harry
touch: cannot touch 'testfile.harry': Permission Denied

______________________________________________________________________________________

## Task 10

# Configure NFS Server as follows:
# Export the /public directory with read only access to the example.com domain only
# Export the /protected directory with read/write access to the example.com domain only
# Access to /protected should be secured by kerberos. You can use the keytab at http://classroom.example.com/pub/keytabs/serverX.keytab
# The /protected should contain a sub-directory named restricted that is owned by ldapuserX (X means your system number).
# ldapuserX (password should be used "kerberos") should have read/write access to /protected restricted

==== Exporting /public directory ====

# yum -y install nfs-utils

# systemctl enable nfs-server

# systemctl start nfs-server

# mkdir /public

# vim /etc/exports.d/public.exports

/public  *.example.com(ro)

:wq

# exportfs -arv (r = re-export, a = export all, v = verbosity)

# firewall-cmd --permanent --add-service=nfs
Opening NFS Port 2049/TCP for nfsd

# firewall-cmd --reload
Reloading firewall with newly configured rules

==== Exported /public directory ====

==== Exporting /protected directory ====

# wget -O /etc/krb5.keytab "http://classroom.example.com/pub/keytabs/serverX.keytab"

# systemctl enable nfs-secure-server

# systemctl start nfs-secure-server

# mkdir -p /protected/restricted

# chown ldapuserX /protected/restricted

# chmod 755 /protected/restricted (required only if not 755, which is default for directories)

# vim /etc/exports.d/protected.exports
/protected   *.example.com(rw,sec=krb5p)

:wq

# exportfs -arv (r = re-export, a = export all, v = verbosity)

==== Exported /protected directory ====

______________________________________________________________________________________

## Task 11

# Configure desktopX to mount the following:
# NFS share from serverX.example.com:/public should be mounted to /mnt/nfsmount
# /protected should be mounted to /mnt/nfssecure using keytab at http://classroom.example.com/pub/keytabs/desktopX.keytab
# ldapuserX should be able to create files in /mnt/nfssecure/restricted
# The files systems should automatically be mounted at boot.

==== Mounting /public directory ====

# mkdir /mnt/nfsmount

# vim /etc/fstab
serverX.example.com:/public   /mnt/nfsmount   nfs   defaults   0   0
:wq

# mount -a

==== Mounted /public directory ====

==== Mounting /protected directory ====

# wget -O /etc/krb5.keytab "http://classroom.example.com/pub/keytabs/desktopX.keytab"

# yum -y install nfs-utils

# systemctl enable nfs-secure

# systemctl start nfs-secure

# mkdir /mnt/nfssecure

# vim /etc/fstab

serverX.example.com:/protected   /mnt/nfssecure   nfs   defaults,sec=krb5p   0   0
:wq

# mount -a

# ssh ldapuser0@desktopX
Login via password "kerberos" to find whether content is accessible to you in rw mode
or not. It must be.

==== Mounted /protected directory ====

______________________________________________________________________________________

## Task 12

# Create a script on your serverX machine named /root/script.sh that does the following:
# When run as "/root/script.sh all" it produces the output "none" on stdout
# When run as "/root/script.sh none" it produces output "all" on stdout
# When run without arguments or any other argument other than all or none, it sends the
# following output to stderr:
# /root/script.sh all|none

# vim /root/script.sh
Create and open file using vim editor and insert the following

#!/bin/bash
case $1 in
all)
echo "none"
;;
none)
echo "all"
;;
*)
echo "Usage: /root/script.sh all|none"
;;
esac
:wq

Save and quit vim editor

# chmod a+x /root/script.sh
Give executable permission to the script

# /root/script.sh all

# /root/script.sh none

# /root/script.sh anything

# /root/script.sh
Check all the above four test cases, to find whether script is working fine or not

______________________________________________________________________________________

## Task 13

# Create a script for adding users on your serverX machine named "/root/makeusers".
# Given a file containing a list of usernames. as argument to script "/root/makeusers" must result in creation of accounts listed in the file named "testfile". Additionally:
# The script should requires a single argument which is the name of the file that contains the list of usernames.
# If no argument is supplied, script should display the message "Usage: /root/makeusers" and exit with an appropriate values.
# If a non-existent file is specified as input, the script should display the message "Input
# File Not Found" and exit with an appropriate value.
# User accounts should be created with a login shell of "/bin/false".
# The script does not need to set the passwords for the accounts.
# You can download the "testfile" containing list of usernames from http://classroom.example.com/pub/testfile for testing your script.
# It is not necessary to delete the user accounts listed in this file once you have tested your script but you may do so if you choose to.

# vim /root/makeusers
Create and open file using vim editor and insert the following

#!/bin/bash
if [[ -z $1 ]]; then
FILEARGS=$1
else
FILEARGS=`basename $1`
fi
case $FILEARGS in
testfile)
for USERNAME in `cat testfile`
do
useradd -s /bin/false $USERNAME;
done
;;
"")
echo "Usage: /root/makeusers"
exit 2
;;
*)
echo "Input File Not Found"
exit 3
;;
esac
:wq

Save and quit vim editor

# chmod a+x /root/makeusers
Give executable permission to the script makeusers

# wget -c "http://classroom.example.com/pub/testfile
Download the testfile containing usernames
# /root/makeusers /root/testfile
# /root/makeusers nosuchfile
# /root/makeusers
Check all the above three test cases, to find whether script is working fine or not

______________________________________________________________________________________
