; Locals / scopes for SurrealQL
; Used by nvim-treesitter for incremental selection and scope-aware navigation.

; ----------------------------------------------------------------------------
; Scopes
; ----------------------------------------------------------------------------
; A `Block` is the body of a function, a closure, an IF branch and a FOR loop.
; `ForStatement` and `IfElseStatement` are scopes themselves so their bound
; variables (the loop var, branch-local bindings) stay local to them.
[
  (Block)
  (ForStatement)
  (IfElseStatement)
] @local.scope

; ----------------------------------------------------------------------------
; Definitions
; ----------------------------------------------------------------------------

; LET $x = ...            ->  (LetStatement (ParamDefinition (VariableName)))
(LetStatement
  (ParamDefinition
    (VariableName) @local.definition.var))

; FOR $row IN ...         ->  loop variable (bare VariableName after FOR)
(ForStatement
  (Keyword) .
  (VariableName) @local.definition.var)

; DEFINE FUNCTION fn::name($p: T) -> T { ... }
;   - the custom function name
(DefineStatement
  (FunctionName) @local.definition.function)

;   - its parameters
(DefineStatement
  (ParamDefinition
    (VariableName) @local.definition.parameter))

; Closure parameters       ->  |$x: int, $y| { ... }
(Closure
  (ParamDefinition
    (VariableName) @local.definition.parameter))

; ----------------------------------------------------------------------------
; References
; ----------------------------------------------------------------------------

; every $param use
(VariableName) @local.reference

; custom function calls -> match a DEFINE FUNCTION definition
((FunctionCall
  (FunctionName) @local.reference)
  (#match? @local.reference "^fn::"))
