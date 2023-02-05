local wk = require('which-key')

wk.register({
  ["<leader>"] = {
    nrw = {
      name = "Netrw",
      o = { "<cmd>Ex<cr>", "Open Netrw" },
    },
  },
})
