local M = {}

local defaults = require("surrealql.config").defaults
local _config = nil

---@class SurrealQLConfig
---@field treesitter? { enable?: boolean, url?: string, revision?: string }
---@field filetype? { commentstring?: string, tabstop?: number, shiftwidth?: number, expandtab?: boolean }
---@field lsp? { enable?: boolean, cmd?: string[], on_attach?: function, capabilities?: table }

function M.get_config()
  return _config or defaults
end

---@param opts? SurrealQLConfig
function M.setup(opts)
  _config = vim.tbl_deep_extend("force", defaults, opts or {})

  if _config.treesitter.enable then
    M._register_parser(_config.treesitter)
  end

  require("surrealql.lsp").setup(_config.lsp)
end

function M._register_parser(ts_config)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok or type(parsers) ~= "table" then
    return
  end

  if parsers.surrealql then
    return
  end

  parsers.surrealql = {
    install_info = {
      url = ts_config.url,
      revision = ts_config.revision,
    },
    maintainers = { "@surrealdb" },
    tier = 3,
  }
end

return M
