describe("surrealql.config", function()
  local config

  before_each(function()
    package.loaded["surrealql.config"] = nil
    config = require("surrealql.config")
  end)

  it("exposes treesitter defaults", function()
    assert.is_true(config.defaults.treesitter.enable)
    assert.equals("https://github.com/surrealdb/surrealql-tree-sitter", config.defaults.treesitter.url)
    assert.equals("main", config.defaults.treesitter.branch)
    assert.same({ "src/parser.c", "src/scanner.c" }, config.defaults.treesitter.files)
  end)

  it("exposes filetype defaults", function()
    assert.equals("-- %s", config.defaults.filetype.commentstring)
    assert.equals(2, config.defaults.filetype.tabstop)
    assert.equals(2, config.defaults.filetype.shiftwidth)
    assert.is_true(config.defaults.filetype.expandtab)
  end)
end)
