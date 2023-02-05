vim.opt.autoindent = true
vim.opt.shiftwidth = 4 -- # of spaces to use for each step of auto indent
vim.opt.softtabstop = 4 -- # of spaces <Tab> counts for while editing
vim.opt.expandtab = true -- use appropriate # of spaces to insert a <Tab>
vim.opt.incsearch = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.wrap = false
vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undodir'
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.lisp = true

vim.g.mapleader = ';'
vim.keymap.set({'n', 'i', 'v'}, '<UP>', '<ESC>')
vim.keymap.set({'n', 'i', 'v'}, '<RIGHT>', '<ESC>')
vim.keymap.set({'n', 'i', 'v'}, '<LEFT>', '<ESC>')
vim.keymap.set({'n', 'i', 'v'}, '<DOWN>', '<ESC>')

