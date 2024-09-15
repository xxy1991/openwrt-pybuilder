#!/bin/ash
#
# Copyright (C) 2019 xxy1991
#

wget http://openwrt-dist.sourceforge.net/openwrt-dist.pub && \
opkg-key add openwrt-dist.pub && rm openwrt-dist.pub
# ARCH=$(opkg print-architecture | awk '{print $2}')
REPO_BASE=http://openwrt-dist.sourceforge.net/packages
echo "" >>/etc/opkg/customfeeds.conf
echo "src/gz openwrt_dist $REPO_BASE/base/x86_64" \
  >> /etc/opkg/customfeeds.conf
echo "src/gz openwrt_dist_luci $REPO_BASE/luci" \
  >> /etc/opkg/customfeeds.conf

exit 0
