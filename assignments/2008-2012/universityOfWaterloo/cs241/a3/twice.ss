#lang scheme

(define (copyinput)
  (local
    [(define alon empty)
     (define (helper)
       (let ((i (read)))
         (cond
           [(eof-object? i) empty]
           [#t (helper)
               (set! alon (cons i alon))])))
     (define (printnum list)
       (cond
         [(empty? (rest list)) (display (first list))
                               (display "\n")]
         [#t (display (first list))
             (display "\n")
             (printnum (rest list))]))]
    (helper)
    (printnum alon)
    (printnum alon)))

(void (copyinput))

