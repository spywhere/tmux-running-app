#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$(dirname "$CURRENT_DIR")/scripts/cache.sh"

MPD_ICON="$(get_tmux_option "@running-app-mpd-icon" "M")"
MPD_ICON_STOP="$(get_tmux_option "@running-app-mpd-icon-stopped" "m")"
MPD_HOST="$(get_tmux_option "@running-app-mpd-host" "127.0.0.1")"
MPD_PORT="$(get_tmux_option "@running-app-mpd-port" "6600")"

is_running() {
  if ! test -n "$(command -v nc)"; then
    return 1
  fi
  if (printf "close\n" | nc "$MPD_HOST" "$MPD_PORT" | grep -q "OK MPD"); then
    return 0
  else
    return 1
  fi
}

get_icon() {
  if ! is_running; then
    printf ""
    return 0
  fi

  _mpd_status() {
    sh -c "(printf \"status\nclose\n\"; sleep 0.05) | nc \"$MPD_HOST\" \"$MPD_PORT\""
  }

  local mpd_status="$(_cache_value mpd_status _mpd_status)"
  local mpd_state="$(printf "%s" "$mpd_status" | awk '$1 ~ /^state:/ { print $2 }')"

  if test "$mpd_state" = "stop"; then
    printf "$MPD_ICON_STOP"
    return 0
  fi

  printf "$MPD_ICON"
}
