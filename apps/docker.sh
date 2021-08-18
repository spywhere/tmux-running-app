#!/usr/bin/env bash

DOCKER_ICON="$(get_tmux_option "@running-app-docker-icon" "D")"
DOCKER_STARTING_ICON="$(get_tmux_option "@running-app-docker-icon-starting" "d")"

get_icon() {
  if ! test "$(command -v docker 2>/dev/null)"; then
    printf ""
    return 0
  fi

  docker_info=$(docker info 2>&1)
  if test $? -eq 0; then
    docker_start=""
    printf "$DOCKER_ICON"
  fi
  if test -n "$DOCKER_STARTING_ICON" && (echo "$docker_info" | grep -q "refused"); then
    printf "$DOCKER_STARTING_ICON"
  fi
}
