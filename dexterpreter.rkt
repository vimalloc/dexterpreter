#lang racket

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


(define-match-expander return
  (lambda stx
    (syntax-case stx ()
      ; return-void
      ; (return-void )
      ; => Return without a return value
      [`(return-void )        stx]
      ; return
      ; (return vx)
      ; => Return with vx return value
      [`(return ,vx)          stx]
      ; return-wide
      ; (return-wide vx)
      ; => Return with double/long result in vx,vx+1.
      [`(return-wide ,vx)     stx]
      ; return-object
      ; (return-object vx)
      ; => Return with vx object reference value
      [`(return-object ,vx)   stx])))


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
; conditions/branches
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


; vim: tabstop=2 shiftwidth=2 softtabstop=2
