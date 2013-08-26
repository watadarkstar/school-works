;; derivationprinter.ss revision 081019.0 ;;;;;
#lang scheme
;; skip num lines
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
    (set! listofstring (append listofstring (cons (list->string lineList) empty)))
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

(define listofstring empty)

;; skip the grammar and print the derivation with extra whitespace
;; removed 

;; (list (list term)(list term)(list expr)) (list (list expr)) (list (list expr)(list -)(list term))
(define (substitute llos T NT)
  (local
    [(define (helper llos T NT accum)
       (cond
         [(equal? (first llos) T)(append accum NT (rest llos))]
         [else (helper (rest llos) T NT (append accum (list (first llos))))]))]
    (helper llos T NT empty)))

(define (evaluate los)
  (local
    [(define (helper los1 accum)
       (cond
         [(empty? los1) accum]
         [(equal? (first los1) "S BOF expr EOF")(helper (rest los)(append accum (list (list #\e#\x#\p#\r))))]
         [(equal? (first los1) "expr expr - term")
          (helper (rest los1)(substitute accum (list #\e#\x#\p#\r)(list (list #\e#\x#\p#\r) "-"(list #\t#\e#\r#\m))))]
         [(equal? (first los1) "expr term")
          (helper (rest los1)(substitute accum (list #\e#\x#\p#\r)(list (list #\t#\e#\r#\m))))]
         [(equal? (first los1) "term id")
          (helper (rest los1)(substitute accum (list #\t#\e#\r#\m)(list "id")))]
         [(equal? (first los1) "term ( expr )")
          (helper (rest los1)(substitute accum (list #\t#\e#\r#\m)(list "("(list #\e#\x#\p#\r)")")))]))
     (define (convert lolist num posneg)
       (cond
         [(empty? lolist) num]
         [(and (equal? (first lolist)"-")(equal? (second lolist)"("))(convert (rest (rest lolist)) num (add1 posneg))]
         [(and (even? posneg)(equal? (first lolist)"-")(equal? (second lolist)"id"))(convert (rest (rest lolist))(- num 42) posneg)]
         [(and (odd? posneg)(equal? (first lolist)"-")(equal? (second lolist)"id"))(convert (rest (rest lolist))(+ num 42) posneg)]
         [(and (odd? posneg)(equal? (first lolist) "id"))(convert (rest lolist)(- num 42) posneg)]
         [(and (not (equal? posneg 0))(equal? (first lolist)")"))(convert (rest lolist) num (sub1 posneg))]
         [(equal? (first lolist)"id")(convert (rest lolist) (+ num 42) posneg)]
         [else (convert (rest lolist) num posneg)]))]
    (convert (helper los empty) 0 0)))

(void (skip-grammar))
(void (print-derivation))
(evaluate listofstring)
