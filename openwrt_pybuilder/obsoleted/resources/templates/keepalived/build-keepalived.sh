#!/usr/bin/env bash

if [ -z $TEMPLATES_PATH ];then
    $TEMPLATES_PATH=$(pwd)/..
fi

TEMPLATE_KEEP_PATH=$TEMPLATES_PATH/keepalived
# need kmod-ipt-ipset, provide by default
TEMPLATE_KEEP_PACKAGES="keepalived"

# cp_keepalived(dst_path)
cp_keepalived(){
    if [ -z "$1" ]; then
        echo "Destination path is required!"
        exit 1
    fi
    local dst_path=${1}

    cp -r $TEMPLATE_KEEP_PATH/files $dst_path/
    chmod +x $dst_path/files/etc/uci-defaults/99_keepalived.sh
}
