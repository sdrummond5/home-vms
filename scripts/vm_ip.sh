#!/bin/bash

if [ "$1" == "-h" ] || [ -z "$1" ] ; then
  echo "Usage: `basename $0` [somestuff]"
  exit 0
fi





name=$1
cores=$2
ram=$3
ip=$4

if [ -z $name ] ; then
  echo "Name must be set"
  exit 1;
fi

if [ "${cores:-0}" -lt 1 ] || [ "${cores:-0}" -gt 16 ] ; then
  echo "CPUs must be >= 1 and <= 16"
  exit 1;
fi

if [ "${ram:-0}" -lt 1 ] || [ "${ram:-0}" -gt 64 ] ; then
  echo "RAM must be >= 1 and <= 64"
  exit 1;
fi

if [ -z $ip ] ; then
  echo "Last octet must be set"
  exit 1;
fi

if [ "$ip" -lt 1 ] || [ "$ip" -gt 254 ] ; then
  echo "IP must be >= 1 and <= 254"
  exit 1;
fi



echo virt-install \
  --connect qemu:///system \
  --os-type=Linux \
  --os-variant=rhel6 \
  --disk path=/test_vm/$name,bus=virtio,size=10 \
  --location=http://192.168.2.1/centos/6.8/os/x86_64 \
  --vcpus=$cores \
  --vnc \
  --ram=$(($ram*1024)) \
  --name=$name \
  --network=bridge:br0 \
  -x ks=http://192.168.2.1/ks.php?hn="$name.drumm.one"\&ip="192.168.4.$ip" \
  --noautoconsole \
  --wait=-1
