#!/usr/bin/env bash

if [ -z $TEMPLATES_PATH ];then
    $TEMPLATES_PATH=$(pwd)/..
fi

TEMPLATE_SEVPN_PATH=$TEMPLATES_PATH/softether
TEMPLATE_SEVPN_PACKAGES="kmod-tun softethervpn"
TEMPLATE_SEVPN_DISABLED_SERVICES="softethervpnbridge \
    softethervpnclient \
    softethervpnserver"

# cp_softether(dst_path)
cp_softether(){
    if [ -z "$1" ]; then
        echo "Destination path is required!"
        exit 1
    fi
    local dst_path=${1}

    cp -r $TEMPLATE_SEVPN_PATH/files $dst_path/
    cp $TEMPLATE_SEVPN_PATH/custom-*.sh $dst_path/
    chmod +x $dst_path/files/etc/uci-defaults/99_softether.sh \
        $dst_path/files/etc/S99sevpn_*.sh \
        $dst_path/custom-softether.sh
}
