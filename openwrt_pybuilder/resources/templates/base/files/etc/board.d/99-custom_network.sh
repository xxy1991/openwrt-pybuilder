#!/bin/sh
#
# Copyright (C) 2019 xxy1991
#

. /lib/functions/uci-defaults.sh

_ucidef_set_interface_ex() {
    local name="$1"; shift
    local key value

    json_select_object "$name"

    until [ $# -eq 0 ]
    do
        key=$1; value=$2; shift 2
        case "$key" in
            ifname|macaddr|protocol|ipaddr|netmask)
                json_add_string "$key" "$value"
            *)
                json_add_string "$key" "$value"
        esac
    done

    json_select ..
}

# ucidef_set_interface_ex(name, key, value...)
ucidef_set_interface_ex() {
    json_select_object network
    _ucidef_set_interface_ex "$@"
    json_select ..
}
