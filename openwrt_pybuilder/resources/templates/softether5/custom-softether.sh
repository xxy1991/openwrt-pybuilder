#!/usr/bin/env bash

if [ -n $SE_SVC ]; then
    case "$SE_SVC" in
        server)
            rm -f files/etc/*sevpn*bridge.*
            ;;
        bridge)
            rm -f files/etc/*sevpn*server.*
            ;;
    esac
fi

if [ -n $SE_PASSWD ]; then
    sed -i "s/Test123!/$SE_PASSWD/" files/etc/S99sevpn_*.sh
fi
