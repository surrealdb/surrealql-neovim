vim.opt.rtp:prepend(vim.fn.getcwd())

local pack = vim.fn.stdpath("data") .. "/site/pack/test/start"
vim.opt.rtp:prepend(pack .. "/plenary.nvim")
vim.opt.rtp:prepend(pack .. "/nvim-treesitter")

vim.cmd("runtime plugin/plenary.vim")
