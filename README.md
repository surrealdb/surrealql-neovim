# surrealql-neovim

Neovim plugin for [SurrealQL](https://surrealdb.com/docs/surrealql), powered by the official [tree-sitter grammar](https://github.com/surrealdb/surrealql-tree-sitter).

## Features

- Filetype detection for `.surql` and `.surrealql` files
- Syntax highlighting via tree-sitter
- Embedded JavaScript highlighting inside `FUNCTION() { ... }` scripting bodies
- Smart indentation for blocks, objects, arrays, and control flow
- Code folding for blocks, objects, arrays, and statements
- Scope tracking for `LET` variables, closure params, and function definitions
- `commentstring` set to `-- %s` for `gc`/`gcc`
- LSP integration via [surrealql-language-server](https://github.com/surrealdb/surrealql-language-server)

## Requirements

- Neovim >= 0.9.0
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- A C compiler (gcc or clang) for building the parser

## Installation

### lazy.nvim

```lua
{
  "surrealdb/surrealql-neovim",
  ft = { "surrealql" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
}
```

Then install the parser:

```vim
:TSInstall surrealql
```

### packer.nvim

```lua
use {
  "surrealdb/surrealql-neovim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("surrealql").setup()
  end,
}
```

## Configuration

All options are optional.

```lua
require("surrealql").setup({
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
})
```

## Enabling tree-sitter features

After `:TSInstall surrealql`, enable features in your nvim-treesitter config:

```lua
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  fold = { enable = true },
})
```

For folding, also set:

```lua
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
```

## Highlighted constructs

| Construct | Highlight group |
|-----------|----------------|
| `-- comment`, `/* */`, `#`, `//` | `@comment` |
| `'string'`, `"string"`, `r"raw"` | `@string` |
| `d'2024-01-01T00:00:00Z'` | `@string.special` |
| `1w2d3h` (duration) | `@string.special` |
| `42`, `3.14`, `1.5dec` | `@number`, `@number.float` |
| `$variable` | `@variable.parameter` |
| `math::abs()`, `array::len()` | `@function.builtin` |
| `fn::my_func()` | `@function` |
| `FUNCTION() { ... }` body | `@embedded` (JavaScript) |
| `string`, `option<int>`, `array<record>` | `@type` |
| `TRUE`, `FALSE` | `@boolean` |
| `NULL`, `NONE` | `@constant.builtin` |
| `AND`, `OR`, `NOT`, `CONTAINS*` | `@keyword.operator` |
| `IF`, `ELSE`, `THEN`, `END` | `@keyword.conditional` |
| `FOR`, `BREAK`, `CONTINUE` | `@keyword.repeat` |
| `RETURN`, `THROW` | `@keyword.return` |
| `BEGIN`, `COMMIT`, `CANCEL` | `@keyword.control` |
| All other keywords | `@keyword` |
| `=`, `!=`, `->`, `∈`, `⊂`, ... | `@operator` |

## LSP

The LSP integration uses the [surrealql-language-server](https://github.com/surrealdb/surrealql-language-server).

Enable it in your setup and the plugin will automatically download the correct prebuilt binary for your platform:

```lua
require("surrealql").setup({
  lsp = {
    enable = true,
  },
})
```

To download the binary manually at any time, run `:SurrealQLInstall`.

To disable auto-install and manage the binary yourself:

```lua
require("surrealql").setup({
  lsp = {
    enable = true,
    auto_install = false,
    cmd = { "surrealql-language-server" },
    on_attach = function(client, bufnr)
      -- your keymaps here
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  },
})
```

Prebuilt binaries are available for Linux (x86_64, arm64), macOS (Apple Silicon), and Windows (x86_64). macOS Intel falls back to `cargo install surrealql-language-server` automatically if Rust is available.

The server provides diagnostics, hover, completions, go-to-definition, references, rename, code actions, signature help, and call hierarchy.

## Grammar

Parser maintained at [surrealdb/surrealql-tree-sitter](https://github.com/surrealdb/surrealql-tree-sitter), targeting SurrealDB v3+.
