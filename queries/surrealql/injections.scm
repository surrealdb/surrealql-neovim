; Language injections for SurrealQL

; Inject JavaScript into scripting function bodies:
;   DEFINE FUNCTION fn::f() { RETURN function() { return 1; }; };
; In the PascalCase grammar a JS scripting function is
;   FunctionJs -> FunctionName ArgumentList JavaScriptBlock
; where JavaScriptBlock is the raw JS body (a leaf node whose text is the
; `{ ... }` block). Capture it as the injected JavaScript content.
((JavaScriptBlock) @injection.content
  (#set! injection.language "javascript"))
