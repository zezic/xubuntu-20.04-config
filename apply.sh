#!/usr/bin/env bash

function waterfoxConfigExists {
    PROFILES_FOUND=$(ls $HOME/.waterfox | grep edition-default | wc -l)
    if [ "$PROFILES_FOUND" == "0" ]; then
      return 1
    else
      return 0
    fi
}

function configureWaterfox {
  waterfox-current &>/dev/null &
  while [ ! -d $HOME/.waterfox ]; do sleep 1; done
  while true; do
    PROFILES_FOUND=$(ls $HOME/.waterfox | grep edition-default | wc -l)
    if [ "$PROFILES_FOUND" != "0" ]; then
      break;
    fi
  done
  if [ "$PROFILES_FOUND" == "1" ]; then
    PROFILE_NAME=$(ls $HOME/.waterfox | grep edition-default)
    mkdir -p $HOME/.waterfox/$PROFILE_NAME/chrome
    cp .waterfox/your-profile/chrome/userChrome.css $HOME/.waterfox/$PROFILE_NAME/chrome/
  fi
}

function installWaterfox {
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/xUbuntu_Next/ /' > /etc/apt/sources.list.d/home:hawkeye116477:waterfox.list"
  wget -nv https://download.opensuse.org/repositories/home:hawkeye116477:waterfox/xUbuntu_Next/Release.key -O Release.key
  sudo apt-key add - < Release.key
  sudo apt update
  sudo apt install waterfox-current-kpe -y
  configureWaterfox
}

function configureMousepad {
  gsettings set org.xfce.mousepad.preferences.window toolbar-visible true
  gsettings set org.xfce.mousepad.preferences.view auto-indent true
  gsettings set org.xfce.mousepad.preferences.view color-scheme "solarized-light"
  gsettings set org.xfce.mousepad.preferences.view insert-spaces true
  gsettings set org.xfce.mousepad.preferences.view tab-width 2
  gsettings set org.xfce.mousepad.preferences.view use-default-monospace-font true
}

function configurePlank {
  mkdir -p $HOME/.local/share/plank/themes
  cp -r .local/share/plank/themes/Greybird ~/.local/share/plank/themes/
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme "Greybird"
}

function installPlank {
  if [[ ! -f "/usr/bin/plank" ]]; then
      sudo apt install plank -y
      mkdir -p $HOME/.config/autostart/
      cp .config/autostart/Plank.desktop $HOME/.config/autostart/
      configurePlank
      plank &>/dev/null &
  else
      pkill -9 plank
      configurePlank
      plank &>/dev/null &
  fi
}

function installIosevka {
  mkdir -p $HOME/.fonts
  cp -r .fonts/Iosevka ~/.fonts/
  xfconf-query -c xsettings -p /Gtk/MonospaceFontName -n -t string -s "Iosevka 12"
}

function useUbuntuMono {
  xfconf-query -c xsettings -p /Gtk/MonospaceFontName -n -t string -s "Ubuntu Mono 12"
}

function installFonts {
  echo "Which monospace font you wish to use?"
  select yn in "Default" "Ubuntu" "Iosevka"; do
    case $yn in
      Default ) break;;
      Ubuntu ) echo "Enabling Ubuntu Mono..."; useUbuntuMono; break;;
      Iosevka ) echo "Installing Iosevka..."; installIosevka; break;;
    esac
  done

  mkdir -p $HOME/.fonts
  cp -r .fonts/Lucida\ Grande ~/.fonts/
  xfconf-query -c xfwm4 -p /general/title_font -n -t string -s "Lucida Grande Bold 9"
  xfconf-query -c xsettings -p /Gtk/FontName -n -t string -s "Lucida Grande 9"

  echo "Do you wish to enable the BGR subpixel font rendering? Answer 'No' if not sure."
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) echo "Enabling BGR font rendering..."; xfconf-query -c xsettings -p /Xft/RGBA -n -t string -s "bgr"; break;;
      No ) break;;
    esac
  done
}

function installGtkTweaks {
  mkdir -p $HOME/.config/gtk-3.0
  cp .config/gtk-3.0/gtk.css ~/.config/gtk-3.0/
}

function installXfwmTheme {
  mkdir -p $HOME/.themes
  cp -r .themes/Goodbird ~/.themes/
  xfconf-query -c xfwm4 -p /general/theme -n -t string -s "Goodbird"
}

function configureKeyboardLayout {
  xfconf-query -c keyboard-layout -p /Default/XkbDisable -n -t bool -s false
  xfconf-query -c keyboard-layout -p /Default/XkbLayout -n -t string -s "us,ru"
  xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -n -t string -s "grp:alt_shift_toggle"
  xfconf-query -c keyboard-layout -p /Default/XkbVariant -n -t string -s "colemak,"
}

function configureRistretto {
  xfconf-query -c ristretto -p /window/statusbar/show -n -t bool -s false
  xfconf-query -c ristretto -p /window/thumbnails/show -n -t bool -s false
}

function configureThunar {
  xfconf-query -c thunar -p /last-location-bar -n -t string -s "ThunarLocationButtons"
  xfconf-query -c thunar -p /misc-date-style -n -t string -s "THUNAR_DATE_STYLE_YYYYMMDD"
}

function configureTerminal {
  mkdir -p $HOME/.config/xfce4/terminal
  cp .config/xfce4/terminal/terminalrc $HOME/.config/xfce4/terminal/
}

function configureDesktop {
  xfconf-query -c xfce4-desktop -p /desktop-icons/gravity -n -t int -s 2
}

function configurePanel {
  mkdir -p $HOME/.local/share/icons
  cp .local/share/icons/menu-icon.svg $HOME/.local/share/icons/

  sudo apt install xfce4-appmenu-plugin -y

  xfconf-query -c xfce4-panel -p /panels/panel-0/size -n -t int -s 22

  xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-1/style -n -t int -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-2/style -n -t int -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -t string -s "applicationsmenu"
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/button-icon -n -t string -s "$HOME/.local/share/icons/menu-icon.svg"
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/show-button-title -n -t bool -s false

  xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-4/style -n -t int -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -t string -s "appmenu"
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/plugins/plugin-5/bold-application-name -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/plugins/plugin-5/expand -n -t bool -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -t string -s "systray"
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/show-frame -n -t bool -s false
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/square-icons -n -t bool -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -t string -s "xkb"
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/display-name -n -t int -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/display-scale -n -t int -s 75
  xfconf-query -c xfce4-panel -p /plugins/plugin-7/group-policy -n -t int -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -t string -s "notification-plugin"

  xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -t string -s "indicator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/blacklist -n -a -t string -s "indicator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/known-indicators -n -a -t string -s "com.canonical.indicator.messages"
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/square-icons -n -t bool -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-10 -n -t string -s "statusnotifier"
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/icon-size -n -t int -s 22
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/known-items -n -a -t string -s "nm-applet"
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/menu-is-primary -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/square-icons -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-10/symbolic-icons -n -t bool -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-11 -n -t string -s "power-manager-plugin"

  xfconf-query -c xfce4-panel -p /plugins/plugin-12 -n -t string -s "pulseaudio"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/enable-keyboard-shortcuts -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/enable-mpris -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/mixer-command -n -t string -s "pavucontrol"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/mpris-players -n -t string -s "parole"
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -n -t bool -s true

  xfconf-query -c xfce4-panel -p /plugins/plugin-13 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-13/style -n -t int -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-14 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-14/style -n -t int -s 0

  xfconf-query -c xfce4-panel -p /plugins/plugin-15 -n -t string -s "clock"
  xfconf-query -c xfce4-panel -p /plugins/plugin-15/digital-format -n -t string -s "%d %b %H:%M"

  xfconf-query -c xfce4-panel -p /plugins/plugin-16 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-16/style -n -t int -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-17 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-17/style -n -t int -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-18 -n -t string -s "separator"
  xfconf-query -c xfce4-panel -p /plugins/plugin-18/style -n -t int -s 0

  xfconf-query -c xfce4-panel -p /panels/panel-0/plugin-ids -n -a \
  -t int -t int -t int -t int -t int -t int \
  -t int -t int -t int -t int -t int -t int \
  -t int -t int -t int -t int -t int -t int \
  -s  1 -s  2 -s  3 -s  4 -s  5 -s  6 \
  -s  7 -s  8 -s  9 -s 10 -s 11 -s 12 \
  -s 13 -s 14 -s 15 -s 16 -s 17 -s 18
  killall xfce4-panel
  nohup xfce4-panel &
}

function configureXfwm {
  xfconf-query -c xfwm4 -p /general/button_layout -n -t string -s "CHM|O"
  xfconf-query -c xfwm4 -p /general/placement_mode -n -t string -s "mouse"
}

function configureXsettings {
  xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "Greybird"
  xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "elementary-xfce-darker"
}

sudo apt update

echo "Do you wish to install Waterfox? It supports global menu."
select yn in "Yes" "No"; do
  case $yn in
    Yes ) echo "Installing Waterfox..."; installWaterfox; break;;
    No ) break;;
  esac
done

echo "Installing & configuring Plank..."
installPlank

echo "Setting up the fonts..."
installFonts

echo "Installing GTK 3 tweaks..."
installGtkTweaks

echo "Installing XFWM theme..."
installXfwmTheme

echo "Do you wish to enable the Colemak and Russian keyboard layouts?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) echo "Configuring keyboard layouts..."; configureKeyboardLayout; break;;
    No ) break;;
  esac
done

echo "Configuring Ristretto..."
configureRistretto

echo "Configuring Thunar..."
configureThunar

echo "Configuring Terminal..."
configureTerminal

echo "Configuring Mousepad..."
configureMousepad

echo "Configuring Desktop..."
configureDesktop

echo "Configuring Panel..."
configurePanel

echo "Configuring XFWM..."
configureXfwm

echo "Applying X Settings..."
configureXsettings

echo "Done."
echo "---"
echo "It's better to reboot now."
