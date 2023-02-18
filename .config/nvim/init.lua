local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- The above bootstraps lazy.nvim

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
require("lazy").setup(
    {
        { import = "plugins" } -- Install and import neovim plugin configs to lazy.nvim
    },
    {
        defaults = {
            lazy = true,
            version = "*" -- enable this to try installing the latest stable versions of plugins
        }
    }
)
require("nvim") -- Import neovim specific config
require("config") -- Import plugin specific configuration and customization
