local whichkey = {}

whichkey[1] = "folke/which-key.nvim"
whichkey.config = function()
    require("which-key").setup({
       -- your configuration comes here
    })
end
return whichkey
