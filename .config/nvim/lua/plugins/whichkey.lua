local whichkey = {}

whichkey[1] = "folke/which-key.nvim"
whichkey.config = function()
    require("which-key").setup({
       -- your configuration comes here
       -- or leave it empty to use the default settings
       -- refer to the configuration section below
    })
end
return whichkey
