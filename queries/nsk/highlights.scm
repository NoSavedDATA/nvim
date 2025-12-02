;; functions
(function_definition
  name: (identifier) @function)

;; classes
(class_definition
  name: (identifier) @type)

;; parameters
(parameter
  type: (_) @type)

;; types
(type) @type
(list_type "<" @punctuation.bracket ">" @punctuation.bracket)

;; function calls
(nameable
  (identifier) @function.call
  "(")

;; operators
(binary_expression
  operator: (_) @operator)

;; literals
(string) @string
(number) @number

;; comments
(comment) @comment

;; variables (catch-all)
(identifier) @variable

