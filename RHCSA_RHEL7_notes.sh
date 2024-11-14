## RHEL 7 - RHCSA Notes

____________________________________________________________________________________________

## Task 1
# Breaking root password
# The password for the root account of your serverX.example.com will be your full name.

REBOOT your vitual machine serverX.example.com
At boot prompt edit the first entry by pressing [[e]] key on your keyboard
Go to line starting with keyword 'linux16' and press key [[End]] on you keyboard (this is not not there in RHEL 9)
Press [[space]] and add keyword 'rd.break'
Then press [[Ctrl + x]]
Let the system boot till you get a root prompt and then enter following commands:
# mount -o remount,rw /sysroot
# mount | grep -iw sysroot
(Check presence of 'rw' keyword in result)
# chroot /sysroot
# passwd root
# Enter Password : your_fullname
# Confirm Password : your_fullname
# touch /.autorelabel
# exit
# exit

____________________________________________________________________________________________

## Task 2
# The IP addresses for your systems are provided by your DHCP Server 'classroom.example.com'. Reconfigure your systems to use static IP addresses you should use the following settings:
# -serverX.example.com: 172.25.X.11
# -desktopX.example.com: 172.25.X.10
# The network mask for all systems is 255.255.255.0 and
# Name server : 172.25.254.254 , Gateway : 172.25.254.250
# classroom.example.com provides centralized authentication services for the realm EXAMPLE.COM. X is # your station number or IP .
# Your IP should be static on both server and desktop (same which is obtain from DHCP Server 
# 'classroom.example.com')

# nmcli con show
To see the "NAME" of your connection
# nmcli con show "NAME"
See the details of your connection, like ipv4 addr, gateway, dns, method etc.
# nmcli con show "NAME" > ~/Desktop/nwsettings.txt (OPTIONAL STEP)
Save current network setting on Desktop to view it later, when required.
Note: Do this step, only if it make things simpler for you.
# nmcli con mod "NAME" ipv4.addresses "IPV4/NETMASK GATEWAY" ipv4.dns "DNS" ipv4.method manual connection.autoconnect yes
Set the network settings as given
#nmcli con down "NAME"
Bring down the connection to read new settings
# nmcli con up "NAME"
Bring up the connection to apply new settings
# nmcli con show "NAME"
Verify values of all attributes like ip, netmask, gateway, dns, connection.autconnect and ipv4.method

____________________________________________________________________________________________

## Task 3
# Set the hostname of your system to serverX.example.com ( where X is your station number or IP )

# hostnamectl
View your hostname
# hostnamectl set-hostname serverX.example.com
Set you hostname to serverX.example.com
# hostnamectl
Verify your hostname
# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR NOT
Note:(Confirm your IP and HOSTNAME)

____________________________________________________________________________________________

## Task 4
# The YUM repository for your system exist at following location
# 'http://content.example.com/rhel7.0/x86_64/dvd'. Configure YUM repository.

# vim /etc/yum.repos.d/serverX.repo
Create and open a new repo file via vim and add the following lines:
[serverX]
name=serverX YUM Repo for RHCSA Exam
baseurl=http://content.example.com/rhel7.0/x86_64/dvd
enabled=1
gpgcheck=0
:wq
Save your file and quit vim
# yum repolist
Verify everthing is alright

____________________________________________________________________________________________

## Task 5
# Set SELinux in Enforcing mode on both serverX and desktopX.

# getenforce
View current mode of SELinux, if it isn't enforcing, set it to enforcing
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

____________________________________________________________________________________________

## Task 7

# Create a simple partition of 50MB on vdb disk on serverX.example.com and Format it with ext4 
# filesystem. Mount it on /common directory. Partition should be automatically mounted upon reboot.

# fdisk -l /dev/vdb
Overview of all the partitions on your vdb disk

# fdisk /dev/vdb
Command (m for help): n
Select (default p): e

ATTENTION: extended partition(e) is created only once, from now onwards you will be creating logical partitions(l) within extended partition. So adjust in your scenario accordingly.

Partition number (1-4, default 1):
First sector (2048-20971519, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519):

Command (m for help): n
Select (default p): l
First sector (4096-20971519, default 4096):
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519): +50M
Command (m for help): w

# partprobe /dev/vdb
make the kernel aware of the partition table change
# lsblk
It list all the partitions, their sizes, whether they are mounted, and if they do, then the respective mountpoint.
Note: Verify the work done above, new partition must be shown here with size 50MB

# mkfs.ext4 /dev/vdb?
where ? is your partition number you created with size 50MB

# blkid | grep vdb?
where ? is your partition number you created with size 50MB
Copy UUID="93d9ea76-48c1-44e8-9ade-570ae2ef2d69" string from your output
Note: It may be different on your machine

# vim /etc/fstab
Open fstab file for editing via vim and add the line starting from keyword 'UUID' shown below:
#[filesystem UUID]    [mountpoint]    [filesystem type]    [mount options]    [dump]    [pass]
UUID=93d9ea76-48c1-44e8-9ade-570ae2ef2d69  /common   ext4   defaults    0   0

# mkdir /common
Create directory where the partition is to be mounted

# mount -a
Mount all the partitions listed in /etc/fstab file.
Note: This command should report no errors. If it does check your settings in /etc/fstab

# lsblk
Verify your changes
It list all the partitions, their sizes, whether they are mounted, and if they do, then the respective mountpoint.

# mount | grep vdb?
Verify whether partition is mounted or not

____________________________________________________________________________________________

## Task 8

# Create a logical volume named as database of 20PE size in volume group datastore.
# Each PE of 8 MB. Apply ext4 filesystem on it. Mount permanently on /mnt/database.

# fdisk /dev/vdb
Command (m for help): n

Select (default p): l
First sector (1054720-20971519, default 1054720):
Using default value 1054720
Last sector, +sectors or +size{K,M,G} (1054720-20971519, default 20971519): +200M

Command (m for help): p

Command (m for help): t
Partition number (1,5,6, default 6):
Hex code (type L to list all codes): 8e

Command (m for help): p

Command (m for help): w

# partprobe /dev/vdb
make the kernel aware of the partition table change

# pvcreate /dev/vdb?

# vgcreate -s 8M datastore /dev/vdb?

# pvdisplay /dev/vdb?
# vgdisplay datastore
Verify whether the size of PE is 8M or not

# lvcreate -n database -l 20 datastore

# lvdisplay /dev/mapper/datastore-database
Verify whether size of logical volume is displayed as 160 MiB

# mkfs.ext4 /dev/mapper/datastore-database
format with ext4 filesystem

# mkdir /mnt/database
create directory for mounting and accessing logical volume datastore

# blkid
Determine the UUID of the new logical volume /dev/mapper/datastore-database and copy it.

# vim /etc/fstab
Add an entry to /etc/fstab to mount logical volume automatically on boot
UUID=768ac722-02c8-498a-ad14-d6bd3aae9e05 /mnt/database ext4 defaults 0 0
:wq
save and exit vim editor

# mount -a
Mount all the partitions listed in /etc/fstab file.
Note: This command should report no errors. If it does check your settings in /etc/fstab

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR NOT
Note:(Confirm logical volume is getting mounted or not)

____________________________________________________________________________________________

## Task 9

# Resize the logical volume lv1 and its filesystem to 300 MiB. Make sure that the file system contents remain intact.
# Note: partitions are seldom exactly the same size requested, so a size within the range of 270 MiB to 330 MiB is acceptable.

# lvs
Check initial size of lv1 before going forward with question.
Note: From initial size and current size (in your question)
try to determine you are going for reduction or extension

# lvresize -t -L 300M /dev/resizeit/lv1 -r
Running in test mode to find, whether command will run successfully,
without making any changes to system

# lvresize -L 300M /dev/resizeit/lv1 -r
Resizing lvm's (extending ext4 filesystem in this question)
Note: You may use lvextend in place of lvresize, if you want.

# lvs
Check your final size, as mentioned in your question.

# lsblk
It list all the partitions, their sizes, whether they are mounted,
and if they do, then the respective mountpoint.
Note: Verify/Confirm new size by running above two commands

____________________________________________________________________________________________

## Task 10

# Resize the logical volume lv2 and its filesystem to 260 MiB. Make sure that the file system contents remain intact.
# Note: partitions are seldom exactly the same size requested, so a size within the range of 230 MiB to 290 MiB is acceptable.

# lvs
Check initial size of lv2 before going forward with question.
Note: From initial size and current size (in your question)
try to determine you are going for reduction or extension

# lvresize -t -L 260M /dev/resizeit/lv2 -r
Running in test mode to find, whether command will run successfully,
without making any changes to system

# lvresize -L 260M /dev/resizeit/lv2 -r
Resizing lvm's (extending xfs filesystem in this question)
Note: You may use lvextend in place of lvresize, if you want.
Note: you may be getting some error/warning at this step, read it and use your common sense.
Hint: solve the question given below first and then comeback to solve this question. By doing that you'll release some space first, and then you can extend the lv lv2

# lvs
Check your final size, as mentioned in your question.

# lsblk
It list all the partitions, their sizes, whether they are mounted, and if they do, then the respective mountpoint.
Note: Verify/Confirm new size by running above two commands

____________________________________________________________________________________________

## Task 11

# Resize the logical volume lv3 and its filesystem to 300 MiB. Make sure that the filesystem contents remain intact.
# Note: partitions are seldom exactly the same size requested, so a size within the range of 270 MiB to 330 MiB is acceptable.

# lvs
Check initial size of lv2 before going forward with question.
Note: From initial size and current size (in your question)
try to determine you are going for reduction or extension

# lvresize -t -L 300M /dev/resizeit/lv3 -r
Running in test mode to find, whether command will run successfully,
without making any changes to system

# umount /dev/mapper/resizeit-lv3

# umount /dev/mapper/resizeit-lv3
Unmount multiple times to be sure that the logical volume is unmounted
Please unmount the partition before reducing, its important.

# lvresize -L 300M /dev/resizeit/lv3 -r
Resizing lvm's (reducing ext4 filesystem in this question)
Note: You may use lvreduce in place of lvresize, if you want.
Note: If you find something like this, then press [[y]] on your keyboard
Do you want to unmount "/resizeit/lv3"? [Y|n] y

# mount -a
Mount all the partitions listed in /etc/fstab file.
Note: This command should report no errors. If it does check your settings in /etc/fstab

# lvs
Check your final size, as mentioned in your question.

# lsblk
It list all the partitions, their sizes, whether they are mounted, and if they do, then the respective mountpoint.
Note: Verify/Confirm new size by running above two commands

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR NOT

____________________________________________________________________________________________

## Task 12

# Create the following users and groups and preform listed user management tasks:
# A group named 'adminuser'
# A user 'natasha' who belongs to 'adminuser' as a secondary group
# A user 'harry' who also belongs to 'adminuser' as a secondary group
# A user 'sarah' who does not have access to an 'interactive shell' on the system, and who is not a member of 'adminuser'.
# User natasha, harry and sarah should all have the password 'password'.

# groupadd adminuser
# useradd -G adminuser natasha
# useradd -G adminuser harry
# useradd -s /sbin/nologin sarah
# echo "password" | passwd --stdin natasha
# echo "password" | passwd --stdin harry
# echo "password" | passwd --stdin sarah
# less /etc/passwd
Verify your changes
# less /etc/group
Verify your changes

____________________________________________________________________________________________

## Task 13

# Create user 'user1', 'user2', 'user3' with password 'redhat'
# User 'user3' should have uid=1600 .
# Create group named 'admin' Make 'user1', 'user2', belong to 'admin' group, but 'user3' should not be a member of 'admin' group.
# Create a Directroy /common/data Change the group owner of /common/data to 'admin' group.
# Give permission to /common/data as below:
# Owner full permission
# Group full permission
# Other no permission
# Whenever a user creates a file/dir inside /common/data, make that file/dir automatically belong to group 'admin'.
# Whenever user creates a file/dir only that user(i.e. owner) can removes those files/dirs.

# useradd user1
# useradd uesr2
# useradd user3
# echo "redhat" | passwd --stdin user1
# echo "redhat" | passwd --stdin user2
# echo "redhat" | passwd --stdin user3
# usermod -u 1600 user3
# groupadd admin
# usermod -G admin user1
# usermod -G admin user2
# mkdir /common/data
# chgrp admin /common/data
# chmod 770 /common/data
# chmod g+s /common/data
Applying SGID BIT
# chmod o+t /common/data
Applying STICKY BIT

____________________________________________________________________________________________

## Task 14

# Copy the file /etc/fstab to /var/tmp/fstab.
# Configure the permissions of /var/tmp/fstab so that the file /var/tmp/fstab is owned by the 'root' user.
# The file /var/tmp/fstab belongs to the group 'root'.
# The file /var/tmp/fstab should not be executable by anyone.
# The user 'natasha' is able to read and write /var/tmp/fstab.
# The user 'harry' can neither write nor read /var/tmp/fstab.
# All other users (current or future) have the ability to read /var/tmp/fstab.

# cp /etc/fstab /var/tmp/
copying file to given location
# ls -l /var/tmp/fstab
listing file meta information, verify owner as 'root', group owner as 'root'
# chown root:root /var/tmp/fstab
Note: do only if needed
# chmod a-x /var/tmp/fstab
Note: do only if needed
# setfacl -m u:natasha:rw /var/tmp/fstab
# setfacl -m u:harry:- /var/tmp/fstab
# chmod o+r /var/tmp/fstab
Note: do only if needed
# getfacl /var/tmp/fstab

____________________________________________________________________________________________

## Task 15

# Configure a cron job. User 'natasha' must configure a cron job that runs daily at 14:23 local time and executes: /bin/echo hiya

# crontab -e -u natasha

23 14 * * * /bin/echo "hiya"
add the above line

:wq
save and quit vim editor

# crontab -l -u 'natasha'
list the configured cron job to verify

____________________________________________________________________________________________

## Task 16

# Create a collaborative directory /home/admins with the following characteristics:
# Group ownership of /home/admins is adminuser
# The directory should be readable, writable and accessible to members of adminuser, but not to any other user.
# (It is understood that root has access to all files and directories on the system.)
# Files created in /home/admins automatically have group ownership set to the adminuser group .

# mkdir /home/admins
# chgrp adminuser /home/admins

# chmod 770 /home/admins
# chmod g+s /home/admins
Applying SGID BIT
# touch /home/admins/testfile
# ls -l /home/admins/testfile
Verify the behaviour by executing above two commands (if needed)

____________________________________________________________________________________________

## Task 17

# Kernel update
# Install the appropriate kernel update from address given below. The following criteria must be met. The updated kernel is the default kernel when the system is rebooted. The original kernel remains available and bootable on the system.
# Please install new kernel from following location:
# http://content.example.com/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm

# rpm -q kernel (OR) # yum list installed kernel
Quering and listing installed kernel packages

# uname -r
Verifying active kernel
Match the output of above two commands and note down the kernel version somewhere (to verify later whether it got replaced by new kernel version or not).

# cd ~/Desktop (OPTIONAL STEP)
For downloading kernel on your desktop If you ain't downloading it on your desktop, then download it wherever you want providing that you know what you are doing.

# wget -c "http://content.example.com/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm"

Downloading required kernel
# rpm -ivh "downloaded kernel file path"
Installing or Updating kernel

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM
Note: Boot via newly installed kernel by choosing appropriate boot menu entry

# uname -r
Verifying whether newly installed kernel is active and listed
____________________________________________________________________________________________

## Task 18

# Configure NTP
# Configure your system so that it is an NTP client of classroom.example.com

# yum install chrony
Install the required package for configuring ntp client

# systemctl enable chronyd.service
Enable NTP Client at boot time

# systemctl is-enabled chronyd.service
Verify whether enabled at boot time

# vim /etc/chrony.conf
Edit configuration file of NTP Client
Comment/Disable first 4 server lines by adding '#' symbol in the beggining of the line.
Add the line given below:

server classroom.example.com iburst

:wq
save and quit vim editor

# timedatectl
Check current local time and whether NTP is disabled or enabled

# timedatectl set-ntp true (if NTP is disabled)
# timedatectl set-ntp true (if NTP is disabled)

Note: Run the above command twice as shown if NTP was listed disabled previously
Note: Ignore any Access Denied Error Message, that is a bug in RHEL7 which also existed in Fedora (i guess till version 21, got fixed from 22 onwards). Go search internet for more details.

# systemctl start chronyd.service
Start NTP Client for current session

# systemctl status chronyd.service
Check whether running or not

# systemctl restart chronyd.service
Restart NTP Client for current session

# chronyc sources -v
Check if '^* classroom.example.com' is listed in output or not
If listed, everything is working fine.

# timedatectl
Verify whether NTP is synchronized or not. It takes 30-60 sec to synchronize time with NTP Server, so verify again if needed.

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR NOT

____________________________________________________________________________________________

## Task 19

# Bind to an external authentication service.
# The system classroom.example.com provides an LDAP authentication service.
# Your system should bind to this service as follows:
# The base DN for the authentication service is: dc=example,dc=com.
# LDAP is used to provide both account information and authentication information.
# The connection should be encrypted using the certificate at http://classroom.example.com/pub/example-ca.crt
# When properly configured, ldapuserX should be able to log into your system, but will not have a home directory until you have completed the autofs requirement.
# ldapuserX's password is "password"

# yum install authconfig-gtk sssd

# systemctl enable sssd
Enable sssd at boot

# systemctl is-enabled sssd
Verify whether enabled or not

# authconfig-gtk
Open graphical window for configuring LDAP authentication
Authentication Configuration (Under Graphical Window)
User Account Database: LDAP
LDAP Search Base DN: dc=example,dc=com
LDAP Server: ldap://classroom.example.com
Use TLS to encrypt connections: Yes
Download CA Certificate: http://classroom.example.com/pub/example-ca.crt
Authentication Method: LDAP password
Press [[Apply]] Button

# systemctl status sssd
It must be running

# systemctl start sssd
Note: Execute this, if sssd status in above option is not running

# systemctl restart sssd
You may restart your service if you want, or if it is required.

# getent passwd ldapuserX
This command must show the cached information of ldapuserX user.
The information displayed will be similar to the entries listed in /etc/passwd file
Note: cached info of users (in our case ldapuserX) exist in /var/lib/sss/ directory

# ssh ldapuserX@localhost
Login to verify your password and find whether ldapuserX is getting any shell or not.
You must get one.

____________________________________________________________________________________________

## Task 20

# Configure autofs
# Configure autofs to automount the home directories of LDAP users as follows:
# classroom.example.com(172.25.254.254) NFS-exports /home/guests to your system. This
# filesystem contains a pre-configured home directory for the user ldapuserX.
# ldapuserX's home directory is classroom.example.com:/home/guests/ldapuserX.
# ldapuserX's home directory should be automounted locally beneath /home/guests as /home/guests/ldapuserX
# Home directories must be writable by their users.
# ldapuserX's password is password.

# yum install autofs
Install the required package first

# systemctl enable autofs.service
Enable service at boot time

# systemctl is-enabled autofs.service
Verify whether service is enabled or not

# systemctl start autofs.service
Start service for current session

# systemctl status autofs.service
Check whether service is running or not

# showmount -e classroom.example.com
Display directories shared by server using nfs server.
Just a way to find, what server is sharing with you via nfs server.

# vim /etc/auto.master.d/ldapusers.autofs
Create new file and add following:
/home/guests
/etc/auto.ldapusers
:wq
save and quit vim editor

# vim /etc/auto.ldapusers
Create new file and add following:
* -rw,sync
classroom.example.com:/home/guests/&
:wq
save and quit vim editor

# systemctl restart autofs.service
Restart service to apply new changes

# ssh ldapuserX@localhost (OR) #su - ldapuserX
Login via given credentials and you must get a valid home directory.

# echo $PWD
# echo $HOME
To verify your home directory as per the question execute above two commands.

# exit
exit from ldapuserX's session

____________________________________________________________________________________________

## Task 21

# Configure a user account.
# Create a user 'alex' with a userid of '3456'. The password for this user should be 'flectrag'.

# useradd -u 3456 alex
# echo "flectrag" | passwd --stdin alex

# id alex
Verify user alex uid

# ssh alex@localhost
login via alex to verify its password and then exit.

____________________________________________________________________________________________

## Task 22

# Add a swap partition
# Add an additional swap partition of 512 MiB to your system. The swap partition should automatically mount when your system boots. Do not remove or otherwise alter any existing swap partitions on your system.

# free -m
To view information of current swap

# fdisk /dev/vdb
Command (m for help): p
Prints current partition table
Command (m for help): n
Select (default p): e
Partition number (1-4, default 1):
First sector (2048-20971519, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-20971519, default 20971519):

Command (m for help): n
Select (default p): l
Adding logical partition 5
First sector (4096-20971519, default 4096):
Using default value 4096
Last sector, +sectors or +size{K,M,G} (4096-20971519, default 20971519): +512M
Partition 5 of type Linux and of size 512 MiB is set

Command (m for help): p

Command (m for help): t
Partition number (1,5, default 5): 5
Hex code (type L to list all codes): 82

Command (m for help): w

# partprobe /dev/vdb
make the kernel aware of the partition table change

# fdisk -l
Verify your changes

# mkswap /dev/vdb5
Initializing the newly created partition as swap space

# blkid /dev/vdb5
Determine the UUID of the new swap partition /dev/vdb5 and copy it

# vim /etc/fstab
Add an entry to /etc/fstab to mount swap partition automatically on boot
UUID="79148fff-8cae-4d61-940a-ba82a4943e99" swap   swap   defaults   0   0
:wq
save and exit vim editor

# swapon -a
Mount/Enable all the swap partitions listed in fstab file

# swapon -s
Show summary of swap partitions

# free -m
Vefify the size of swap partition

# systemctl reboot (OR) # reboot
REBOOT YOUR SYSTEM AND SEE WHETHER EVERYTHING IS WOKING FINE OR
NOT
Note:(Confirm your swap space is eanbled or not)

____________________________________________________________________________________________

## Task 23

# Locate all files owned by user 'harry' and place a copy of them in the '/root/findfiles' directory.

# mkdir /root/findfiles
First create the required directory

# find / -type f -user harry -exec cp -p {} /root/findfiles/ \;
Finding all the files whose owner is 'harry' and copying them to /root/findfiles directory

# ls -l /root/findfiles/
Verifying whether all files get copied or not

____________________________________________________________________________________________

## Task 24

# Find a string
# Find all lines in the file /usr/share/dict/words that contain the string 'seismic'.
# Put a copy of all these lines in the original order in the file /root/wordlist. 
# /root/wordlist should contain no empty lines and all lines must be exact copies of the original lines in /usr/share/dict/words.

# grep "seismic" /usr/share/dict/words > /root/wordlist
Performing search and copy operation

# cat /root/wordlist
Verify everthing went alright

____________________________________________________________________________________________

## Task 25

# Create an Archive
# (a) Create a tar archive named /root/backup.tar.bz2 which contains the content of /usr/local directory. The tar archive must be compressed using bzip compression.
# (b) Create an archive of /etc/sysconfig/network-scripts directory and keep copy on /home/student/myarchive.tar.gz

# tar -cvjf /root/backup.tar.bz2 /usr/local
creating an archive with bzip2 compression

# tar -tvf /root/backup.tar.bz2
verifying the archive by listing its contents

# ls -lh /root/backup.tar.bz2
check the archive size

# tar -cvzf /home/student/myarchive.tar.gz /etc/sysconfig/network-scripts
creating an archive with gzip compression

# tar -tvf /home/student/myarchive.tar.gz
verifying the archive by listing its contents

# ls -lh /home/student/myarchive.tar.gz
check the archive size

____________________________________________________________________________________________

## Task 26

# Create a logical volume
# Create a new logical volume according to the following requirements:
# The logical volume is named 'mylogvol' and belongs to the 'myvolgrp' volume group and has a size of 50 extents.
# Logical volumes in the 'myvolgrp' volume group should have extent size of 16 MiB
# Format the new logical volume with a ext3 filesystem.
# The logical volume should be automatically mounted under /mynewfs at system boot time.

Note: You already did a question like this before, use your brain (if exist)
or otherwise consult with your teacher.
Hint:
Create a new partition of enough size to contain the above mentioned logical volume.
Label it as Linux LVM Type
Create a physical volume
Create a volume group as asked
Create asked logical volume.
Format it.
Create mount point.
Mount it in a way, so that it remains available even after the system boot.
:) Easy-Peasy isn't it?

____________________________________________________________________________________________

## Task 27

# Create user 'user4' with password 'user4'. It should not have interactive login and account should expire after 30 days.

# useradd -s /sbin/nologin user4
Creating user4 with no interactive login

# date -d "+30 days"
Determining date after 30 days from today.
Convert the displayed date in YYYY-MM-DD format

# chage -E YYYY-MM-DD user4
Setting expiry date as asked

# chage -l user4
Verifying everything is alright or not.

____________________________________________________________________________________________
