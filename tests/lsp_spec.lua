describe("surrealql.lsp", function()
  local lsp
  local defaults

  before_each(function()
    package.loaded["surrealql.lsp"] = nil
    package.loaded["surrealql.config"] = nil
    lsp = require("surrealql.lsp")
    defaults = require("surrealql.config").defaults.lsp
  end)

  after_each(function()
    pcall(vim.api.nvim_del_augroup_by_name, "surrealql_lsp")
  end)

  describe("setup", function()
    local function mock_install(installed)
      package.loaded["surrealql.install"] = {
        is_installed = function() return installed, installed and "surrealql-language-server" or nil end,
        install = function(cb) cb(false) end,
      }
    end

    it("does nothing when enable is false", function()
      mock_install(true)
      lsp.setup({ enable = false, cmd = { "surrealql-language-server" } })
      local ok, _ = pcall(vim.api.nvim_get_autocmds, { group = "surrealql_lsp" })
      assert.is_false(ok)
    end)

    it("creates a FileType autocmd when binary is installed", function()
      mock_install(true)
      lsp.setup({ enable = true, cmd = { "surrealql-language-server" } })
      local autocmds = vim.api.nvim_get_autocmds({ group = "surrealql_lsp", event = "FileType" })
      assert.equals(1, #autocmds)
      assert.equals("surrealql", autocmds[1].pattern)
    end)

    it("replaces a previous autocmd group on repeated setup calls", function()
      mock_install(true)
      lsp.setup({ enable = true, cmd = { "surrealql-language-server" } })
      lsp.setup({ enable = true, cmd = { "surrealql-language-server" } })
      local autocmds = vim.api.nvim_get_autocmds({ group = "surrealql_lsp", event = "FileType" })
      assert.equals(1, #autocmds)
    end)

    it("triggers install and registers autocmd when auto_install = true and binary is missing", function()
      local installed_cb = nil
      package.loaded["surrealql.install"] = {
        is_installed = function() return false, nil end,
        install = function(cb) installed_cb = cb end,
      }

      lsp.setup({ enable = true, auto_install = true, cmd = { "surrealql-language-server" } })
      assert.is_nil(vim.api.nvim_get_autocmds and (function()
        local ok, cmds = pcall(vim.api.nvim_get_autocmds, { group = "surrealql_lsp" })
        return ok and cmds[1] or nil
      end)())

      installed_cb(true, "/managed/bin/surrealql-language-server")
      local autocmds = vim.api.nvim_get_autocmds({ group = "surrealql_lsp", event = "FileType" })
      assert.equals(1, #autocmds)
    end)

    it("emits a warning when binary is missing and auto_install is false", function()
      package.loaded["surrealql.install"] = {
        is_installed = function() return false, nil end,
      }
      local warned = false
      local orig = vim.notify
      vim.notify = function(_, level)
        if level == vim.log.levels.WARN then warned = true end
      end
      lsp.setup({ enable = true, auto_install = false, cmd = { "surrealql-language-server" } })
      vim.notify = orig
      assert.is_true(warned)
    end)
  end)

  describe("start", function()
    it("calls vim.lsp.start with the correct name and cmd", function()
      local captured = nil
      local orig = vim.lsp.start
      vim.lsp.start = function(cfg) captured = cfg end

      lsp.start({ cmd = { "surrealql-language-server" } })

      vim.lsp.start = orig
      assert.is_not_nil(captured)
      assert.equals("surrealql", captured.name)
      assert.same({ "surrealql-language-server" }, captured.cmd)
    end)

    it("passes on_attach and capabilities through", function()
      local captured = nil
      local orig = vim.lsp.start
      vim.lsp.start = function(cfg) captured = cfg end

      local on_attach = function() end
      local caps = { textDocument = {} }
      lsp.start({ cmd = { "surrealql-language-server" }, on_attach = on_attach, capabilities = caps })

      vim.lsp.start = orig
      assert.equals(on_attach, captured.on_attach)
      assert.equals(caps, captured.capabilities)
    end)

    it("includes surrealql in filetypes", function()
      local captured = nil
      local orig = vim.lsp.start
      vim.lsp.start = function(cfg) captured = cfg end

      lsp.start({ cmd = { "surrealql-language-server" } })

      vim.lsp.start = orig
      assert.truthy(vim.tbl_contains(captured.filetypes, "surrealql"))
    end)
  end)

  describe("defaults", function()
    it("lsp is disabled by default", function()
      assert.is_false(defaults.enable)
    end)

    it("default cmd is surrealql-language-server", function()
      assert.same({ "surrealql-language-server" }, defaults.cmd)
    end)
  end)
end)
