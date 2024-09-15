#!/usr/bin/env bash

if [ -z $TEMPLATES_PATH ];then
    $TEMPLATES_PATH=$(pwd)/..
fi

TEMPLATE_SS_PATH=$TEMPLATES_PATH/ss
TEMPLATE_SS_PACKAGES="luci-compat luci-app-chinadns luci-app-dns-forwarder \
    shadowsocks-libev luci-app-shadowsocks \
    haveged iptables-mod-tproxy"

# cp_ss(dst_path)
cp_ss(){
    if [ -z "$1" ]; then
        echo "Destination path is required!"
        exit 1
    fi
    local dst_path=${1}

    cp -r $TEMPLATE_SS_PATH/files $dst_path/
    chmod +x $dst_path/files/etc/uci-defaults/99_ss-*.sh
}
