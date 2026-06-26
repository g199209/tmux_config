# tmux_config

My personal tmux config — aiming to feel "good out of the box, like zellij": a nice status bar, no need to memorize keybindings, and zellij-style modal operation.

## Features

- **Theme**: [catppuccin](https://github.com/catppuccin/tmux) **Mocha**, rounded pill-style tab bar, placed at the **top**.
- **No memorizing keys**: [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key) — `prefix + Space` pops up a drill-down action menu.
- **Prefix-free pane switching**: `Alt + h/j/k/l` (or `Alt + arrow keys`), just like zellij.
- **zellij-style modes**: `Ctrl+p` enters PANE mode, `Ctrl+w` enters TAB (window) mode. Inside a mode you operate with single keys (action keys auto-exit when done, movement keys stay in the mode); `Esc` exits. The top bar shows the current mode + available keys.
- **Floating terminal**: [tmux-floax](https://github.com/omerxx/tmux-floax) — `Alt+f` toggles a floating terminal whose content persists (mirrors zellij's Alt+f).
- **Scrollbar**: `modal` — appears on the right only while scrolling, otherwise out of sight (needs tmux ≥ 3.5).
- Mouse support, vi copy-mode keys, 50k scrollback, true color, and other common bits are pre-configured.

## Requirements

- **tmux ≥ 3.5** (required for the scrollbar; 3.6+ recommended). On my box tmux is built from source under `~/.local/bin`.
- **A monospace font with Nerd Font glyphs**, installed on **the machine running the terminal** (over SSH that's your local Mac/Windows, not the server).
  Recommended: **[Maple Mono NF CN](https://github.com/subframe7536/maple-font/releases)** (Nerd glyphs + Chinese + monospace). After installing, select `Maple Mono NF CN` as the terminal font.
  With the wrong font, the status bar's session/clock icons render as boxes/question marks.
- `git` (the setup script uses it to install plugins).

## Install (new machine)

```sh
git clone git@github.com:g199209/tmux_config.git ~/.config/tmux
~/.config/tmux/setup.sh
tmux
```

`setup.sh` will:
1. Symlink `~/.tmux.conf` → this repo's `tmux.conf` (an existing real file is backed up to `~/.tmux.conf.bak`);
2. Clone the plugins into `~/.tmux/plugins/` (TPM, catppuccin@v2.3.0, which-key, floax — and pull which-key's PyYAML submodule automatically).

> You can clone to a different directory too; `setup.sh` locates itself automatically. `~/.config/tmux` is just the recommended spot.
> The script is idempotent and safe to re-run.

## Common keybindings

`prefix` = `Ctrl+b`. **Forgot something? Press `prefix` then `Space` and read the menu.**

| Action | Keys |
| --- | --- |
| which-key menu | `prefix` `Space` |
| Switch pane (prefix-free) | `Alt+h/j/k/l` or `Alt+arrows` |
| New pane | `Alt+n` |
| Toggle floating terminal | `Alt+f` (content persists) |
| Split left-right / top-bottom | `prefix` `\|` / `-` |
| New window (≈ tab) | `prefix` `c` |
| Zoom / unzoom pane | `prefix` `z` |
| PANE mode (prefix-free) | `Ctrl+p` → `hjkl` move / `n s x z` (auto-exit) / `Esc` to leave |
| TAB mode (prefix-free) | `Ctrl+w` (w=window) → `h l` switch / `n x r` (auto-exit) / `Esc` to leave |
| Reload config | `prefix` `r` |
| Detach / reattach | `prefix` `d` / `tmux a` |

The mouse works throughout: click to focus a pane, drag borders to resize, scroll to page through history (the scrollbar appears on the right only while scrolling). Use `Shift` + drag for terminal-native text selection.

### Floating terminal (floax) controls

`Alt+f` opens it (press again inside to hide; content persists). While it's open (`Ctrl+Alt` = `C-M`):

| Keys | Action |
| --- | --- |
| `Ctrl+Alt+s` / `Ctrl+Alt+b` | grow / shrink |
| `Ctrl+Alt+f` | fullscreen |
| `Ctrl+Alt+r` | reset to default size |
| `Ctrl+Alt+e` | embed (turn the float into a normal tiled pane) |
| `Ctrl+Alt+d` / `Ctrl+Alt+u` | lock / unlock |

`prefix + P` opens floax's options menu as an alternative to these keys.

## Update

```sh
cd ~/.config/tmux && git pull
# Config changes: just press prefix + r inside tmux to reload.
# To bump a plugin version: edit the @plugin pin in tmux.conf / the pin in setup.sh, then re-run setup.sh.
```

## Machine-specific config

To add settings that apply only on one machine: create `~/.config/tmux/local.conf` (ignored by `.gitignore`)
and append `source -q ~/.config/tmux/local.conf` at the end of `tmux.conf`.
