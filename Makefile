# .dotfiles Makefile

# 1. Variables & Paths
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SCRIPTS_DIR := $(DOTFILES_DIR)/scripts

# Auto-discover stow packages (directories that aren't .git, scripts, or build artifacts)
EXCLUDE_DIRS := .git scripts hardware
STOW_PKGS := $(shell find . -maxdepth 1 -type d ! -name ".*" $(foreach dir,$(EXCLUDE_DIRS),! -name "$(dir)") -printf '%f\n')

.PHONY: all fs apt flatpak rust node python buildtools fonts hw gui nvim stow unstow help sync

# 2. Primary Entry Points
all: fs apt flatpak rust node python buildtools fonts hw gui nvim stow

sync: stow
	@echo "=> Synchronizing all toolchains..."
	@$(MAKE) rust node python nvim

help:
	@echo "Dotfiles Management CLI"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        - Full bootstrap from scratch"
	@echo "  sync       - Update configurations and toolchains"
	@echo "  stow       - Link all configurations using GNU Stow"
	@echo "  unstow     - Remove all stowed symlinks"
	@echo "  fs         - Setup XDG directory structure"
	@echo "  apt        - Sync APT dependencies and LLVM"
	@echo "  node/rust  - Sync specific language toolchains"
	@echo "  nvim       - Sync Neovim setup"

# 3. Foundation
fs:
	@echo "=> Establishing local filesystem..."
	@bash $(SCRIPTS_DIR)/setup_fs.sh

apt: fs
	@echo "=> Ensuring base APT dependencies..."
	@bash $(SCRIPTS_DIR)/install_apt.sh

# 4. Toolchains
flatpak: apt
	@echo "=> Setting up Flatpak..."
	@bash $(SCRIPTS_DIR)/setup_flatpak.sh

rust: apt
	@echo "=> Ensuring Rust toolchain..."
	@bash $(SCRIPTS_DIR)/install_rust.sh

node: apt
	@echo "=> Ensuring Node.js & pnpm..."
	@bash $(SCRIPTS_DIR)/install_node.sh

python: apt
	@echo "=> Ensuring Python toolchain (uv)..."
	@bash $(SCRIPTS_DIR)/install_python.sh

buildtools: apt
	@echo "=> Ensuring C/C++ Build Tools..."
	@bash $(SCRIPTS_DIR)/install_buildtools.sh

nvim: apt
	@echo "=> Ensuring Neovim (Unstable)..."
	@bash $(SCRIPTS_DIR)/install_nvim.sh

# 5. System & Assets
fonts: fs
	@echo "=> Installing Nerd Fonts..."
	@bash $(SCRIPTS_DIR)/install_fonts.sh

hw: fs
	@echo "=> Setting up Hardware Rules..."
	@bash $(SCRIPTS_DIR)/setup_udev.sh

gui: flatpak
	@echo "=> Installing GUI Applications..."
	@bash $(SCRIPTS_DIR)/install_gui.sh

# 6. Stow Orchestration
stow:
	@echo "=> Stowing packages: $(STOW_PKGS)"
	@bash $(SCRIPTS_DIR)/stow_pkgs.sh $(STOW_PKGS)

unstow:
	@echo "=> Removing stowed symlinks..."
	@for pkg in $(STOW_PKGS); do \
		stow -D -v -t $(HOME) -d $(DOTFILES_DIR) $$pkg; \
	done
