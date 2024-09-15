#!/usr/bin/env bash

if [ -n "$OW_HOSTNAME" ]; then
    sed -i "s/OW-Custom/$OW_HOSTNAME/" \
        files/etc/board.d/99-custom_system.sh
fi

if [ -n "$OW_PASSWORD" ]; then
    sed -i "s/OW-Password/$OW_PASSWORD/" \
        files/etc/uci-defaults/99_custom-passwd.sh
    else rm -f files/etc/uci-defaults/99_custom-passwd.sh
fi
