;; this file must be put at ~/.config/nvim/after/queries/cpp/highlights.scm
; extends

(function_declarator
    parameters: (parameter_list
      (parameter_declaration
        type: (qualified_identifier
          name: (type_identifier) @function.type))))

(function_declarator
    parameters: (parameter_list
      (parameter_declaration
        type: (type_identifier) @function.type)))

(function_declarator
    parameters: (parameter_list
      (parameter_declaration
        type: (qualified_identifier
          name: (template_type
            arguments: (template_argument_list
               (type_descriptor
                 type: (type_identifier) @function.type)))))))

(function_declarator
  (qualified_identifier
    scope: (namespace_identifier) @namespace))

(function_definition
  (qualified_identifier
    scope: (namespace_identifier) @namespace))

(class_specifier
  name: (type_identifier) @class.name)

(class_specifier
  (base_class_clause
    (type_identifier) @type.definition))

(namespace_definition
  name: (namespace_identifier) @namespace.identifier)

(qualified_identifier
  scope: (namespace_identifier)
  name: (type_identifier) @type)

(qualified_identifier
  scope: (namespace_identifier) @namespace
  name: (qualified_identifier))

(
  (function_definition
   declarator: (reference_declarator
    (function_declarator
     declarator: (operator_name) @operator)))
  (#set! "priority" 110)
)

(call_expression
  (template_function
    name: (identifier) @operator))

(call_expression
  (field_expression
    (field_expression
     field: (field_identifier) @operator)))

(break_statement) @keyword

