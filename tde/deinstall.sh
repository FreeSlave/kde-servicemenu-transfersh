#!/bin/sh

set -e

KDE_SERVICEMENUS="$(tde-config --localprefix)share/apps/konqueror/servicemenus"

rm -f "$KDE_SERVICEMENUS/transfersh.desktop"
rm -f "$KDE_SERVICEMENUS/transfersh_compress.desktop"
rm -rf "$KDE_SERVICEMENUS/transfersh-scripts/"
