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
        notify-send --icon=error "$1" --expire-time=2000 > /dev/null 2>&1
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
        notify-send --icon=klipper "$1" --expire-time=2000 > /dev/null 2>&1
    else
        echo "$1"
    fi
}

upload_to_transfersh()
{
    if [ ! -f "$1" ]
    then
        show_error "$1 is not a file"
        return 1
    fi
    
    local link=$(curl --silent --upload-file "$1" "https://transfer.sh/")
    
    if [ $? = 0 ]
    then
        echo -n "$link"
        return 0
    else
        show_error "Could not upload file to transfer.sh"
        return 1
    fi
}

command_exists curl || show_error "Can't upload file. Install curl"

if ( pidof klipper > /dev/null && command_exists qdbus ) || pidof clipit > /dev/null || command_exists xclip
then
    link=$(upload_to_transfersh "$toUpload")
    if [ $? = 1 ]
    then
        exit 1
    fi
else
    show_error "Could not find a program to set clipboard contents. Either run klipper and install qdbus or install xclip"
fi

try_xclip()
{
    echo "$link" | xclip -selection clipboard -t text/plain > /dev/null 2>&1
    return $?
}

try_clipit()
{
    if pidof clipit > /dev/null
    then
        echo -n "$link" | clipit > /dev/null 2>&1
        return $?
    else
        return 2
    fi
}

try_klipper()
{
    if pidof klipper > /dev/null && command_exists qdbus
    then
        qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$link" > /dev/null 2>&1
        return $?
    else
        return 2
    fi
}

if try_klipper
then
    show_notify "Link copied to klipper"
elif try_clipit
then
    show_notify "Link copied to clipit"
elif try_xclip
then
    show_notify "Link copied to clipboard"
else
    show_error "Could not copy link to clipboard"
    exit 1
fi

echo "$link"

exit 0

