local M = {}

function M.start(lsp_config)
  local root = vim.fs.dirname(
    vim.fs.find({ ".git", "surreal.json" }, { upward = true })[1]
  ) or vim.fn.getcwd()

  vim.lsp.start({
    name = "surrealql",
    cmd = lsp_config.cmd,
    root_dir = root,
    capabilities = lsp_config.capabilities,
    on_attach = lsp_config.on_attach,
    filetypes = { "surrealql" },
  })
end

local function register_autocmd(lsp_config)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "surrealql",
    group = vim.api.nvim_create_augroup("surrealql_lsp", { clear = true }),
    callback = function()
      M.start(lsp_config)
    end,
  })
end

function M.setup(lsp_config)
  if not lsp_config.enable then
    return
  end

  local install = require("surrealql.install")
  local installed, bin = install.is_installed()

  if installed then
    local cfg = vim.tbl_extend("force", lsp_config, { cmd = { bin } })
    register_autocmd(cfg)
    return
  end

  if lsp_config.auto_install then
    install.install(function(ok, bin_path)
      if ok then
        local cmd = bin_path and { bin_path } or lsp_config.cmd
        register_autocmd(vim.tbl_extend("force", lsp_config, { cmd = cmd }))
      end
    end)
    return
  end

  vim.notify(
    "[surrealql] surrealql-language-server not found. Run :SurrealQLInstall or set lsp.auto_install = true.",
    vim.log.levels.WARN
  )
end

return M
