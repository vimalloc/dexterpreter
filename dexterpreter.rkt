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
      [`(invoke-virtual {,this . ,params} ,meth . ,types) stx]
      ; invoke-super
      ; (invoke-super {v1 v2} method v2-type
      ;  => invoke the method from the super class with arguments v1 and v2
      [`(invoke-super {,args} ,meth . ,types) stx]
      ; invoke-direct {v0} method
      [`(invoke-direct {,this} ,meth) stx])))

; Opcodes we care about (in order):
; http://pallergabor.uw.hu/androidblog/dalvik_opcodes.html

; move
; return
; const
; monitor
; switch
; instance-of
; array-length
; new-array
; throw
; goto
; switch
; compare
; conditions
; array get
; array put
; instance get
; instance put
; static get
; static put
; invoke
; conversion
; arithmetic operations
; arithmetic and store
; *-quick
