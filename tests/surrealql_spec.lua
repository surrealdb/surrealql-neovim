describe("surrealql", function()
  local surrealql
  local defaults

  before_each(function()
    package.loaded["surrealql"] = nil
    package.loaded["surrealql.config"] = nil
    package.loaded["nvim-treesitter.parsers"] = nil
    surrealql = require("surrealql")
    defaults = require("surrealql.config").defaults
  end)

  describe("get_config", function()
    it("returns defaults before setup is called", function()
      assert.same(defaults, surrealql.get_config())
    end)
  end)

  describe("setup", function()
    it("merges user options over defaults", function()
      surrealql.setup({ filetype = { tabstop = 4 } })
      local cfg = surrealql.get_config()
      assert.equals(4, cfg.filetype.tabstop)
      assert.equals(2, cfg.filetype.shiftwidth)
      assert.equals(defaults.treesitter.revision, cfg.treesitter.revision)
    end)

    it("stores config accessible via get_config", function()
      surrealql.setup({ filetype = { commentstring = "// %s" } })
      assert.equals("// %s", surrealql.get_config().filetype.commentstring)
    end)

    it("skips parser registration when treesitter.enable is false", function()
      local called = false
      local orig = surrealql._register_parser
      surrealql._register_parser = function() called = true end
      surrealql.setup({ treesitter = { enable = false } })
      surrealql._register_parser = orig
      assert.is_false(called)
    end)
  end)

  describe("_register_parser", function()
    it("does nothing when nvim-treesitter is absent", function()
      package.loaded["nvim-treesitter.parsers"] = nil
      assert.has_no.errors(function()
        surrealql._register_parser(defaults.treesitter)
      end)
    end)

    it("registers the parser when treesitter is present", function()
      local parsers = {}
      package.loaded["nvim-treesitter.parsers"] = parsers

      surrealql._register_parser(defaults.treesitter)

      assert.is_not_nil(parsers.surrealql)
      assert.equals(defaults.treesitter.url, parsers.surrealql.install_info.url)
      assert.equals(defaults.treesitter.revision, parsers.surrealql.install_info.revision)
    end)

    it("does not overwrite an existing registration", function()
      local original = { install_info = { url = "original" } }
      local parsers = { surrealql = original }
      package.loaded["nvim-treesitter.parsers"] = parsers

      surrealql._register_parser(defaults.treesitter)

      assert.equals("original", parsers.surrealql.install_info.url)
    end)
  end)
end)
