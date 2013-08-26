#lang scheme
;; p num lines
(define (skip-input-lines num) 
  (cond 
    [(> num 0) 
     (begin (read-line) (skip-input-lines (- num 1)))]
    [else #t]
    )
  )

;; read and skip lines
(define (read-and-skip-lines)
  (local ((define num (read))) 
         (read-line)            ; eat up the line after the number
         (skip-input-lines num)
         )
  )

;; skip the terminals
(define (skip-term)
  (read-and-skip-lines)
  )

;; skip the non-terminals
(define (skip-non-term)
  (read-and-skip-lines)
  )

;; skip the rules
(define (skip-rules)
  (read-and-skip-lines)
  )

;; skip the start symbol
(define (skip-start-nonterm)
  (read-line)
  )

;; skip the entire grammar by read from the input port
(define (skip-grammar)
  (skip-term)
  (skip-non-term)
  (skip-start-nonterm)
  (skip-rules)
  )

; trim the line at the beginning and print
(define (trim-and-print-line lineList)
  (if (char-whitespace? (car lineList))
    (trim-and-print-line (cdr lineList))
    (printf "~a~n" (list->string lineList))
    )
  )

;; print the derivation with extra whitespace removed
(define (print-derivation)
  (local ((define line (read-line)))
         (if (eof-object? line)
           #t
           (begin
             (trim-and-print-line (string->list line))
             (print-derivation)
             )
           )
         )
  )

;; skip the grammar and print the derivation with extra whitespace
;; removed 
(void (skip-grammar))
(void (print-derivation))

