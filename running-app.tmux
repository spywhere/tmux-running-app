#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

status_key="\#{running_app}"

normalize_text() {
  printf "%s" "$@" | tr '[:upper:]' '[:lower:]' | sed 's/[_|/ ]/-/g' | sed 's/[^a-zA-Z0-9\-]//g'
}

platform="$(normalize_text "$(uname -s)")"
architecture="$(normalize_text "$(uname -m)")"

apps=(
  "docker"
  "mpd"
)

optimize_apps() {
  local app_format="$1"
  local output=""

  for ((i=0; i<${#apps[@]}; i++)); do
    local name="${apps[$i]}"

    local key="{$name}"

    local platform_key="@running-app-$name"
    local app_enable=$(get_tmux_option "$platform_key-$platform" "yes")
    if test "$app_enable" = "no"; then
      # App for <platform> is disabled
      continue
    fi

    app_enable=$(get_tmux_option "$platform_key-$architecture" "yes")
    if test "$app_enable" = "no"; then
      # App for <architecture> is disabled
      continue
    fi

    app_enable=$(get_tmux_option "$platform_key-$platform-$architecture" "yes")
    if test "$app_enable" = "no"; then
      # App for <platform> and <architecture> is disabled
      continue
    fi

    if (printf "%s" "$app_format" | grep -q "$key"); then
      if test -n "$output"; then
        output="$output $name"
      else
        output="$name"
      fi
    fi
  done

  echo "$output"
}

update_tmux_option() {
  local option="$1"
  local apps="$2"
  local option_value="$(get_tmux_option "$option")"

  local value=""
  if test -n "$apps"; then
    value="#($CURRENT_DIR/scripts/app.sh $apps)"
  fi

  option_value=${option_value//${status_key}/${value}}
  set_tmux_option "$option" "$option_value"
}

main() {
  local status_format=$(get_tmux_option "@running-app-status-format" "") # E.g. {docker}{mpd}
  local left_status_format=$(get_tmux_option "@running-app-status-left-format" "$status_format")
  local right_status_format=$(get_tmux_option "@running-app-status-right-format" "$status_format")

  if test -n "$left_status_format"; then
    update_tmux_option "status-left" "$(optimize_apps "$left_status_format")"
  fi
  if test -n "$right_status_format"; then
    update_tmux_option "status-right" "$(optimize_apps "$right_status_format")"
  fi
}

main
