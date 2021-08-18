set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -qv "$option")"
  if [ -z "$option_value" ]; then
    option_value="$(tmux show-option -gqv "$option")"
  fi
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

scrolling_lines() {
  local text="$1"
  local size="$2"
  local offset="$3"
  local total_line
  if test $# -ge 4; then
    total_line="$4"
  else
    total_line=$(( $(printf "%s" "$text" | wc -l) + 1 ))
  fi
  local index
  local padded_text
  if test "$total_line" -gt "$size"; then
    index=$(( (offset % total_line) + 1 ))
    padded_text="$(printf "%s\n%s" "$text" "$text")"
    printf "%s" "$padded_text" | awk "{ORS=\"\"}NR>=$index&&NR<$(( index + size ))"
  else
    printf "%s" "$text" | awk '{ORS=""}{print $0}'
  fi
}
