# DX Wizard Dotfiles Makefile
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW_PKGS := git lang_c_cxx lang_node lang_python lang_rust nvim shell

.PHONY: all fs apt flatpak rust node python buildtools fonts hw gui nvim stow clean

all: fs apt flatpak rust node python buildtools fonts hw gui nvim stow

fs:
	@echo "=> Establishing local filesystem..."
	@bash $(DOTFILES_DIR)/scripts/00-filesystem-setup.sh

apt: fs
	@echo "=> Ensuring base APT dependencies..."
	@bash $(DOTFILES_DIR)/scripts/01-apt-install.sh

flatpak: apt
	@echo "=> Setting up Flatpak..."
	@bash $(DOTFILES_DIR)/scripts/02-flatpak-setup.sh

rust: apt
	@echo "=> Ensuring Rust toolchain..."
	@bash $(DOTFILES_DIR)/scripts/03-cargo-install.sh

node: apt
	@echo "=> Ensuring Node.js & pnpm..."
	@bash $(DOTFILES_DIR)/scripts/04-node-install.sh

python: apt
	@echo "=> Ensuring Python toolchain (uv)..."
	@bash $(DOTFILES_DIR)/scripts/10-python-install.sh

stow:
	@echo "=> Stowing packages to $(HOME)..."
	@bash $(DOTFILES_DIR)/scripts/05-stow-link.sh $(STOW_PKGS)

buildtools: apt
	@echo "=> Ensuring C/C++ Build Tools..."
	@bash $(DOTFILES_DIR)/scripts/06-buildtool-install.sh

fonts: fs
	@echo "=> Installing Nerd Fonts..."
	@bash $(DOTFILES_DIR)/scripts/07-fonts-install.sh

hw: fs
	@echo "=> Setting up Hardware Rules..."
	@bash $(DOTFILES_DIR)/scripts/08-zsa-udev-install.sh

gui: flatpak
	@echo "=> Installing GUI Applications..."
	@bash $(DOTFILES_DIR)/scripts/09-gui-apps-install.sh

nvim: apt
	@echo "=> Ensuring Neovim (Unstable)..."
	@bash $(DOTFILES_DIR)/scripts/11-nvim-install.sh

stow:
	@echo "=> Removing stowed symlinks..."
	@for pkg in $(STOW_PKGS); do \
		stow -D -t $(HOME) -d $(DOTFILES_DIR) $$pkg; \
	done
