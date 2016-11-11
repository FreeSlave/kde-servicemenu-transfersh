#!/bin/sh

toUpload="$1"
archive="$2"

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

upload_to_transfersh_zip()
{
    local name="$(basename "$1")"
    local dir="$(dirname "$1")"
    link=$(cd "$dir" && zip -r - "$name" 2>/dev/null | curl --silent --upload-file - "https://transfer.sh/$name.zip")
    return $?
}

upload_to_transfersh_tgz()
{
    local name="$(basename "$1")"
    local dir="$(dirname "$1")"
    link=$(cd "$dir" && tar -cz "$name" 2>/dev/null | curl --silent --upload-file - "https://transfer.sh/$name.tar.gz")
    return $?
}

command_exists curl || show_error "Can't upload file. Install curl"

if ( pidof klipper > /dev/null && command_exists qdbus ) || pidof clipit > /dev/null || command_exists xclip || command_exists xsel
then
    if [ "$archive" = "zip" ]
    then
        command_exists zip || show_error "'zip' is not installed"
        if [ -f "$toUpload" ] || [ -d "$toUpload" ]
        then
            upload_to_transfersh_zip "$toUpload" || show_error "Could not upload zipped file to transfer.sh"
        else
            show_error "$toUpload is not a regular file nor directory"
        fi
    elif [ "$archive" = "tgz" ]
    then
        command_exists tar || show_error "'tar' is not installed"
        if [ -f "$toUpload" ] || [ -d "$toUpload" ]
        then
            upload_to_transfersh_tgz "$toUpload" || show_error "Could not upload gzipped file to transfer.sh"
        else
            show_error "$toUpload is not a regular file nor directory"
        fi
    else
        if [ ! -f "$toUpload" ]
        then
            show_error "$toUpload is not a regular file"
        fi
        upload_to_transfersh "$toUpload" || show_error "Could not upload file to transfer.sh"
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

