; CESK state machine
;   control: a sequence of statements (stmts)
;   environment: frame pointer to this state machine (fp)
;   store: map of addr->values (store)
;   continuation: a seq of frames denoting procedure return contexts and
;                 exception handlers for this machine (kont)
(struct state {stmts fp store kont})

; class-def ::= class class-name extends class-name
;               { field-def ... method-def ... }
; attrs: class_def_item
;   access_flags, superclass_idx, interfaces_off, source_file_idx,
;   annotation_off, class_data_off, static_values_off
(struct class-def { fields methods name super attrs })

; field-def ::= var field-name ;
; method-def ::= def method-name($name, ..., $name) { body }

