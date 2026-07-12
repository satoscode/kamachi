#!/usr/bin/env bash
# Command palette fuzzy con fzf
# Archivo de datos: ~/.commands
# Formato: categoria :: titulo :: comando

cmdp() {
  local file="${CMDP_FILE:-$HOME/.commands}"
  [ -f "$file" ] || {
    echo "No existe $file"
    return 1
  }

  local selected
  selected=$(awk -F' :: ' '
      /^#/ || /^[[:space:]]*$/ { next }
      NR==FNR { if (length($1)>w1) w1=length($1); if (length($2)>w2) w2=length($2); next }
      { printf "%-*s  %-*s  \033[90m%s\033[0m\t%s\t%s\t%s\n", w1, $1, w2, $2, $3, $1, $2, $3 }
    ' "$file" "$file" |
    sort -t$'\t' -k2,2 -k3,3 |
    fzf --ansi \
      --delimiter=$'\t' \
      --with-nth=1 \
      --height=40% \
      --reverse \
      --prompt='cmd> ')

  [ -z "$selected" ] && return

  local cmd
  cmd=$(echo "$selected" | awk -F'\t' '{print $4}')

  READLINE_LINE="$cmd"
  READLINE_POINT=${#cmd}
}

alias cmde="${EDITOR:-nvim} ${CMDP_FILE:-$HOME/.commands}"
alias cmdr="cat ${CMDP_FILE:-$HOME/.commands}"

bind -x '"\C-g": cmdp'
