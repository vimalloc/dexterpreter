#lang racket

; CESK state machine
;   control: a sequence of statements (stmts)
;   environment: frame pointer to this state machine (fp)
;   store: map of addr->values (store)
;   continuation: a seq of frames denoting procedure return contexts and
;                 exception handlers for this machine (kont)
(struct state {stmts fp store kont})

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

; ρ : env = symbol -> addr
; σ : store = addr -> value
; value = integer + boolean + clo + cont
; clo ::= (clo <lam> <env>)
; κ : kont ::= (letk <var> <exp> <env> <kont>)
;           |  halt
; cont ::= (cont <kont>)
; addr = a set of unique addresses;
;        for this machine, symbols work;
;        gensym can create fresh addresses

; lookup the value of the framepointer
(define (lookup σ fp val)
  (hash-ref σ fp))

; extend environment and store with one or more values
(define (extend* σ ρ addrs vals)
  (match `(,addrs ,vals)
    [`((,addr . ,addrs) (,val . ,vals))
     (define $addr (gensym '$addr))
     (hash-set! σ $addr val)
     (extend* (hash-set ρ addr $addr) addrs vals)]
    [else ρ]))

; Apply continuation
(define (apply-kont κ value σ)
  (match κ
    ; if this is the end, not sure what to return
    ['(halt) '()]
    ; otherwise, we need to get our new state
    [`(,f ,stmts ,fp ,kaddr)
      (let ([σ* (extend* σ ρ fp (lookup σ fp value))])
          (state stmts σ* fp kaddr))]
))
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
