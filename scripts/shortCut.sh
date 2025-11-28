#!/bin/bash
key="$1"
# Ejecuta lsusb y busca el ID del dispositivo OLKB Preonic
lsusb_output=$(lsusb)
if echo "$lsusb_output" | grep "03a8:a649"; then
#if false; then
  case $1 in
  "1")
    dmenu_unified
    ;;
  "2")
    dmenu_apps
    ;;
  "3")
    ~/.config/bspwm/scripts/power_menu.sh
    ;;
  "4")
    nautilus
    ;;
  "5")
    gnome-control-center
    ;;
  "6")
    /home/mauro/Config/project-launcher.sh
    ;;
  "7")
    /home/mauro/todolist_dmenu.sh
    ;;
  "9") ;;
  "0") ;;
  ".") ;;
  ",") ;;
  "ñ") ;;
  "p")
    bspc node -c
    ;;
  "y") ;;
  "f") ;;
  "g")
    echo "Power menu disabled"
    ;;
  "c")
    bspc desktop -f prev
    ;;
  "h")
    bspc desktop -f next
    ;;
  "l")
    echo "Resize mode - use arrow keys or hjkl to resize, Esc to exit"
    ;;
  "a")
    bspc desktop -f 1
    ;;
  "o")
    bspc desktop -f 2
    ;;
  "e")
    bspc desktop -f 3
    ;;
  "u")
    bspc desktop -f 4
    ;;
  "i")
    bspc desktop -f 5
    ;;
  d)
    bspc desktop -f 6
    ;;
  "r")
    bspc desktop -f 7
    ;;
  "t")
    bspc desktop -f 8
    ;;
  "n")
    bspc desktop -f 9
    ;;
  "s")
    bspc desktop -f 10
    ;;
  "-") ;;
  "q")
    notify-send -i /usr/share/icons/Win11-blue-dark/status/22/yum-indicator-info.svg "reload"
    bspc wm -r
    ;;
  "j")
    notify-send -i /usr/share/icons/Win11-blue-dark/status/22/yum-indicator-info.svg "restart"
    bspc wm -r
    ;;
  "k") ;;
  "x") ;;
  "b") ;;
  "m")
    bspc node -p south
    ;;
  "w")
    bspc node -p east
    ;;
  "v") ;;
  "z")
    bspc node -f @parent
    ;;
  "S1") ;;
  "S2") ;;
  "S3") ;;
  "S4") ;;
  "S5") ;;
  "S6") ;;
  "S7") ;;
  "S8") ;;
  "S9") ;;
  "S0") ;;
  "S.") ;;
  "S,") ;;
  "Sñ") ;;
  "Sp") ;;
  "Sy") ;;
  "Sf") ;;
  "Sg") ;;
  "Sc") ;;
  "Sh") ;;
  "Sl") ;;
  "Sa")
    bspc node -d 1
    ;;
  "So")
    bspc node -d 2
    ;;
  "Se")
    bspc node -d 3
    ;;
  "Su")
    bspc node -d 4
    ;;
  "Si")
    bspc node -d 5
    ;;
  "Sd")
    bspc node -d 6
    ;;
  "Sr")
    bspc node -d 7
    ;;
  "St")
    bspc node -d 8
    ;;
  "Sn")
    bspc node -d 9
    ;;
  "Ss")
    bspc node -d 10
    ;;
  "S-") ;;
  "Sq") ;;
  "Sj") ;;
  "Sk") ;;
  "Sx") ;;
  "Sb") ;;
  "Sm") ;;
  "Sw") ;;
  "Sv") ;;
  "Sz") ;;
  "C1") ;;
  "C2") ;;
  "C3") ;;
  "C4") ;;
  "C5") ;;
  "C6") ;;
  "C7") ;;
  "C8") ;;
  "C9") ;;
  "C0") ;;
  "C.") ;;
  "C,") ;;
  "Cñ") ;;
  "Cp") ;;
  "Cy") ;;
  "Cf") ;;
  "Cg") ;;
  "Cc") ;;
  "Cl") ;;
  "Ca") ;;
  "Co") ;;
  "Ce") ;;
  "Cu") ;;
  "Ci") ;;
  "Cd") ;;
  "Cr") ;;
  "Ct") ;;
  "Cn") ;;
  "Cs") ;;
  "C-") ;;
  "Cq") ;;
  "Cj") ;;
  "Ck") ;;
  "Cx") ;;
  "Cb") ;;
  "Cm") ;;
  "Cw") ;;
  "Cv") ;;
  "Cz") ;;
  *)
    echo "default"
    ;;
  esac
else
  case $1 in
  "1")
    dmenu_unified
    ;;
  "2")
    dmenu_apps
    ;;
  "3")
    ~/.config/bspwm/scripts/power_menu.sh
    ;;
  "4")
    nautilus
    ;;
  "5")
    gnome-control-center
    ;;
  "6")
    /home/mauro/Config/project-launcher.sh
    ;;
  "7")
    /home/mauro/todolist_dmenu.sh
    ;;
  "9")
    bspc desktop -f prev
    ;;
  "0")
    bspc desktop -f next
    ;;
  ".") ;;
  ",") ;;
  "ñ") ;;
  "p")
    bspc desktop -f 10
    ;;
  "y") ;;
  "f")
    bspc desktop -f 4
    ;;
  "g")
    bspc desktop -f 5
    ;;
  "c") ;;
  "h")
    bspc desktop -f 6

    ;;
  "l")
    bspc desktop -f 9
    ;;
  "a")
    bspc desktop -f 1
    ;;
  "o")
    slock
    ;;
  "e") ;;
  "u") ;;
  "i") ;;
  d)
    bspc desktop -f 3
    ;;
  "r")
    notify-send -i /usr/share/icons/Win11-blue-dark/status/22/yum-indicator-info.svg "reload"
    bspc wm -r
    ;;
  "t")
    echo "Resize mode - use arrow keys or hjkl to resize, Esc to exit"
    ;;
  "n") ;;
  "s")
    bspc desktop -f 2
    ;;
  "-") ;;
  "q")
    bspc node -c
    ;;
  "j")
    bspc desktop -f 7
    ;;
  "k")
    bspc desktop -f 8
    ;;
  "x") ;;
  "b")
    bspc node -p east
    ;;
  "m")
    bspc node -p south
    ;;
  "w") ;;
  "v") ;;
  "z")
    bspc node -f @parent
    ;;
  "S1") ;;
  "S2") ;;
  "S3") ;;
  "S4") ;;
  "S5") ;;
  "S6") ;;
  "S7") ;;
  "S8") ;;
  "S9") ;;
  "S0") ;;
  "S.") ;;
  "S,") ;;
  "Sñ") ;;
  "Sp")
    bspc node -d 10
    ;;
  "Sy") ;;
  "Sf")
    bspc node -d 4
    ;;
  "Sg")
    bspc node -d 5
    ;;
  "Sc") ;;
  "Sh")
    bspc node -d 6
    ;;
  "Sl")
    bspc node -d 9
    ;;
  "Sa")
    bspc node -d 1
    ;;
  "So") ;;
  "Se") ;;
  "Su") ;;
  "Si") ;;
  "Sd")
    bspc node -d 3
    ;;
  "Sr")
    notify-send -i /usr/share/icons/Win11-blue-dark/status/22/yum-indicator-info.svg "restart"
    bspc wm -r
    ;;
  "St") ;;
  "Sn") ;;
  "Ss")
    bspc node -d 2
    ;;
  "S-") ;;
  "Sq") ;;
  "Sj")
    bspc node -d 7
    ;;
  "Sk")
    bspc node -d 8
    ;;
  "Sx") ;;
  "Sb") ;;
  "Sm") ;;
  "Sw") ;;
  "Sv") ;;
  "Sz") ;;
  "C1") ;;
  "C2") ;;
  "C3") ;;
  "C4") ;;
  "C5") ;;
  "C6") ;;
  "C7") ;;
  "C8") ;;
  "C9") ;;
  "C0") ;;
  "C.") ;;
  "C,") ;;
  "Cñ") ;;
  "Cp") ;;
  "Cy") ;;
  "Cf") ;;
  "Cg") ;;
  "Cc") ;;
  "Cl") ;;
  "Ca") ;;
  "Co") ;;
  "Ce") ;;
  "Cu") ;;
  "Ci") ;;
  "Cd") ;;
  "Cr") ;;
  "Ct") ;;
  "Cn") ;;
  "Cs") ;;
  "C-") ;;
  "Cq") ;;
  "Cj") ;;
  "Ck") ;;
  "Cx") ;;
  "Cb") ;;
  "Cm") ;;
  "Cw") ;;
  "Cv") ;;
  "Cz") ;;
  *)
    echo "default"
    ;;
  esac
fi
