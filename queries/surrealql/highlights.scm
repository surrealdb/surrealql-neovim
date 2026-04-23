(comment) @comment @spell

(string) @string
(prefixed_string) @string

(int) @number
(float) @number.float
(decimal) @number.float

(datetime) @string.special
(duration) @string.special

[
  (keyword_true)
  (keyword_false)
] @boolean

[
  (keyword_null)
  (keyword_none)
] @constant.builtin

(variable_name) @variable.parameter

(type_name) @type
(composite_type) @type

(function_call
  (builtin_function_name) @function.builtin)

(function_call
  (custom_function_name) @function)

(function_call
  (function_name) @function)

(scripting_function
  (keyword_function) @keyword.function)

(scripting_function
  (keyword_async) @keyword.coroutine)

(define_function_statement
  (keyword_function) @keyword.function)

(scripting_function
  (js_function_body) @embedded)

(binary_operator) @operator
(assignment_operator) @operator

[
  "="
  "=="
  "!="
  "!~"
  "<"
  "<="
  ">"
  ">="
  "+"
  "-"
  "*"
  "**"
  "/"
  "%"
  "&&"
  "||"
  "??"
  "?:"
  "?="
  "*="
  "*~"
  "<~"
  "+="
  "-="
  "->"
  "<-"
  "<->"
  "∈"
  "∉"
  "∋"
  "∌"
  "⊂"
  "⊃"
  "⊄"
  "⊅"
  "⊆"
  "⊇"
  "×"
  "÷"
] @operator

["{" "}"] @punctuation.bracket
["[" "]"] @punctuation.bracket
["(" ")"] @punctuation.bracket
["<|" "|>"] @punctuation.bracket

["," ";"] @punctuation.delimiter
[":" "::"] @punctuation.delimiter
[".." "." "?."] @punctuation.delimiter
["@" "@@"] @punctuation.special
["?" "!"] @punctuation.special
["|"] @punctuation.delimiter

[
  (keyword_if)
  (keyword_else)
  (keyword_then)
  (keyword_when)
  (keyword_end)
] @keyword.conditional

[
  (keyword_for)
  (keyword_break)
  (keyword_continue)
] @keyword.repeat

[
  (keyword_return)
  (keyword_throw)
] @keyword.return

[
  (keyword_begin)
  (keyword_commit)
  (keyword_cancel)
  (keyword_transaction)
] @keyword.control

[
  (keyword_and)
  (keyword_or)
  (keyword_not)
  (keyword_is)
  (keyword_in)
  (keyword_inside)
  (keyword_not_inside)
  (keyword_all_inside)
  (keyword_any_inside)
  (keyword_none_inside)
  (keyword_outside)
  (keyword_intersects)
  (keyword_contains)
  (keyword_contains_not)
  (keyword_contains_all)
  (keyword_contains_any)
  (keyword_contains_none)
] @keyword.operator

[
  (keyword_select)
  (keyword_insert)
  (keyword_update)
  (keyword_upsert)
  (keyword_delete)
  (keyword_create)
  (keyword_relate)
  (keyword_live)
] @keyword

[
  (keyword_from)
  (keyword_where)
  (keyword_order)
  (keyword_group)
  (keyword_limit)
  (keyword_split)
  (keyword_fetch)
  (keyword_start)
  (keyword_explain)
  (keyword_parallel)
  (keyword_timeout)
  (keyword_with)
  (keyword_index)
  (keyword_omit)
  (keyword_only)
  (keyword_value)
  (keyword_values)
  (keyword_into)
  (keyword_content)
  (keyword_merge)
  (keyword_patch)
  (keyword_replace)
  (keyword_set)
  (keyword_unset)
  (keyword_diff)
  (keyword_full)
  (keyword_by)
  (keyword_as)
  (keyword_let)
  (keyword_show)
  (keyword_changes)
  (keyword_since)
  (keyword_version)
] @keyword

[
  (keyword_define)
  (keyword_remove)
  (keyword_alter)
  (keyword_use)
  (keyword_overwrite)
  (keyword_if_exists)
] @keyword

[
  (keyword_namespace)
  (keyword_database)
  (keyword_table)
  (keyword_event)
  (keyword_field)
  (keyword_index)
  (keyword_analyzer)
  (keyword_token)
  (keyword_scope)
  (keyword_user)
  (keyword_param)
  (keyword_access)
  (keyword_sequence)
  (keyword_module)
  (keyword_api)
  (keyword_bucket)
  (keyword_config)
] @keyword

[
  (keyword_ns)
  (keyword_db)
  (keyword_info)
] @keyword

[
  (keyword_type)
  (keyword_flexible)
  (keyword_readonly)
  (keyword_schemafull)
  (keyword_schemaless)
  (keyword_drop)
  (keyword_permissions)
  (keyword_default)
  (keyword_assert)
  (keyword_comment)
  (keyword_changefeed)
  (keyword_unique)
  (keyword_search)
  (keyword_relation)
  (keyword_normal)
  (keyword_any)
  (keyword_computed)
  (keyword_reference)
] @keyword.modifier

[
  (keyword_on)
  (keyword_at)
  (keyword_to)
  (keyword_out)
  (keyword_before)
  (keyword_after)
  (keyword_for)
  (keyword_ignore)
  (keyword_cascade)
  (keyword_reject)
] @keyword

[
  (keyword_root)
  (keyword_roles)
  (keyword_session)
  (keyword_signin)
  (keyword_signup)
  (keyword_bearer)
  (keyword_jwt)
  (keyword_jwks)
  (keyword_authenticate)
] @keyword

[
  (keyword_grant)
  (keyword_revoke)
  (keyword_revoked)
  (keyword_purge)
  (keyword_expired)
  (keyword_batch)
] @keyword

[
  (keyword_eddsa)
  (keyword_es256)
  (keyword_es384)
  (keyword_es512)
  (keyword_ps256)
  (keyword_ps384)
  (keyword_ps512)
  (keyword_rs256)
  (keyword_rs384)
  (keyword_rs512)
  (keyword_hs256)
  (keyword_hs384)
  (keyword_hs512)
] @string.special

[
  (keyword_bm25)
  (keyword_euclidean)
  (keyword_cosine)
  (keyword_hamming)
  (keyword_jaccard)
  (keyword_manhattan)
  (keyword_minkowski)
  (keyword_pearson)
  (keyword_chebyshev)
] @string.special

[
  (keyword_end)
  (keyword_async)
  (keyword_all)
  (keyword_sequence)
  (keyword_reference)
  (keyword_computed)
  (keyword_return)
] @keyword

(reference_on_delete_clause
  (keyword_on) @keyword
  (keyword_delete) @keyword)

(reference_on_delete_clause
  [
    (keyword_ignore)
    (keyword_unset)
    (keyword_cascade)
    (keyword_reject)
  ] @keyword)

(reference_on_delete_clause
  (keyword_then) @keyword.conditional)

(assert_clause
  (keyword_assert) @keyword.modifier)

(access_statement
  [
    (keyword_grant)
    (keyword_show)
    (keyword_revoke)
    (keyword_purge)
  ] @keyword)

(define_sequence_statement
  (keyword_sequence) @keyword)
