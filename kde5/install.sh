#!/bin/sh

set -e

KDE_SERVICEMENUS="$(kf5-config --path services | cut -d : -f1)ServiceMenus"

install -d "$KDE_SERVICEMENUS/transfersh-scripts"
install -m 644 ServiceMenus/transfersh.desktop "$KDE_SERVICEMENUS/"
install -m 755 ../transfer.sh "$KDE_SERVICEMENUS/transfersh-scripts/"
