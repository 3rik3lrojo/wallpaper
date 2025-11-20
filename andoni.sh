#!/usr/bin/env bash
URL="http://www.sc.ehu.es/ccwbayes/images/bcalvo.jpg"
WALL="/tmp/wall.jpg"

FILE_URI="file://$WALL"

wget -O "$DEST" "$URL"

detect_de() {
    if [ "$XDG_CURRENT_DESKTOP" ]; then
        echo "$XDG_CURRENT_DESKTOP"
    elif [ "$DESKTOP_SESSION" ]; then
        echo "$DESKTOP_SESSION"
    else
        echo "unknown"
    fi
}

DE=$(echo "$(detect_de)" | tr '[:upper:]' '[:lower:]')

echo "Detectado: $DE"

# --- GNOME, UNITY ---
if [[ "$DE" == *"gnome"* || "$DE" == *"unity"* ]]; then
    gsettings set org.gnome.desktop.background picture-uri "$FILE_URI"
    gsettings set org.gnome.desktop.background picture-uri-dark "$FILE_URI" 2>/dev/null
    exit 0
fi

# --- KDE ---
if [[ "$DE" == *"kde"* || "$DE" == *"plasma"* ]]; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var d = desktops();
for (i in d) {
    d[i].wallpaperPlugin = 'org.kde.image';
    d[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d[i].writeConfig('Image', 'file://$WALL');
}
"
    exit 0
fi

# --- XFCE ---
if [[ "$DE" == *"xfce"* ]]; then
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALL"
    exit 0
fi

# --- LXDE ---
if [[ "$DE" == *"lxde"* ]]; then
    pcmanfm --set-wallpaper="$WALL"
    exit 0
fi

# --- Cinnamon ---
if [[ "$DE" == *"cinnamon"* ]]; then
    gsettings set org.cinnamon.desktop.background picture-uri "$FILE_URI"
    exit 0
fi

# --- Mate ---
if [[ "$DE" == *"mate"* ]]; then
    gsettings set org.mate.background picture-filename "$WALL"
    exit 0
fi

# --- Deepin ---
if [[ "$DE" == *"deepin"* ]]; then
    dconf write /com/deepin/wm/background "'$WALL'"
    exit 0
fi

# --- Hyprland ---
if pgrep -x "Hyprland" >/dev/null; then
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$WALL"
    hyprctl hyprpaper wallpaper ",$WALL"
    exit 0
fi

# --- Sway / i3 (feh) ---
if command -v swaymsg >/dev/null; then
    swaymsg output '*' bg "$WALL" fill
    exit 0
fi

# --- Fallback genérico (feh) ---
if command -v feh >/dev/null; then
    feh --bg-fill "$WALL"
    exit 0
fi

echo "No se detectó entorno compatible."
exit 1
#!/usr/bin/env bash

WALL="$1"

if [ -z "$WALL" ]; then
    echo "Uso: $0 /ruta/a/imagen.jpg"
    exit 1
fi

FILE_URI="file://$WALL"

detect_de() {
    if [ "$XDG_CURRENT_DESKTOP" ]; then
        echo "$XDG_CURRENT_DESKTOP"
    elif [ "$DESKTOP_SESSION" ]; then
        echo "$DESKTOP_SESSION"
    else
        echo "unknown"
    fi
}

DE=$(echo "$(detect_de)" | tr '[:upper:]' '[:lower:]')

echo "Detectado: $DE"

# --- GNOME, UNITY ---
if [[ "$DE" == *"gnome"* || "$DE" == *"unity"* ]]; then
    gsettings set org.gnome.desktop.background picture-uri "$FILE_URI"
    gsettings set org.gnome.desktop.background picture-uri-dark "$FILE_URI" 2>/dev/null
    exit 0
fi

# --- KDE ---
if [[ "$DE" == *"kde"* || "$DE" == *"plasma"* ]]; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var d = desktops();
for (i in d) {
    d[i].wallpaperPlugin = 'org.kde.image';
    d[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d[i].writeConfig('Image', 'file://$WALL');
}
"
    exit 0
fi

# --- XFCE ---
if [[ "$DE" == *"xfce"* ]]; then
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALL"
    exit 0
fi

# --- LXDE ---
if [[ "$DE" == *"lxde"* ]]; then
    pcmanfm --set-wallpaper="$WALL"
    exit 0
fi

# --- Cinnamon ---
if [[ "$DE" == *"cinnamon"* ]]; then
    gsettings set org.cinnamon.desktop.background picture-uri "$FILE_URI"
    exit 0
fi

# --- Mate ---
if [[ "$DE" == *"mate"* ]]; then
    gsettings set org.mate.background picture-filename "$WALL"
    exit 0
fi

# --- Deepin ---
if [[ "$DE" == *"deepin"* ]]; then
    dconf write /com/deepin/wm/background "'$WALL'"
    exit 0
fi

# --- Hyprland ---
if pgrep -x "Hyprland" >/dev/null; then
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$WALL"
    hyprctl hyprpaper wallpaper ",$WALL"
    exit 0
fi

# --- Sway / i3 (feh) ---
if command -v swaymsg >/dev/null; then
    swaymsg output '*' bg "$WALL" fill
    exit 0
fi

# --- Fallback genérico (feh) ---
if command -v feh >/dev/null; then
    feh --bg-fill "$WALL"
    exit 0
fi

echo "No se detectó entorno compatible."
exit 1
