; Indentation hints for the nvim-treesitter `indent` module.
; (Core Neovim's built-in indent ignores this file; nvim-treesitter consumes it.)
;
; Container delimiters in this grammar:
;   Block / Object / ObjectType / Set / Destructure  -> named  BraceOpen / BraceClose  ({ })
;   Array                                            -> anonymous  "[" "]"
;   SubQuery / ArgumentList                          -> anonymous  "(" ")"

; ── Open a new indent level on every container ───────────────────────────────
[
  (Block)        ; { stmt; stmt; }  — function/closure bodies, IF branches, FOR bodies
  (Object)       ; { key: value }
  (ObjectType)   ; { field: type } in TYPE clauses
  (Set)          ; set literal
  (Destructure)  ; { a, b } idiom destructuring
  (Array)        ; [ a, b ]
  (SubQuery)     ; ( statement )
  (ArgumentList) ; function call args ( ... )
] @indent.begin

; ── Close the indent level on the matching closing delimiter ─────────────────
(Block (BraceClose) @indent.end)
(Object (BraceClose) @indent.end)
(ObjectType (BraceClose) @indent.end)
(Set (BraceClose) @indent.end)
(Destructure (BraceClose) @indent.end)
(Array "]" @indent.end)
(SubQuery ")" @indent.end)
(ArgumentList ")" @indent.end)

; ── Legacy IF … THEN … ELSE … END statement ──────────────────────────────────
; Keywords are the generic (Keyword) node, so branch/end are matched by text.
; (Keyword text may be upper- or lower-case → Vim-regex `\c`, not PCRE `(?i)`.)
(IfElseStatement
  (Legacy
    (Keyword) @indent.branch
    (#match? @indent.branch "\\c^else$")))

(IfElseStatement
  (Legacy
    (Keyword) @indent.end @indent.dedent
    (#match? @indent.end "\\c^end$")))
