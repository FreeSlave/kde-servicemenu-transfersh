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
        notify-send "$1" --expire-time=2000 > /dev/null 2>&1
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
        notify-send "Link copied to klipper" --expire-time=2000 > /dev/null 2>&1
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
        echo "$link"
        return 0
    else
        show_error "Could not upload file to transfer.sh"
        return 1
    fi
}

command_exists curl || show_error "Can't upload file. Install curl"

if ( command_exists klipper && command_exists qdbus ) || command_exists xclip
then
    link=$(upload_to_transfersh "$toUpload")
    if [ $? = 1 ]
    then
        exit 1
    fi
else
    show_error "Could not find a program to set clipboard contents"
fi

if command_exists klipper && command_exists qdbus
then
    pidof klipper > /dev/null || klipper > /dev/null 2>&1
    if qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$link" > /dev/null 2>&1
    then
        show_notify "Link copied to klipper"
    else
        show_error "Could not access klipper via dbus"
    fi
elif command_exists xclip
then
    echo "$link" | xclip -selection clipboard -t text/plain > /dev/null 2>&1
    if [ $? = 0 ]
    then
        show_notify "Link copied to clipboard"
    else
        show_error "Could not copy link to clipboard"
    fi
fi

echo "$link"

exit 0
