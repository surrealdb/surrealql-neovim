[
  (block)
  (object)
  (array)
  (closure_body)
  (argument_list)
] @indent.begin

(block "}" @indent.end)
(object "}" @indent.end)
(array "]" @indent.end)
(argument_list ")" @indent.end)

(if_statement
  (keyword_then) @indent.begin)

(if_statement
  (keyword_end) @indent.end @indent.dedent)

(if_then_result) @indent.begin

(else_clause) @indent.begin

(else_then_clause
  (keyword_end) @indent.end @indent.dedent)

(for_statement
  (block) @indent.begin)

[
  (block "{" @indent.align)
  (object "{" @indent.align)
  (array "[" @indent.align)
  (argument_list "(" @indent.align)
] @indent.align
(#set! indent.open_delimiter "{")
(#set! indent.close_delimiter "}")
