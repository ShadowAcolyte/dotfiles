#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

rofi_command="rofi -theme $HOME/.config/rofi/backlight/theme.rasi"

# Error msg
msg() {
	rofi -theme "$HOME/.config/rofi/backlight/message.rasi" -e "$1"
}

## Get Brightness
BNESS="$(brightnessctl -d intel_backlight get)"
MAX="$(brightnessctl -d intel_backlight max)"
PERC="$((BNESS*100/MAX))"
BLIGHT=${PERC%.*}

if [[ $BLIGHT -ge 1 ]] && [[ $BLIGHT -le 29 ]]; then
    MSG="Low"
elif [[ $BLIGHT -ge 30 ]] && [[ $BLIGHT -le 49 ]]; then
    MSG="Optimal"
elif [[ $BLIGHT -ge 50 ]] && [[ $BLIGHT -le 79 ]]; then
    MSG="High"
elif [[ $BLIGHT -ge 80 ]] && [[ $BLIGHT -le 99 ]]; then
    MSG="Too Much"
fi

## Icons
ICON_UP=""
ICON_DOWN=""
ICON_OPT=""

notify="notify-send -u low -t 1500"
options="$ICON_UP\n$ICON_OPT\n$ICON_DOWN"

## Main
chosen="$(echo -e "$options" | $rofi_command -p "$BLIGHT%" -dmenu -selected-row 1)"
case $chosen in
    "$ICON_UP")
			brightnessctl -q -d intel_backlight set +5% && $notify "Brightness Up $ICON_UP"
        ;;
    "$ICON_DOWN")
			brightnessctl -q -d intel_backlight set 5%- && $notify "Brightness Down $ICON_DOWN"
        ;;
    "$ICON_OPT")
			brightnessctl -q -d intel_backlight set 35% && $notify "Optimal Brightness $ICON_OPT"
        ;;
esac
