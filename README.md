# KDE transfer.sh service menu

Add menu action for uploading files to [transfer.sh](https://transfer.sh/).

## Dependencies

Required:

* curl
* kde4-config (for KDE4) and kf5-config (for KDE5)

Also at least one of the following requirements should be met:

* running **klipper** + installed **qdbus**
* running **clipit**
* installed **xclip**
* installed **xsel**

Optional (yet recommended):

* notify-send (libnotify-bin package in Debian and Ubuntu)

## Install

```
./install.sh
```

If possible this will install for both KDE4 and KDE5, so you will be able to use the script from e.g. KDE5 Dolphin and KDE4 Krusader.
New submenu 'transfer.sh' should appear in the context menu of Dolphin and Krusader.

To uninstall type:

```
./deinstall.sh
```
