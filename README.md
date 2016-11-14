# KDE transfer.sh service menu

Add menu action for uploading files to [transfer.sh](https://transfer.sh/).

## Dependencies

Required:

* curl
* kde4-config (for KDE4), kf5-config (for KDE5), tde-config (for TDE)

Also at least one of the following requirements should be met:

* running **klipper** + installed **qdbus** (for KDE4 and KDE5)
* running **clipit**
* installed **xclip**
* installed **xsel**
* running **klipper** + instaleld **dcop** (for TDE)

Optional (yet recommended):

* notify-send (libnotify-bin package in Debian and Ubuntu)

## Install

```
./install.sh
```

If possible this will install for both KDE4 and KDE5 and also for TDE, so you will be able to use the script from e.g. KDE5 Dolphin, KDE4 Krusader and TDE Konqueror.
New submenu 'transfer.sh' should appear in the context menu of Dolphin, Krusader and Konqueror.

To uninstall type:

```
./deinstall.sh
```
