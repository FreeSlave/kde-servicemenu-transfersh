#!/bin/sh

toUpload="$1"

command_exists()
{
    command -v "$1" >/dev/null 2>&1
}

show_error()
{
    if command_exists notify-send
    then
        notify-send --icon=error "$1" --expire-time=3000 > /dev/null 2>&1
    elif command_exists kdialog
    then
        kdialog --error "$1" > /dev/null 2>&1
    elif command_exists zenity
    then
        zenity --error --text="$1" > /dev/null 2>&1
    else
        echo "$1" 1>&2
    fi
    exit 1
}

show_notify()
{
    if command_exists notify-send
    then
        notify-send --icon="$2" "$1" --expire-time=2000 > /dev/null 2>&1
    else
        echo "$1"
    fi
}

link=""

upload_to_transfersh()
{
    link=$(curl --silent --upload-file "$1" "https://transfer.sh/")
    return $?
}

command_exists curl || show_error "Can't upload file. Install curl"

if ( pidof klipper > /dev/null && command_exists qdbus ) || pidof clipit > /dev/null || command_exists xclip || command_exists xsel
then
    if [ ! -f "$toUpload" ]
    then
        show_error "$toUpload is not a regular file"
    fi

    if ! upload_to_transfersh "$toUpload"
    then
        show_error "Could not upload file to transfer.sh"
    fi
else
    show_error "Could not find a program to set clipboard contents."
fi

try_xsel()
{
    echo -n "$link" | xsel -ib > /dev/null 2>&1
    return $?
}

try_xclip()
{
    echo -n "$link" | xclip -selection clipboard -t text/plain > /dev/null 2>&1
    return $?
}

try_clipit()
{
    pidof clipit > /dev/null && echo -n "$link" | clipit > /dev/null 2>&1
    return $?
}

try_klipper()
{
    pidof klipper > /dev/null && command_exists qdbus && qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$link" > /dev/null 2>&1
    return $?
}

if try_klipper
then
    show_notify "Link copied to klipper" "klipper"
elif try_clipit
then
    show_notify "Link copied to clipit" "clipit-trayicon"
elif try_xclip
then
    show_notify "Link copied to clipboard" "klipper"
elif try_xsel
then
    show_notify "Link copied to clipboard" "klipper"
else
    show_error "Could not copy link to clipboard"
fi

echo "$link"

exit 0

