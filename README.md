# nix-config

> Formerly my `dotfiles` repo.
> I went all-in on nix and absolutely love it; [you should too](https://zero-to-nix.com/)!


## Overview
This repo is managed at the top level via `flake.nix`, which defines configuration for:
- My personal MacBook Pro
- My work MacBook Pro (requires a special `work-extras.nix`)
- An old PC I have lying around that I refuse to recycle (I'll find a use for it some day...)

The two MBPs are configured via [nix-darwin].
Since I'm bound to forget how to set that up on a new machine, here's the TL;DR:
```zsh
# Install nix
# SAY NO WHEN PROMPTED IF YOU WANT THE DETERMINATE FLAVOR OF NIX!
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Setup for nix-darwin
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
cd /etc/nix-darwin
git clone git@github.com:GregoryConrad/nix-config.git .
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#HOSTNAME-GOES-HERE
# NOTE: you can run `darwin-rebuild switch` after the above is run for the first time
```


## Tech I Use
- Nix (obviously)
- [nix-darwin] for configuring macOS to my liking
- [home-manager] for configuring my dotfiles, programs, and other config
- [fish] for my shell (with a modified [fish-helix](https://github.com/sshilovsky/fish-helix))
- [Helix] for text/code editing
- [WezTerm] for my terminal (with the Hack Nerd Font)
  - I love the scripting via Lua


[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
[fish]: https://fishshell.com/
[Helix]: https://helix-editor.com
[WezTerm]: https://wezfurlong.org/wezterm/
