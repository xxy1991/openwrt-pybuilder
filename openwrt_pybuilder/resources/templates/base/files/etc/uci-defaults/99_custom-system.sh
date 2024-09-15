#!/bin/ash
#
# Copyright (C) 2019 xxy1991
#

echo "" >> /etc/opkg.conf
echo "# option http_proxy http://192.168.96.165:6969" >> /etc/opkg.conf
# opkg update

echo "" >> /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_buckets=16384" >> /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_max=65536" >> /etc/sysctl.conf

exit 0
