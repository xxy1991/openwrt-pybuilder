#!/usr/bin/env bash

if [ -z $TEMPLATES_PATH ];then
    $TEMPLATES_PATH=$(pwd)/..
fi

TEMPLATE_MWAN_PATH=$TEMPLATES_PATH/mwan
TEMPLATE_MWAN_PACKAGES="luci-i18n-mwan3-zh-cn"

# cp_mwan(dst_path)
cp_mwan(){
    if [ -z "$1" ]; then
        echo "Destination path is required!"
        exit 1
    fi
    local dst_path=${1}

    cp -r $TEMPLATE_MWAN_PATH/files $dst_path/
}
