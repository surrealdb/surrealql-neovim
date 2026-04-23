if vim.g.loaded_surrealql then
  return
end
vim.g.loaded_surrealql = true

local surrealql = require("surrealql")
local ts_config = surrealql.get_config().treesitter

surrealql._register_parser(ts_config)

vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreesitterParsersLoaded",
  once = true,
  callback = function()
    surrealql._register_parser(surrealql.get_config().treesitter)
  end,
})

vim.api.nvim_create_user_command("SurrealQLInstall", function()
  require("surrealql.install").install()
end, { desc = "Install the SurrealQL language server" })
