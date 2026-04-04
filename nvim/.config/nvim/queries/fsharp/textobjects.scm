; F# function textobjects

; let bindings / top-level functions: `let add x y = ...`
((function_or_value_defn) @function.outer
  (#set! "kind" "function"))

((function_or_value_defn
  (function_declaration_left)
  "="
  (_) @function.inner)
  (#set! "kind" "function"))

; type members: `member _.Add x y = ...`
((member_defn) @function.outer
  (#set! "kind" "function"))

((member_defn
  (method_or_prop_defn
    .
    (_)
    .
    (_)
    .
    (_)
    .
    "="
    .
    (_) @function.inner))
  (#set! "kind" "function"))
