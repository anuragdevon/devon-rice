#!/bin/bash
# Dynamically renames Hyprland workspaces to the icon of their active app.
# Waybar reads {name} which reflects these renames in real time.

get_icon() {
    local class="${1,,}"
    case "$class" in
        *ghostty*|*kitty*|*alacritty*|*foot*|*wezterm*|*terminal*) echo "" ;;
        *brave*|*firefox*|*chromium*|*google-chrome*)               echo "" ;;
        *nvim*|*neovim*)                                             echo "" ;;
        *code*|*vscodium*)                                           echo "" ;;
        *spotify*)                                                   echo "" ;;
        *discord*)                                                   echo "󰙯" ;;
        *slack*)                                                     echo "" ;;
        *telegram*)                                                  echo "" ;;
        *yazi*)                                                      echo "" ;;
        *thunar*|*nautilus*|*nemo*)                                  echo "" ;;
        *gimp*)                                                      echo "" ;;
        *inkscape*)                                                  echo "" ;;
        *blender*)                                                   echo "󰂫" ;;
        *obsidian*)                                                  echo "" ;;
        *steam*)                                                     echo "" ;;
        *vlc*|*mpv*)                                                 echo "" ;;
        *libreoffice*)                                               echo "󰈙" ;;
        *)                                                           echo "${1:0:4}" ;;
    esac
}

update_workspaces() {
    local clients workspaces
    clients=$(hyprctl clients -j 2>/dev/null)   || return
    workspaces=$(hyprctl workspaces -j 2>/dev/null) || return

    while IFS= read -r ws_id; do
        local app_class icon
        app_class=$(printf '%s' "$clients" | jq -r --argjson id "$ws_id" \
            '[.[] | select(.workspace.id == $id and .mapped == true)]
             | sort_by(.focusHistoryID) | reverse | first | .class // ""')

        if [[ -n "$app_class" && "$app_class" != "null" ]]; then
            icon=$(get_icon "$app_class")
            hyprctl dispatch renameworkspace "$ws_id" "$icon" &>/dev/null
        else
            # Empty workspace — show its number
            hyprctl dispatch renameworkspace "$ws_id" "$ws_id" &>/dev/null
        fi
    done < <(printf '%s' "$workspaces" | jq -r '.[].id')
}

# Give Hyprland a moment on startup
sleep 1
update_workspaces

# React to window events in real time
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -u "UNIX-CONNECT:$socket" - 2>/dev/null | while IFS= read -r line; do
    case "${line%%>>*}" in
        activewindow|openwindow|closewindow|movewindow|changefloatingmode)
            update_workspaces
            ;;
    esac
done
