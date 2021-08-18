#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/cache.sh"
source "$CURRENT_DIR/helpers.sh"

app_path="$(dirname "$CURRENT_DIR")/apps"

apps=(
  "docker"
  "mpd"
)

get_icon() {
  printf ""
}

normalize_text() {
  printf "%s" "$@" | tr '[:upper:]' '[:lower:]' | sed 's/[_|/ ]/-/g' | sed 's/[^a-zA-Z0-9\-]//g'
}

platform="$(normalize_text "$(uname -s)")"
architecture="$(normalize_text "$(uname -m)")"

interpolate_apps() {
  local timeout="$1"
  shift
  for name in "$@"; do
    local key="{$name}"
    
    local script_path="$app_path/$name.sh"
    source "$script_path"
    printf "%s\n" "$(_cache_value "${name}_icon" get_icon "$timeout")"
  done
}

main() {
  local timeout=$(get_tmux_option "@running-app-refresh-interval" "5")
  local rotation_interval=$(get_tmux_option "@running-app-rotation-interval" "5")
  local size=$(get_tmux_option "@running-app-status-size" "1")
  local app_icons="$(interpolate_apps "$timeout" "$@")"
  local time_offset="$(date '+%s')"

  scrolling_lines "$app_icons" "$size" "$(( time_offset / rotation_interval ))"
}

main "$@"
