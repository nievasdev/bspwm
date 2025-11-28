#!/bin/bash

# Power menu script with dmenu
options="→ Logout\n🔒 Lock\n🔄 Restart\n⏻ Poweroff\n✖ Cancel"

chosen=$(echo -e "$options" | dmenu -i -p "Power Menu:" -nb "#2e3440" -nf "#d8dee9" -sb "#81a1c1" -sf "#2e3440")

case $chosen in
    "→ Logout")
        bspc quit
        ;;
    "🔒 Lock")
        slock
        ;;
    "🔄 Restart")
        systemctl reboot
        ;;
    "⏻ Poweroff")
        systemctl poweroff
        ;;
    "✖ Cancel")
        # Do nothing
        ;;
    *)
        # Do nothing if no option selected
        ;;
esac