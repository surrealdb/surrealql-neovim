; SurrealQL highlights (PascalCase grammar)
;
; nvim 0.12 precedence/predicate notes:
;   - When several patterns capture the same node, the one that appears LATER
;     in this file wins. So generic catch-alls go FIRST and specific overrides
;     go LAST.
;   - #match? uses Vim regex: use \c for case-insensitivity, NOT (?i).
;   - #eq? / #any-of? are case-sensitive (enumerate both cases if used).

; ---------------------------------------------------------------------------
; Comments
; ---------------------------------------------------------------------------
(Comment) @comment @spell
(BlockComment) @comment @spell

; ---------------------------------------------------------------------------
; Strings / regex
; ---------------------------------------------------------------------------
(String) @string
(FormatString) @string
(Regex) @string.regexp

; embedded JavaScript body of FUNCTION() { ... }
(JavaScriptBlock) @embedded

; ---------------------------------------------------------------------------
; Numbers
; ---------------------------------------------------------------------------
(Number (Int) @number)
(Number (Float) @number.float)
(Number (Decimal) @number.float)
(VersionNumber) @number

; datetimes collapse to (String); durations are their own node
(Duration) @string.special
(DurationValue) @string.special

; ---------------------------------------------------------------------------
; Literals / constants
; ---------------------------------------------------------------------------
(Bool) @boolean
(None) @constant.builtin
(Any) @character.special

; ---------------------------------------------------------------------------
; Variables / parameters  ($name and binding sites)
; ---------------------------------------------------------------------------
(VariableName) @variable.parameter
(ParamDefinition (VariableName) @variable.parameter)

; ---------------------------------------------------------------------------
; Types
; ---------------------------------------------------------------------------
(TypeName) @type

; ---------------------------------------------------------------------------
; Identifiers / fields / properties
; ---------------------------------------------------------------------------
(Ident) @variable.member
(Idiom (Ident) @variable.member)
(KeyName) @property

; record ids:  table : id
(RecordTbIdent) @type
(RecordIdIdent) @string.special

; ---------------------------------------------------------------------------
; Functions  (custom fn::...  -> @function ; everything else -> @function.builtin)
; ---------------------------------------------------------------------------
((FunctionName) @function.builtin
  (#not-match? @function.builtin "^fn::"))
((FunctionName) @function
  (#match? @function "^fn::"))

; ---------------------------------------------------------------------------
; Punctuation
; ---------------------------------------------------------------------------
[
  (BraceOpen)
  (BraceClose)
] @punctuation.bracket

[
  "(" ")"
  "[" "]"
  "<|" "|>"
] @punctuation.bracket

(Colon) @punctuation.delimiter
(Pipe) @punctuation.delimiter
[
  ","
  ";"
  "."
  "|"
] @punctuation.delimiter

[
  "@"
  "@@"
] @punctuation.special
(At) @punctuation.special

; ---------------------------------------------------------------------------
; Operators
; ---------------------------------------------------------------------------
(Operator) @operator
(RangeOp) @operator

; graph arrows  -> <- <->
[
  (LookupLeft)
  (LookupRight)
  (LookupBoth)
] @operator

; symbolic / unicode operators that may surface as anonymous tokens
[
  "!=" "!~"
  "&&" "||"
  "==" "="
  "<" "<=" "<~"
  ">" ">="
  "+" "+=" "-" "-="
  "*" "**" "*=" "*~"
  "??" "?:" "?="
  "~"
  "×" "÷"
  "∈" "∉" "∋" "∌"
  "⊂" "⊃" "⊄" "⊅" "⊆" "⊇"
] @operator

; word operators are (Operator) nodes (AND, OR, CONTAINS, ...): recolor them.
; (placed AFTER (Operator) @operator so this override wins)
((Operator) @keyword.operator
  (#match? @keyword.operator "\\c^(and|or|not|is|in|inside|outside|intersects|contains|containsall|containsany|containsnone|containsnot|allinside|anyinside|noneinside)$"))

; ---------------------------------------------------------------------------
; Keywords
;
; There is a single generic (Keyword) node; roles are selected by text.
; Generic catch-all FIRST, role overrides LAST (later wins in nvim).
; ---------------------------------------------------------------------------
(Keyword) @keyword

; conditionals: IF ELSE THEN END WHEN
((Keyword) @keyword.conditional
  (#match? @keyword.conditional "\\c^(if|else|then|end|when)$"))

; loops / iteration: FOR BREAK CONTINUE
((Keyword) @keyword.repeat
  (#match? @keyword.repeat "\\c^(for|break|continue)$"))

; return / throw
((Keyword) @keyword.return
  (#match? @keyword.return "\\c^(return|throw)$"))

; transaction control: BEGIN COMMIT CANCEL TRANSACTION
((Keyword) @keyword.control
  (#match? @keyword.control "\\c^(begin|commit|cancel|transaction)$"))

; word operators that are tokenized as keywords (IN, CONTAINS, ...)
((Keyword) @keyword.operator
  (#match? @keyword.operator "\\c^(and|or|not|is|in|inside|outside|intersects|contains|containsall|containsany|containsnone|containsnot|allinside|anyinside|noneinside)$"))

; modifiers / qualifiers
((Keyword) @keyword.modifier
  (#match? @keyword.modifier "\\c^(type|flexible|readonly|schemafull|schemaless|drop|permissions|default|assert|comment|changefeed|unique|search|relation|normal|computed|reference)$"))
