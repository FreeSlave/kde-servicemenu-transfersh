#!/bin/sh

set -e

KDE_SERVICEMENUS="$(kde4-config --localprefix)share/kde4/services/ServiceMenus"

rm -f "$KDE_SERVICEMENUS/transfersh.desktop"
rm -f "$KDE_SERVICEMENUS/transfersh_compress.desktop"
rm -rf "$KDE_SERVICEMENUS/transfersh-scripts/"
