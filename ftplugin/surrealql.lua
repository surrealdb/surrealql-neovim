local ok, surrealql = pcall(require, "surrealql")
local ft = ok and surrealql.get_config().filetype or require("surrealql.config").defaults.filetype

vim.bo.commentstring = ft.commentstring
vim.bo.tabstop = ft.tabstop
vim.bo.shiftwidth = ft.shiftwidth
vim.bo.expandtab = ft.expandtab
