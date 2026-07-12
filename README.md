# kamachi

Personal dotfiles — versioned `cmdp` command palette.

## What's inside

- `cmdp.sh` — fuzzy command palette powered by `fzf`, bound to `Ctrl+G`
- `commands` — personal command database (`category :: title :: command`)
- `install.sh` — sets up symlinks and patches `.bashrc`

## Install

```bash
git clone git@github.com:satoscode/kamachi.git ~/repos/freelance/kamachi
cd ~/repos/freelance/kamachi
bash install.sh   # or: chmod +x install.sh && ./install.sh
source ~/.bashrc
```

## Usage

| Action | How |
|--------|-----|
| Open palette | `Ctrl+G` |
| Edit commands file | `cmde` |
| List commands | `cmdr` |

## Managing commands

`cmdm` is an interactive CLI for managing the commands database:

```bash
cmdm          # opens action menu (TUI)
cmdm list     # show categories with command count
cmdm add      # add a new command (interactive prompts)
cmdm edit     # pick and edit an existing command
cmdm rm       # pick and delete a command
```

All prompts support arrow keys and readline editing (`Ctrl+A`, `Ctrl+E`, `Ctrl+W`, etc.).

## Command format

```
category :: title :: command
```

## Syncing

After adding or editing commands, commit to keep in sync:

```bash
git add commands && git commit -m "add: description"
```

## Dependencies

- `fzf`
