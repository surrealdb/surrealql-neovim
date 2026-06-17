; Folds for SurrealQL (PascalCase grammar)
; Fold multi-line constructs: blocks, collection literals, subqueries,
; and the larger statement nodes.

; Container / value constructs
[
  (Block)
  (Object)
  (Array)
  (Set)
  (SubQuery)
  (Closure)
] @fold

; Statements
[
  (SelectStatement)
  (CreateStatement)
  (InsertStatement)
  (UpdateStatement)
  (UpsertStatement)
  (DeleteStatement)
  (RelateStatement)
  (DefineStatement)
  (AlterStatement)
  (RemoveStatement)
  (RebuildStatement)
  (LetStatement)
  (ReturnStatement)
  (IfElseStatement)
  (ForStatement)
  (InfoForStatement)
  (LiveSelectStatement)
] @fold
