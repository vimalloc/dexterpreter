; CESK state machine
;   control: a sequence of statements (stmts)
;   environment: frame pointer to this state machine (fp)
;   store: map of addr->values (store)
;   continuation: a seq of frames denoting procedure return contexts and
;                 exception handlers for this machine (kont)
(struct state {stmts fp store kont})


; invoke-{virtual,super,direct,static,interface} {v1, ...} method-to-call
(define-match-expander invoke
  (lambda stx
    (syntax-case stx ()
      ; invoke-virtual
      ; (invoke-virtual {v3 v0 v1 v2} method v0-type [v1-type] v2-type
      ;  => invoke virtual method with params v0..2, v3 is 'this'
      [(invoke-virtual {,this . ,params} ,meth . ,types) stx]
      [(invoke-super {})]))
