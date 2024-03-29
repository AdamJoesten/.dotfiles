#! /usr/bin/env bash
# Description: fresh install script for ubuntu

curl --parallel --parallel-immediate --parallel-max 3 --config sources.txt --output $HOME/Downloads/1password.deb

# Applications
sudo apt install -y $HOME/Downloads/1password.deb

# restricted ubunut extras
# vlc
# remove videos
# google chrome
# kitty
# fish
# wezterm
# git
# asdf
# asdf nodejs
# asdf bun
# asdf deno
# asdf python
# just
# hyperfine
# hexyl
# rustlang
# golang
# pnpm
# nvim
# docker
# jo
# jt
# jq
# wally
# bat
# fdfind -> fd
# rg
# gitui
# eza
#
# Fonts
mkdir -p $HOME/.local/share/fonts
unzip -o $HOME/Downloads/*.zip -d $HOME/.local/share/fonts
