#!/usr/bin/env bash
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "${dst}.bak"
    echo "Backup: ${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "Linked: $dst → $src"
}

link "$REPO/cmdp.sh"  "$HOME/.cmdp.sh"
link "$REPO/commands" "$HOME/.commands"

BASHRC="$HOME/.bashrc"
LINE='[ -f ~/.cmdp.sh ] && source ~/.cmdp.sh'
grep -qxF "$LINE" "$BASHRC" || echo "$LINE" >> "$BASHRC"

echo "Done. Run: source ~/.bashrc"
