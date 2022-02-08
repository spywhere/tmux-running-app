#!/usr/bin/env bash

PODMAN_ICON="$(get_tmux_option "@running-app-podman-icon" "P")"
PODMAN_STARTING_ICON="$(get_tmux_option "@running-app-podman-icon-starting" "p")"

get_icon() {
  if ! test "$(command -v podman 2>/dev/null)"; then
    printf ""
    return 0
  fi

  podman_info=$(podman info 2>&1)
  if test $? -eq 0; then
    printf "$PODMAN_ICON"
  fi
  if test -n "$PODMAN_STARTING_ICON" && (echo "$podman_info" | grep -q "reset by peer"); then
    printf "$PODMAN_STARTING_ICON"
  fi
}
