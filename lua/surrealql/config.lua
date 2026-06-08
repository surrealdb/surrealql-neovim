local M = {}

M.defaults = {
  treesitter = {
    enable = true,
    url = "https://github.com/surrealdb/surrealql-tree-sitter",
    branch = "master",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = {
    commentstring = "-- %s",
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
  lsp = {
    enable = false,
    auto_install = true,
    cmd = { "surrealql-language-server" },
    on_attach = nil,
    capabilities = nil,
  },
}

return M
