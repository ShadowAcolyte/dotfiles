#!/usr/bin/env bash

NOTIFY_ICON=/usr/share/icons/Papirus/32x32/apps/system-software-update.svg

get_total_updates() { UPDATES=$(yay -Qu | wc -l); }

while true; do
    get_total_updates

    # notify user of updates
    if (( UPDATES > 50 )); then
        notify-send -u critical -i $NOTIFY_ICON \
            "You really need to update!!" "$UPDATES New packages"
    elif (( UPDATES > 25 )); then
        notify-send -u normal -i $NOTIFY_ICON \
            "You should update soon" "$UPDATES New packages"
    elif (( UPDATES > 1 )); then
        notify-send -u low -i $NOTIFY_ICON \
            "$UPDATES New packages"
    fi

    # when there are updates available
    # every 10 seconds another check for updates is done
    while (( UPDATES > 0 )); do
        if (( UPDATES == 1 )); then
            echo "Update Available: $UPDATES"
        elif (( UPDATES > 1 )); then
            echo "Updates Available: $UPDATES"
        else
            echo "No Updates"
        fi
        sleep 10
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 30 min for new updates
    while (( UPDATES == 0 )); do
        echo "No Updates"
        sleep 1800
        get_total_updates
    done
done
