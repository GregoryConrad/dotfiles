# dotfiles
- Managed with [yadm](https://yadm.io)
- [Helix](https://helix-editor.com) for text/code editing
- [WezTerm](https://wezfurlong.org/wezterm/) for terminal with Hack font
  - I like the configurability via Lua

## Changes
- Used to run neovim and also VS Code + Vim keybindings, but Helix *just works* with no effort
- Daily drove [Warp](https://www.warp.dev) as my terminal for some months
  - Not a fan that you can't store your entire config in `~/.warp/`
  - Too much extra ~crap~ bloat included (like proprietary AI integration)
- Also tried [kitty](https://sw.kovidgoyal.net/kitty/) for a couple weeks
  - No builtin splits, admist a few other things
    - I'd rather my software do the bare minimum *very well* or be an all-encompassing package
- After kitty tried [Alacritty](https://alacritty.org) + [Zellij](https://zellij.dev)
  - Alacritty had some rough edges that I didn't like (was _too_ minimal)
  - Zellij is modal, which I don't want for a multiplexer. I just want to hit Alt+Key and move on
- Finally switched to `fish` from `zsh` after I realized I get everything I want for free in `fish`
  - Plus it's way more understandable and, as an added bonus, now written in Rust
