<div align="center">

# izumin5210's dotfiles

[![CI](https://github.com/izumin5210/dotfiles/actions/workflows/main.yml/badge.svg)](https://github.com/izumin5210/dotfiles/actions/workflows/main.yml)
![GitHub License](https://img.shields.io/github/license/izumin5210/dotfiles)

</div>

## Supported OS

- macOS
  - manage packages with Nix [Home Manager](https://github.com/nix-community/home-manager)
  - manage system preferences with [nix-darwin](https://github.com/lnl7/nix-darwin)
  - manage macOS apps with [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) and [mas-cli](https://github.com/mas-cli/mas)
- GitHub Codespaces (Ubuntu)
  - manage tools with [aqua](https://aquaproj.github.io/)

## Installation

### macOS

1. Install [Homebrew](https://brew.sh/)
2. Install Nix with [`nix-installer`](https://github.com/DeterminateSystems/nix-installer)
3. Run following commands

```sh
git clone https://github.com/izumin5210/dotfiles ~/src/github.com/izumin5210/dotfiles
cd ~/src/github.com/izumin5210/dotfiles
./bin/apply-configurations
./bin/deploy-config-files
```
