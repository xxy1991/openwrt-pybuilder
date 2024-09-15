#!/bin/ash
#
# Copyright (C) 2019 xxy1991
#

SOFTETHER_PATH=/usr/libexec/softethervpn

check_exec() {
    until $@ >> /root/softether.log
    do
        /etc/init.d/softethervpnbridge start
        sleep 1
    done
}

check_stop() {
    local result=1
    while [ $reuslt -gt 0 ]
    do
        sleep 1
        result=$(ps | grep "softethervpn" | grep -v "grep" | wc -l)
    done
}

/etc/init.d/softethervpnbridge start && \
check_exec \
    vpncmd /server localhost:5555 /cmd "ServerPasswordSet Test123!" && \
check_exec \
    vpncmd /server localhost:5555 /PASSWORD:Test123! /IN:/etc/sevpn-bridge.txt

/etc/init.d/softethervpnbridge stop && check_stop && \
/etc/init.d/softethervpnbridge enable && \
/etc/init.d/softethervpnbridge start

sed -i '/.*S99sevpn_bridge.*/d' /etc/rc.local
rm -f /etc/sevpn-bridge.txt $0
