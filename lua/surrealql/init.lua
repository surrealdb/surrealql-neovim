local M = {}

local defaults = require("surrealql.config").defaults
local _config = nil

---@class SurrealQLConfig
---@field treesitter? { enable?: boolean, url?: string, branch?: string, files?: string[] }
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
  if not ok then
    return
  end

  -- nvim-treesitter `main` removed get_parser_configs() in favour of a
  -- different parser registry. Bail out cleanly instead of calling a nil
  -- value, which previously errored at plugin load on the `main` branch.
  if type(parsers.get_parser_configs) ~= "function" then
    return
  end

  local parser_configs = parsers.get_parser_configs()
  if parser_configs.surrealql then
    return
  end

  parser_configs.surrealql = {
    install_info = {
      url = ts_config.url,
      files = ts_config.files,
      branch = ts_config.branch,
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },
    filetype = "surrealql",
    maintainers = { "@surrealdb" },
  }
end

return M
