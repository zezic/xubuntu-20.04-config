#!/usr/bin/env bash

function configurePlank {
  cp -r .local/share/plank/themes/Greybird ~/.local/share/plank/themes/
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme "Greybird"
}

function installPlank {
  if [[ ! -f "/usr/bin/plank" ]]; then
      sudo apt install plank -y
      mkdir -p $HOME/.config/autostart/
      cp .config/autostart/Plank.desktop $HOME/.config/autostart/
      touch $HOME/.config/autostart/plank.desktop
      mkdir -p $HOME/.config/plank/dock1/launchers/
      configurePlank
      plank &>/dev/null &
  else
      pkill -9 plank
      configurePlank
      plank &>/dev/null &
  fi
}

function installFonts {
  cp -r .fonts/Iosevka ~/.fonts/
  cp -r .fonts/Lucida\ Grande ~/.fonts/

  xfconf-query -c xfwm4 -p /general/title_font -s "Lucida Grande Bold 9"
  xfconf-query -c xsettings -p /Gtk/FontName -s "Lucida Grande 9"
  xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Iosevka 12"
  xfconf-query -c xsettings -p /Xft/RGBA -s "bgr"
}

function installGtkTweaks {
  cp .config/gtk-3.0/gtk.css ~/.config/gtk-3.0/
}

function installXfwmTheme {
  cp -r .themes/Goodbird ~/.themes/
  xfconf-query -c xfwm4 -p /general/theme -s "Goodbird"
}

function configureKeyboardLayout {
  xfconf-query -c keyboard-layout -p /Default/XkbDisable -s false
  xfconf-query -c keyboard-layout -p /Default/XkbLayout -s "us,ru"
  xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -s "grp:alt_shift_toggle"
  xfconf-query -c keyboard-layout -p /Default/XkbVariant -s "colemak,"
}

function configureRistretto {
  xfconf-query -c ristretto -p /window/statusbar/show -s false
  xfconf-query -c ristretto -p /window/thumbnails/show -s false
}

function configureThunar {
  xfconf-query -c thunar -p /last-location-bar -s "ThunarLocationButtons"
  xfconf-query -c thunar -p /misc-date-style -s "THUNAR_DATE_STYLE_YYYYMMDD"
}

function configureDesktop {
  xfconf-query -c xfce4-desktop -p /desktop-icons/gravity -s 2
}

function configurePanel {
  sudo apt install xfce4-appmenu-plugin -y

  xfconf-query -c xfce4-panel -p /panels/panel-0/size -s 22

  xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-1/style -n -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-2/style -n -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -s "applicationsmenu"
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/button-icon -n -s "$HOME/.local/share/icons/menu-icon.svg"
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/show-button-title -n -s false

  xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-4/style -n -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -s "appmenu"
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/plugins/plugin-13/bold-application-name -n -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/plugins/plugin-13/expand -n -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -s "systray"
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/show-frame -n -s false
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/square-icons -n -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -s "xkb"
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/display-name -n -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/display-scale -n -s 75
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/group-policy -n -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -s "notification-plugin"

  xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -s "indicator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/blacklist -n -t string -s "indicator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/known-indicators -n -t string -s "com.canonical.indicator.messages"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/square-icons -n -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-10-n -s "statusnotifier"
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/icon-size -n -s 22
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/known-items -n -t string -s "nm-applet"
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/menu-is-primary -n -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/square-icons -n -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/symbolic-icons -n -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-11 -n -s "power-manager-plugin"

  xfconf-query -c xfce4-panel -p /plugins/plugin-12 -n -s "pulseaudio"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/enable-keyboard-shortcuts -n -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/enable-mpris -n -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/mixer-command -n -s "pavucontrol"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/mpris-players -n -s "parole"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -n -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-13 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-13/style -n -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-14 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-14/style -n -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-15 -n -s "clock"
  xfconf-query -c xfce4-panel -p /plugins/plugin-15/digital-format -n -s "%d %b %H:%M"

  xfconf-query -c xfce4-panel -p /plugins/plugin-16 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-16/style -n -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-17 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-17/style -n -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-18 -n -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-18/style -n -s 0

  xfconf-query -c xfce4-panel -p /panels/panel-0/plugin-ids \
  -t int -t int -t int -t int -t int -t int \
  -t int -t int -t int -t int -t int -t int \
  -t int -t int -t int -t int -t int -t int \
  -s  1 -s  2 -s  3 -s  4 -s  5 -s  6 \
  -s  7 -s  8 -s  9 -s 10 -s 11 -s 12 \
  -s 13 -s 14 -s 15 -s 16 -s 17 -s 18
}

function configureXfwm {
  xfconf-query -c xfwm4 -p /general/button_layout -s "CHM|O"
  xfconf-query -c xfwm4 -p /general/placement_mode -s "mouse"
}

function configureXsettings {
  xfconf-query -c xsettings -p /Net/ThemeName -s "Greybird"
  xfconf-query -c xsettings -p /Net/IconThemeName -s "elementary-xfce-darker"
}

sudo apt update
installPlank
installFonts
installGtkTweaks
installXfwmTheme

configureKeyboardLayout
configureRistretto
configureThunar
configureDesktop
configurePanel
configureXfwm
configureXsettings
