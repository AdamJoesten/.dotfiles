# Adamj's Linux Dotfiles & Developer Environment

A streamlined, portable, and feature-rich configuration for Linux. This repository serves as the single source of truth for bootstrapping a complete developer experience (DX) from a bare-metal install.

## 🚀 Core Philosophy

* **Portability:** Everything is driven by a single bootstrap script, ensuring a consistent environment across different machines.
* **Modularity:** Configurations are grouped by application using [GNU Stow](https://www.gnu.org/software/stow/) for clean, conflict-free symlinking.
* **Performance:** Lightweight, compiled tools are prioritized for a snappy, responsive terminal experience.

## 🧰 What's Included

### Terminal & Shell
* **Shell:** `Zsh` coupled with `Starship` for a fast, context-aware prompt.
<!-- * **Multiplexer:** `Tmux` for persistent sessions, split panes, and robust workspace management. -->
* **Core Utilities:** Modern Rust-based replacements for standard tools (`eza` for `ls`, `bat` for `cat`, `ripgrep` for `grep`, `fd` for `find`).

### Development Toolchains
Pre-configured environments, paths, and package managers for:
* **Rust:** `rustup`, `cargo`, and essential binaries.
* **Go:** Workspace paths and binary execution.
* **Zig:** Compiler toolchain integration.
* **C/C++:** Make, CMake, and compiler configurations.
* **TypeScript/JavaScript:** Fast node version management via `fnm`.

### Editor & Workflow
* **Neovim:** A modular Lua-based configuration with native LSP support for the languages listed above.
* **Knowledge Management:** Environment variables and automated sync scripts for integrating Zettelkasten notes and Obsidian vaults seamlessly into the command-line workflow.

## 📂 Directory Structure

```text
```