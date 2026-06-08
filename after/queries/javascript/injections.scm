; extends

; Highlight SurrealQL inside surql`...` / surrealql`...` tagged template
; literals (e.g. the surrealdb JavaScript/TypeScript SDK). #offset! trims the
; surrounding backticks from the injected region.
((call_expression
   function: (identifier) @_tag
   arguments: (template_string) @injection.content)
 (#any-of? @_tag "surql" "surrealql")
 (#set! injection.language "surrealql")
 (#offset! @injection.content 0 1 0 -1))

; member-expression tag, e.g. db.surql`...`
((call_expression
   function: (member_expression
     property: (property_identifier) @_tag)
   arguments: (template_string) @injection.content)
 (#any-of? @_tag "surql" "surrealql")
 (#set! injection.language "surrealql")
 (#offset! @injection.content 0 1 0 -1))
