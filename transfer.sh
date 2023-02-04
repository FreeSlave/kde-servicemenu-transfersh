#!/bin/sh

toUpload="$1"
archive="$2"

command_exists()
{
    command -v -- "$1" >/dev/null 2>&1
}

show_error()
{
    if command_exists notify-send
    then
        notify-send --icon=error "$1" --expire-time=3000 > /dev/null 2>&1
    elif command_exists kdialog
    then
        kdialog --title "transfer.sh" --error "$1" > /dev/null 2>&1
    elif command_exists zenity
    then
        zenity --title="transfer.sh" --error --text="$1" > /dev/null 2>&1
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

ask_really_upload()
{
    local yesLabel="Yes, upload"
    local noLabel="No, abort"
    
    if command_exists kdialog
    then
        kdialog --title "transfer.sh" --warningyesno "$1" --yes-label "$yesLabel" --no-label "$noLabel" >/dev/null 2>&1
        local result="$?"
        if [ "$result" -eq "254" ]
        then
            kdialog --title "transfer.sh" --warningyesno "$1" >/dev/null
        else
            return "$result"
        fi
    elif command_exists zenity
    then
        zenity --title="transfer.sh" --question --text="$1" --default-cancel --ok-label="$yesLabel" --cancel-label="$noLabel" --icon-name=dialog-warning >/dev/null
    elif command_exists notify-send
    then
        notify-send --icon=error "$1 Install kdialog or zenity to answer the dialog." --expire-time=6000 -u critical > /dev/null
        return 1
    else
        echo "$1 Install kdialog or zenity to answer the dialog."
        return 1
    fi
}

check_directory()
{
    if [ "$(dirname -- "$toUpload")" = "/" ]
    then
        ask_really_upload "You're about to upload $toUpload directory (which is probably the big or important piece of your system) to transfer.sh. This is most likely an error. Do you really mean to do this?"
    elif [ "$(dirname -- "$toUpload")" = "$HOME" ]
    then
        case "$(basename -- "$toUpload")" in
        .*)
            ask_really_upload "You're about to upload the hidden directory $toUpload to transfer.sh. It may contain data not intended to be shared with other parties. Do you really want to continue?"
        ;;
        *)
            return 0
        ;;
        esac
    else
        case "$toUpload" in
        "$HOME" | "$HOME/")
            ask_really_upload "You're about to upload the whole $HOME directory to transfer.sh. It most likely contains your private data. Do you really want to proceed?"
        ;;
        *)
            return 0
        ;;
        esac
    fi
}

link=""

upload_to_transfersh()
{
    link=$(curl -g --silent --upload-file "$1" "https://transfer.sh/")
    return $?
}

upload_to_transfersh_zip()
{
    local name="$(basename "$1")"
    local dir="$(dirname "$1")"
    link=$(cd "$dir" && zip -r - "$name" 2>/dev/null | curl -g --silent --upload-file - "https://transfer.sh/$name.zip")
    return $?
}

upload_to_transfersh_tgz()
{
    local name="$(basename "$1")"
    local dir="$(dirname "$1")"
    link=$(cd "$dir" && tar -cz "$name" 2>/dev/null | curl -g --silent --upload-file - "https://transfer.sh/$name.tar.gz")
    return $?
}

command_exists curl || show_error "Can't upload file. Install curl"

if ( pidof klipper >/dev/null && command_exists qdbus ) || (pidof klipper >/dev/null && command_exists dcop ) || pidof clipit >/dev/null || command_exists xclip || command_exists xsel
then
    if [ -d "$toUpload" ]
    then
        if ! check_directory
        then
            return 0
        fi
    fi
    
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
    printf "%s" "$link" | xsel -ib > /dev/null 2>&1
    return $?
}

try_xclip()
{
    printf "%s" "$link" | xclip -selection clipboard -t text/plain > /dev/null 2>&1
    return $?
}

try_clipit()
{
    pidof clipit > /dev/null && printf "%s" "$link" | clipit > /dev/null 2>&1
    return $?
}

try_klipper()
{
    pidof klipper > /dev/null && command_exists qdbus && qdbus org.kde.klipper /klipper org.kde.klipper.klipper.setClipboardContents "$link" > /dev/null 2>&1
    return $?
}

try_klipper_kde3()
{
    pidof klipper > /dev/null && command_exists dcop && dcop klipper klipper setClipboardContents "$link" > /dev/null 2>&1
    return $?
}

if try_klipper
then
    show_notify "Link copied to klipper" "klipper"
elif try_klipper_kde3
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

