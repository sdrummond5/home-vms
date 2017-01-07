<?php

$ip = escapeshellcmd ($_GET["ip"]);
$hostname = escapeshellcmd ($_GET["hn"]);

echo "lang en_US
keyboard us
timezone --utc US/Eastern

text
install

network --bootproto=static --hostname=$hostname --ip=$ip --netmask=255.255.0.0 --gateway=192.168.1.1 --nameserver=192.168.1.1

url --url http://192.168.2.1/centos/6.8/os/x86_64

zerombr
bootloader --location=mbr --append=\"console=xvc0\"

clearpart --all --initlabel
part /boot --fstype ext2 --size=100
part swap --size=1024
part / --fstype ext4 --size=9100 --grow

rootpw test
auth --useshadow --enablemd5
key --skip
firstboot --disable
firewall --disabled
selinux --permissive
skipx
reboot

%packages
@core
%pre

%post
/bin/mkdir -p /root/.ssh/
/bin/chmod 700 /root/.ssh/

/bin/echo \"               \" >> /root/.ssh/authorized_keys";


echo "\n#### VM serial console ####
/sbin/grubby --update-kernel ALL --remove-args \"console rhgb quiet\"
/sbin/grubby --update-kernel ALL --args \"console=tty0 console=ttyS0,19200n8\"
echo \"1:23:respawn:/sbin/agetty -h -L ttyS1 19200 vt100\" >> /etc/inittab\
%end";

?>
