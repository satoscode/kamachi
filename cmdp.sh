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

cmdm() {
  local file="${CMDP_FILE:-$HOME/.commands}"
  case "${1:-tui}" in
    tui)
      local action
      action=$(printf 'list\nadd\nedit\nrm' | \
               fzf --height=20% --reverse --prompt='cmdm> ')
      [ -z "$action" ] && return
      cmdm "$action"
      ;;
    list|ls)
      awk -F' :: ' '
        /^#/ { cat=substr($0,3); next }
        /^[[:space:]]*$/ { next }
        { count[cat]++ }
        END { for (c in count) printf "%-20s %d commands\n", c, count[c] }
      ' "$file" | sort
      ;;
    add)
      read -e -p "Category: " -r cat
      read -e -p "Title:    " -r title
      read -e -p "Command:  " -r cmd
      [[ -z "$cat" || -z "$title" || -z "$cmd" ]] && { echo "Cancelled."; return 1; }
      printf "%s :: %s :: %s\n" "$cat" "$title" "$cmd" >> "$file"
      echo "Added."
      ;;
    edit)
      local line
      line=$(grep -v '^#\|^[[:space:]]*$' "$file" | \
             fzf --height=40% --reverse --prompt='edit> ')
      [ -z "$line" ] && return
      local old_cat old_title old_cmd
      old_cat=$(echo "$line"   | awk -F' :: ' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); print $1}')
      old_title=$(echo "$line" | awk -F' :: ' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2}')
      old_cmd=$(echo "$line"   | awk -F' :: ' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}')
      read -e -p "Category: " -i "$old_cat"   -r cat
      read -e -p "Title:    " -i "$old_title" -r title
      read -e -p "Command:  " -i "$old_cmd"   -r cmd
      [[ -z "$cat" || -z "$title" || -z "$cmd" ]] && { echo "Cancelled."; return 1; }
      awk -v old="$line" -v new="${cat} :: ${title} :: ${cmd}" \
        '$0 == old { print new; next } { print }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
      echo "Updated."
      ;;
    rm|del)
      local line
      line=$(grep -v '^#\|^[[:space:]]*$' "$file" | \
             fzf --height=40% --reverse --prompt='delete> ')
      [ -z "$line" ] && return
      printf "Delete: %s\n[y/N] " "$line"; read -r confirm
      [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Cancelled."; return; }
      awk -v del="$line" '$0 != del' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
      echo "Deleted."
      ;;
    *)
      echo "Usage: cmdm <list|add|edit|rm>"
      ;;
  esac
}

alias cmde="${EDITOR:-nvim} ${CMDP_FILE:-$HOME/.commands}"
alias cmdr="cat ${CMDP_FILE:-$HOME/.commands}"

bind -x '"\C-g": cmdp'
