#lang scheme

;Here are the helper functions to generate a list of number which taking the input from binary and output a list of numbers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (listofbyte)
  (local ((define item (read-byte)))
    (if (eof-object? item)
        empty
        (cons item (listofbyte)))))

(define (relist alon)
  (cond
    [(empty? alon) empty]
    [else (cons (cons (first alon)
                      (cons (second alon)
                            (cons (third alon)
                                  (cons (fourth alon) empty))))
                (relist (rest (rest (rest (rest alon))))))]))

(define (byte-word alon)
  (local
    [(define word (bitwise-ior (arithmetic-shift (first alon) 24)
                               (arithmetic-shift (second alon) 16)
                               (arithmetic-shift (third alon) 8)
                               (fourth alon)))]
    word))

(define (input)
  (local
    [(define (helper lolon)
       (cond
         [(empty? lolon) empty]
         [else (cons (byte-word (first lolon))(helper (rest lolon)))]))]
    (helper (relist (listofbyte)))))

(define item (input))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;here are some helper function that convert some decimal numbers into some string of hexadecimal number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (hexadecimal num)
  (local
    [(define (hexadecimal-digit-list n)
       (cond
         [(zero? n) empty]
         [(> n 16)(cons (hexnum (remainder n 16))(hexadecimal-digit-list (quotient n 16)))]
         [(equal? n 16)(list "0" "1")]
         [else (cons (hexnum n) empty)]))
     (define (helper alon)
       (local
         [(define (append lon accum)
            (cond
              [(empty? lon) accum]
              [else (append (rest lon)(string-append accum (first lon)))]))]
         (append alon "")))]
    (cond
      [(zero? num) 0]
      [else (helper (reverse (hexadecimal-digit-list num)))])))

(define (hexnum num)
  (cond
    [(not (integer? num)) false]
    [(and (>= num 0)(<= num 9)) (number->string num)]
    [(equal? num 10) "a"]
    [(equal? num 11) "b"]
    [(equal? num 12) "c"]
    [(equal? num 13) "d"]
    [(equal? num 14) "e"]
    [(equal? num 15) "f"]))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;to print merl file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define cookie (bitwise-ior (arithmetic-shift 16 24)
                            (arithmetic-shift 0 16)
                            (arithmetic-shift 0 8)
                            (arithmetic-shift 2 0)))

(define (header lon)
  (cond
    [(empty? lon) empty]
    [(equal? (first lon) cookie)
     (printf "cookie   10000002\nlength         ~a\nclen           ~a\n"
             (hexadecimal (second lon))(hexadecimal (third lon)))
     (set! item (rest (rest (rest item))))]))
(void (header item))

(define (char-8 str)
  (cond
    [(equal? 8 (string-length str)) str]
    [else (char-8 (string-append "0" str))]))

(define (body alon)
  (local
    [(define (help1 lon accum)
       (cond
         [(empty? lon) empty]
         [(or (equal? 1 (first lon))(equal? 5 (first lon))(equal? 17 (first lon))) empty]
         [else (printf "~a        ~a\n"(char-8 (hexadecimal accum))(hexadecimal (first lon)))
               (set! item (rest item))
               (help1 (rest lon) (+ 4 accum))]))]
    (help1 alon 12)))
(void (body item))

(define (ESR alon)
  (printf "ESR            ~a " (hexadecimal (second alon)))
  (set! item (rest (rest item)))
  (local
    [(define (helper accum lon)
       (cond
         [(zero? accum)(printf "\n")]
         [else (write-byte (first lon))
               (set! item (rest item))
               (helper (sub1 accum)(rest lon))]))]
    (helper (first item)(rest item))
    (set! item (rest item))
    ))

(define (ESD alon)
  (printf "ESD            ~a " (hexadecimal (second alon)))
  (set! item (rest (rest item)))
  (local
    [(define (helper accum lon)
       (cond
         [(zero? accum)(printf "\n")]
         [else (write-byte (first lon))
               (set! item (rest item))
               (helper (sub1 accum)(rest lon))]))]
    (helper (first item)(rest item))
    (set! item (rest item))
    ))

(define (table alon)
  (cond
    [(empty? alon) empty]
    [(equal? 1 (first alon))(printf "REL            ~a\n" (hexadecimal (second alon)))
                            (set! item (rest (rest item)))
                            (table (rest (rest alon)))]
    [(equal? 5 (first alon))(ESD alon)
                            (table item)]
    [(equal? 17 (first alon))(ESR alon)
                             (table item)]))
(void (table item))
