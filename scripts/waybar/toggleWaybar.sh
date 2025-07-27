toggleBorders() {
	local flag=$1

	# gaps_in gaps_out rounding
	hypr_configs=(0 0 0)
	
	if [ "$flag" -eq 1 ]; then
		config_file="$HOME/.config/hypr/hyprland.conf"
		hypr_configs[0]=$(grep -Po '^\s*gaps_in\s*=\s*\K[0-9]+' "$config_file")
		hypr_configs[1]=$(grep -Po '^\s*gaps_out\s*=\s*\K[0-9]+' "$config_file")
		hypr_configs[2]=$(grep -Po '^\s*border_size\s*=\s*\K[0-9]+' "$config_file")
	
	fi
	
  	hyprctl keyword general:gaps_in "${hypr_configs[0]}"	  	
  	hyprctl keyword general:gaps_out "${hypr_configs[1]}"
  	hyprctl keyword general:border_size "${hypr_configs[2]}"
}

if pgrep -x waybar > /dev/null; then
	pkill -x waybar
	WINDOW_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $(hyprctl activeworkspace -j | jq .id))] | length")	

	if [ "$WINDOW_COUNT" -eq 1 ]; then	
		toggleBorders 0
		
		while true; do	
			WINDOW_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $(hyprctl activeworkspace -j | jq .id))] | length")
		
			if [ "$WINDOW_COUNT" -gt 1 ]; then
				toggleBorders 1	
				break
			fi
			
			sleep 0.5
		done
	fi
else
	waybar &
	toggleBorders 1
fi
