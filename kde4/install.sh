#!/bin/sh

set -e

KDE_SERVICEMENUS="$(kde4-config --localprefix)share/kde4/services/ServiceMenus"

install -d "$KDE_SERVICEMENUS/transfersh-scripts"
install -m 644 ServiceMenus/transfersh.desktop "$KDE_SERVICEMENUS/"
install -m 644 ServiceMenus/transfersh_compress.desktop "$KDE_SERVICEMENUS/"
install -m 755 ../transfer.sh "$KDE_SERVICEMENUS/transfersh-scripts/"
