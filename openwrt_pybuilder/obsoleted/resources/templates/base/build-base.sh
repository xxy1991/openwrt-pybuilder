#!/usr/bin/env bash

if [ -z $TEMPLATES_PATH ];then
    $TEMPLATES_PATH=$(pwd)/..
fi
TEMPLATE_BASE_PATH=$TEMPLATES_PATH/base
TEMPLATE_BASE_PACKAGES="luci luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn \
    shadow-chpasswd openssh-sftp-server \
    bind-dig curl libustream-openssl \
    -dnsmasq dnsmasq-full"

# cp_base(dst_path)
cp_base(){
    if [ -z "$1" ]; then
        echo "Destination path is required!"
        exit 1
    fi
    local dst_path=${1}

    cp -r $TEMPLATE_BASE_PATH/files $dst_path/
    cp $TEMPLATE_BASE_PATH/custom-*.sh $dst_path/
    chmod +x $dst_path/files/etc/board.d/99-custom_*.sh \
        $dst_path/files/etc/uci-defaults/99_custom-*.sh \
        $dst_path/custom-base.sh
}
