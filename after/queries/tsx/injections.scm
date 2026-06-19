; extends

; Highlight SurrealQL inside surql`...` / surrealql`...` tagged template
; literals (e.g. the surrealdb JavaScript/TypeScript SDK). #offset! trims the
; surrounding backticks from the injected region. injection.include-children is
; required because a template_string wraps its text in a (string_fragment)
; child; without it the host masks that child out and the injected range is
; empty, so no highlighting is applied.
((call_expression
   function: (identifier) @_tag
   arguments: (template_string) @injection.content)
 (#any-of? @_tag "surql" "surrealql")
 (#set! injection.language "surrealql")
 (#set! injection.include-children)
 (#offset! @injection.content 0 1 0 -1))

; member-expression tag, e.g. db.surql`...`
((call_expression
   function: (member_expression
     property: (property_identifier) @_tag)
   arguments: (template_string) @injection.content)
 (#any-of? @_tag "surql" "surrealql")
 (#set! injection.language "surrealql")
 (#set! injection.include-children)
 (#offset! @injection.content 0 1 0 -1))
