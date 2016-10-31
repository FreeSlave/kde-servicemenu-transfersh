# KDE transfer.sh service menu

Add menu action for uploading files to [transfer.sh](https://transfer.sh/).
Currently KDE4 version only.

## Dependencies

Required:

* curl
* kde4-config
* klipper + qdbus or xclip

**klipper** should be ran by user. **xclip** can be used instead and does not requires separate starting.

Optional (yet recommended):

* notify-send (libnotify-bin package in Debian)

## Install

```
./install.sh
```

New entry should appear in 'Actions' submenu of context menu in Dolphin and Krusader.

To uninstall type:

```
./deinstall.sh
```
