# KDE transfer.sh service menu

Add menu action for uploading files to [transfer.sh](https://transfer.sh/).

## Dependencies

Required:

* curl
* kde4-config (for KDE4) and kf5-config (for KDE5)
* klipper + qdbus or xclip

**klipper** should be ran by user. **xclip** can be used instead and does not require separate starting.

Optional (yet recommended):

* notify-send (libnotify-bin package in Debian and Ubuntu)

## Install

```
./install.sh
```

If possible this will install for both KDE4 and KDE5, so you will be able to use the script from e.g. KDE5 Dolphin and KDE4 Krusader.
New action should appear in the context menu of Dolphin and Krusader.

To uninstall type:

```
./deinstall.sh
```
