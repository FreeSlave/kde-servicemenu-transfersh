#!/bin/sh

command_exists()
{
    command -v -- "$1" >/dev/null 2>&1
}

if ! command_exists kde4-config && ! command_exists kf5-config && ! command_exists tde-config
then
    echo "Could not find kde4-config, tde-config nor kf5-config. Nothing was installed"
    exit 1
fi

if command_exists kde4-config
then
    (cd kde4 && ./install.sh)
fi

if command_exists kf5-config
then
    (cd kde5 && ./install.sh)
fi

if command_exists tde-config
then
    (cd tde && ./install.sh)
fi
