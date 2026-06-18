if vim.g.loaded_surrealql then
  return
end
vim.g.loaded_surrealql = true

local function register()
  local surrealql = require("surrealql")
  surrealql._register_parser(surrealql.get_config().treesitter)
end

-- Register eagerly so `:TSInstall surrealql` works before any event fires,
-- and re-register on `TSUpdate` (the event nvim-treesitter `main` emits once
-- its parser registry is ready). The old `NvimTreesitterParsersLoaded` event
-- never existed on either branch, so it never fired.
register()

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = register,
})

vim.api.nvim_create_user_command("SurrealQLInstall", function()
  require("surrealql.install").install()
end, { desc = "Install the SurrealQL language server" })
