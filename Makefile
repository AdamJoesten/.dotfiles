# DX Wizard Dotfiles Makefile
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW_PKGS := nvim git shell lang_node

.PHONY: all fs apt rust node fonts stow clean

all: fs apt rust node fonts stow

fs:
	@echo "=> Establishing local filesystem..."
	@bash $(DOTFILES_DIR)/scripts/00-filesystem-setup.sh

apt: fs
	@echo "=> Ensuring base APT dependencies..."
	@bash $(DOTFILES_DIR)/scripts/00-apt-install.sh

rust: apt
	@echo "=> Ensuring Rust toolchain..."
	@bash $(DOTFILES_DIR)/scripts/01-cargo-install.sh

node: apt
	@echo "=> Ensuring Node.js & pnpm..."
	@bash $(DOTFILES_DIR)/scripts/02-node-install.sh

fonts: fs
	@echo "=> Installing Nerd Fonts..."
	@bash $(DOTFILES_DIR)/scripts/05-fonts-install.sh

stow:
	@echo "=> Stowing packages to $(HOME)..."
	@bash $(DOTFILES_DIR)/scripts/03-stow-link.sh $(STOW_PKGS)

clean:
	@echo "=> Removing stowed symlinks..."
	@for pkg in $(STOW_PKGS); do \
		stow -D -t $(HOME) -d $(DOTFILES_DIR) $$pkg; \
	done
