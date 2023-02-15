local colorscheme = {}

colorscheme[1] = "folke/tokyonight.nvim"
colorscheme.lazy = false -- make sure we load this during startup to avoid buggy highlight groups 
colorscheme.priority = 1000 -- make sure to load this before all the other startup plugins
colorscheme.opts = { style = "night" }
colorscheme.init = function()
	vim.cmd.colorscheme("tokyonight") -- load the colorscheme here
    end

return colorscheme
