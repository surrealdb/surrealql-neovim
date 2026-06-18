local M = {}

local defaults = require("surrealql.config").defaults
local _config = nil

---@class SurrealQLConfig
---@field treesitter? { enable?: boolean, url?: string, branch?: string, revision?: string, files?: string[] }
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

  if type(parsers.get_parser_configs) == "function" then
    -- Legacy nvim-treesitter (`master` branch): parser configs live behind
    -- get_parser_configs(). Update an existing entry rather than bailing so
    -- a later setup() can override the eager default registration.
    local configs = parsers.get_parser_configs()
    configs.surrealql = vim.tbl_deep_extend("force", configs.surrealql or {}, {
      install_info = {
        url = ts_config.url,
        branch = ts_config.branch,
        files = ts_config.files,
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = "surrealql",
      maintainers = { "@surrealdb" },
    })
  else
    -- New nvim-treesitter (`main` branch): the module itself is the parser
    -- registry, indexed by language. `revision` is the git ref it fetches
    -- (`<url>/archive/<revision>.tar.gz`), so it tracks the grammar's
    -- `master` branch — matching the queries this plugin ships. `tier = 3`
    -- keeps surrealql out of `:TSInstall all` unless requested by name.
    parsers.surrealql = vim.tbl_deep_extend("force", parsers.surrealql or {}, {
      install_info = {
        url = ts_config.url,
        revision = ts_config.revision,
      },
      tier = 3,
    })
  end
end

return M
