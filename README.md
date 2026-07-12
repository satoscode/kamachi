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
bash install.sh
source ~/.bashrc
```

## Usage

| Action | How |
|--------|-----|
| Open palette | `Ctrl+G` |
| Edit commands | `cmde` |
| List commands | `cmdr` |

## Adding commands

Open `cmde`, add a line following the format:

```
category :: title :: command
```

Then commit:

```bash
git add commands && git commit -m "add: description"
```

## Dependencies

- `fzf`
