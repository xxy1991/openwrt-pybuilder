#!/bin/sh
#
# Copyright (C) 2019 xxy1991
#

. /lib/functions/uci-defaults.sh

board_config_update

ucidef_set_hostname 'OW-Custom'
ucidef_set_ntpserver 'pool.ntp.org'

board_config_flush

exit 0
