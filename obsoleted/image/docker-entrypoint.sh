#!/usr/bin/env bash

for a in `ls ./custom-*.sh`; do
    [ -x $a ] || continue;
    $(. $a)
done

make image "$@"
