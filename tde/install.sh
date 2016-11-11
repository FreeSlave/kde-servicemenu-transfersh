#!/bin/sh

set -e

KDE_SERVICEMENUS="$(tde-config --localprefix)share/apps/konqueror/servicemenus"

install -d "$KDE_SERVICEMENUS/transfersh-scripts"
install -m 644 servicemenus/transfersh.desktop "$KDE_SERVICEMENUS/"
install -m 644 servicemenus/transfersh_compress.desktop "$KDE_SERVICEMENUS/"
install -m 755 ../transfer.sh "$KDE_SERVICEMENUS/transfersh-scripts/"
