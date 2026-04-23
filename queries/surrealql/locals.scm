[
  (block)
  (closure_body)
  (if_statement)
  (for_statement)
] @local.scope

(expressions
  (keyword_let)
  (variable_name) @local.definition)

(closure_param
  (variable_name) @local.definition)

(variable_name) @local.reference

(define_function_statement
  (custom_function_name) @local.definition)

(function_call
  (custom_function_name) @local.reference)
