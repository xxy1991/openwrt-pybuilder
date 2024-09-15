#!/bin/ash
#
# Copyright (C) 2019 xxy1991
#

SOFTETHER_PATH=/usr/libexec/softethervpn

check_stop() {
    local result=1
    while [ $reuslt -gt 0 ]
    do
        sleep 1
        result=$(ps | grep "softethervpn" | grep -v "grep" | wc -l)
    done
}

remove_files() {
    rm -rf $SOFTETHER_PATH/*_log \
        $SOFTETHER_PATH/backup.vpn_*.confg && \
    rm -f $SOFTETHER_PATH/.ctl_* \
        $SOFTETHER_PATH/.pid_* \
        $SOFTETHER_PATH/.VPN-* \
        $SOFTETHER_PATH/vpn_*.config
}

for a in `ls /etc/init.d/softethervpn*`; do
    if [ ! -f "$a" ]; then
        "$a" disable && "$a" stop &
    fi
done

wait && check_stop && remove_files

# At the time, the network is disabled.
for a in `ls /etc/S99sevpn_*.sh`; do
    sed -i "/exit/i\\$a" /etc/rc.local
done

exit 0
