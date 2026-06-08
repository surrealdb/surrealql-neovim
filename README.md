# surrealql-neovim

Neovim plugin for [SurrealQL](https://surrealdb.com/docs/surrealql), powered by the official [tree-sitter grammar](https://github.com/surrealdb/surrealql-tree-sitter).

## Features

- Filetype detection for `.surql` and `.surrealql` files
- Syntax highlighting via tree-sitter
- Embedded JavaScript highlighting inside `FUNCTION() { ... }` scripting bodies
- Embedded SurrealQL highlighting inside `surql`...`` tagged templates in JavaScript/TypeScript
- Smart indentation for blocks, objects, arrays, and control flow
- Code folding for blocks, objects, arrays, and statements
- Scope tracking for `LET` variables, closure params, and function definitions
- `commentstring` set to `-- %s` for `gc`/`gcc`
- LSP integration via [surrealql-language-server](https://github.com/surrealdb/surrealql-language-server)

## Requirements

- Neovim >= 0.9.0
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch — the rewrite. The legacy `master` branch is no longer supported.)
- [`tree-sitter` CLI](https://tree-sitter.github.io/tree-sitter/cli/) on `$PATH` (used by nvim-treesitter to build the parser)

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
    revision = "eedb78175fd2b6a5a690473c7e0ac22664d7cd01",
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
    cmd = { "surreal-language-server" },
    on_attach = nil,
    capabilities = nil,
  },
})
```

## Enabling tree-sitter features

After `:TSInstall surrealql`, enable features via Neovim's native tree-sitter API:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "surrealql",
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
  end,
})
```

Requires nvim-treesitter `main` branch (the rewrite). The legacy `master` branch is no longer supported.

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
    cmd = { "surreal-language-server" },
    on_attach = function(client, bufnr)
      -- your keymaps here
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  },
})
```

Prebuilt binaries are available for Linux (x86_64, arm64), macOS (Apple Silicon), and Windows (x86_64). macOS Intel falls back to `cargo install surrealql-language-server` automatically if Rust is available.

The server provides diagnostics, hover, completions, go-to-definition, references, rename, code actions, signature help, and call hierarchy.

## SurrealQL in JavaScript/TypeScript

The surrealdb JavaScript/TypeScript SDK lets you write queries as tagged
template literals. This plugin highlights their contents as SurrealQL:

```ts
const result = await db.query(surql`
  SELECT name, age FROM user WHERE age > 18
`);
```

Both `surql` and `surrealql` tags are recognized, whether called directly
(`surql`...``) or as a member (`db.surql`...``), in `.ts`, `.tsx`, `.js`, and
`.jsx` files.

This requires the host `typescript` / `tsx` / `javascript` parsers to be
installed (`:TSInstall typescript tsx javascript`). The injection queries use
the `; extends` modeline, so they add to — rather than replace — any
injections you already have.

## Grammar

Parser maintained at [surrealdb/surrealql-tree-sitter](https://github.com/surrealdb/surrealql-tree-sitter), targeting SurrealDB v3+.
