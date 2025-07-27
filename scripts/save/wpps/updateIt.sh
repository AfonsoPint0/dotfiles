WALLPAPER_DIR="$HOME/.config/wpps"

# Find .jpg, .jpeg, and .png images
WALLPAPER=$1
if [ -z "$1" ]; then
	WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
fi

# If no wallpaper is found, exit
if [ -z "$WALLPAPER" ]; then
  notify-send "No wallpapers found!" "Check your $WALLPAPER_DIR"
  exit 1
fi

# Set wallpaper using swww
swww img "$WALLPAPER" --transition-type any --transition-duration 1

# Generate and apply pywal colors
wal -i "$WALLPAPER"
pkill waybar
waybar &
hyprshade auto

# Apply colors
source "$HOME/.cache/wal/colors.sh"

# hyprland.conf
TEMPLATE="$HOME/.config/hypr/hyprland.conf.template"
OUTPUT="$HOME/.config/hypr/hyprland.conf"

hex_to_dec() {
  printf "%d" "0x$1"
}
# Loop over all variables that start with 'color'
for var in $(compgen -v | grep '^color'); do
  hex="${!var}"         # Get the value of the variable, e.g. "#0E0F10"
  hex="${hex#\#}"       # Remove leading '#'

  r_hex="${hex:0:2}"
  g_hex="${hex:2:2}"
  b_hex="${hex:4:2}"

  r=$(hex_to_dec "$r_hex")
  g=$(hex_to_dec "$g_hex")
  b=$(hex_to_dec "$b_hex")

  echo "$var = rgba($r, $g, $b, 1.0)"
done

# Reload Hyprland config (only works if Hyprland is running)
hyprctl reload

# Notify
notify-send "Wallpaper changed" "$(basename "$WALLPAPER")"
