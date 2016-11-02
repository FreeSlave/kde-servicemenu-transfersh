#!/bin/sh

if command -v kde4-config > /dev/null
then
    (cd kde4 && ./install.sh)
fi

if command -v kf5-config > /dev/null
then
    (cd kde5 && ./install.sh)
fi
