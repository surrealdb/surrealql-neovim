local M = {}

M.defaults = {
  treesitter = {
    enable = true,
    url = "https://github.com/surrealdb/surrealql-tree-sitter",
    branch = "main",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = {
    commentstring = "-- %s",
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
  },
}

return M
