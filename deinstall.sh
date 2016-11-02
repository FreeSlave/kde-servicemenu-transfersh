#!/bin/sh

if command -v kde4-config > /dev/null
then
    (cd kde4 && ./deinstall.sh)
fi

if command -v kf5-config > /dev/null
then
    (cd kde5 && ./deinstall.sh)
fi
