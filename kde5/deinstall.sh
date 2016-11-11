#!/bin/sh

set -e

KDE_SERVICEMENUS="$(kf5-config --path services | cut -d : -f1)ServiceMenus"

rm -f "$KDE_SERVICEMENUS/transfersh.desktop"
rm -f "$KDE_SERVICEMENUS/transfersh_compress.desktop"
rm -rf "$KDE_SERVICEMENUS/transfersh-scripts/"
