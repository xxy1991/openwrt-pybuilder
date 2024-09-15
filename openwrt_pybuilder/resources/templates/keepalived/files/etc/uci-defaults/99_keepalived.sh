#!/bin/ash
#
# Copyright (C) 2019 xxy1991
#

echo "" >> /etc/sysupgrade.conf
echo "/etc/keepalived/" >> /etc/sysupgrade.conf
echo "/etc/conntrackd/" >> /etc/sysupgrade.conf

ln -s /tmp/run /run

exit 0
