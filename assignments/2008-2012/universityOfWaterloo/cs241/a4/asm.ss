#lang scheme

;; Here is the main function provided, which uses the data definitions
;; and helper functions that follow. Sample tests are at the bottom of the file.

;; scan-func: (listof char) trans-table symbol (listof symbol) -> (listof token)

(define (scan-func str trans start final)
  (scan-acc (string->list str) trans start final empty empty))

;; Next we specify the data definitions for tokens and the various components
;; of an FSM.

(define-struct token (kind lexeme) #:transparent)

;; A token is a (make-token k l), where k is a symbol
;;  and l is (union (list char) int).

(define-struct transition (state charset next) #:transparent)

;; A transition table is a list of transitions.
;; A transition is a (make-transition s cs ns), where s and ns are symbols,
;;  and cs is a function char->boolean that tests whether the transition applies.

;; The sample FSM provided is defined by (asmtrlst, 'start, asmfinal).
;; Definitions of asmtrlst and asmfinal follow.

;; functions used in defining sample transition table

(define (one-to-nine? ch)
  (and (char<=? #\1 ch) (char<=? ch #\9)))

(define (hex-digit? ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\f))
   (and (char<=? #\A ch) (char<=? ch #\F))))

(define (chartest ch)
  (lambda (x) (char=? x ch)))

;; sample transition table

(define asmtrlst 
  (list
   (make-transition 'start char-whitespace? 'whitespace)
   (make-transition 'start char-alphabetic? 'id)
   (make-transition 'id char-alphabetic? 'id)
   (make-transition 'id char-numeric? 'id)
   (make-transition 'start one-to-nine? 'int)
   (make-transition 'int char-numeric? 'int)
   (make-transition 'start (chartest #\-) 'minus)
   (make-transition 'minus char-numeric? 'int)
   (make-transition 'start (chartest #\,) 'comma) 
   (make-transition 'start (chartest #\() 'lparen)
   (make-transition 'start (chartest #\)) 'rparen)
   (make-transition 'start (chartest #\$) 'dollar)
   (make-transition 'dollar char-numeric? 'register)
   (make-transition 'register char-numeric? 'register)
   (make-transition 'start (chartest #\0) 'zero)
   (make-transition 'zero (chartest #\x) 'zerox)
   (make-transition 'zero char-numeric? 'int)
   (make-transition 'zerox hex-digit? 'hexint)
   (make-transition 'hexint hex-digit? 'hexint)
   (make-transition 'id (chartest #\:) 'label)
   (make-transition 'start (chartest #\;) 'comment) 
   (make-transition 'comment (lambda (x) true) 'comment)
   (make-transition 'start (chartest #\.) 'dot)
   (make-transition 'dot (chartest #\w) 'dotw)
   (make-transition 'dotw (chartest #\o) 'dotwo)
   (make-transition 'dotwo (chartest #\r) 'dotwor)
   (make-transition 'dotwor (chartest #\d) 'dotword)
   ))

;; sample list of final states

(define asmfinal
  (list
   'register
   'int
   'id
   'label
   'comma
   'lparen
   'rparen
   'zero
   'hexint
   'comment
   'dotword
   'whitespace
   ))

;; scan-acc is the main workhorse of the lexer. It uses accumulative recursion
;; to run the FSM specified by (trans, state, final) on the list of characters cl.
;; acc accumulates the characters of the current token in reverse order, and
;; tacc accumulates the token list in reverse order.

;; scan-acc: (listof char) trans-table symbol (listof symbol) (listof char) (listof token) -> (listof token)

(define (scan-acc cl trans state final acc tacc)
  (cond
    [(empty? cl) 
     (if (member state final)
         (if (or (symbol=? state 'whitespace) (symbol=? state 'comment))
             (reverse tacc)
             (reverse (cons (finalize-token state (reverse acc)) tacc)))
         (error 'ERROR "unexpected end of string\n"))]
    [else
     (let ([trl (memf (lambda (x) (found-trans? state (first cl) x)) trans)])
       (cond
         [(and (boolean? trl) (member state final))
          (if (symbol=? state 'whitespace)
              (scan-acc cl trans 'start final empty tacc)
              (scan-acc cl trans 'start final empty (cons (finalize-token state (reverse acc)) tacc)))]
         [(boolean? trl) 
          (error 'ERROR "left to parse:~a ~a\n" state (list->string cl))]
         [(symbol=? state 'comment)
          (reverse tacc)]
         [else
          (scan-acc (rest cl) trans (transition-next (first trl)) final (cons (first cl) acc) tacc)]))]))

;; helper functions for scan-acc

(define (found-trans? state ch tr)
  (and (symbol=? state (transition-state tr))
       ((transition-charset tr) ch)))

;; finalize-token symbol (listof char) -> token
(define (finalize-token state l) 
  (cond
    [(symbol=? state 'int) (make-token 'int (check-int-range (list->number l)))]
    [(symbol=? state 'zero) (make-token 'int 0)]
    [(symbol=? state 'hexint) (make-token 'hexint (check-hexint-range (list->hexint (rest (rest l)))))]
    [(symbol=? state 'register) (make-token 'register (check-reg-range (list->number (rest l))))]
    [else (make-token state l)]))

;; helper functions for finalize-token

(define (list->number lst) (string->number (list->string lst)))

(define (list->hexint lst) (string->number (list->string lst) 16))

;; Scheme supports unbounded integers but WLPP doesn't
(define (check-int-range n)
  (cond
    [(<= -2147483648 n 4294967295) n]
    [else (error 'ERROR "integer out of range: ~a" n)]))

(define (check-hexint-range n)
  (cond
    [(<= 0 n 4294967295) n]
    [else (error 'ERROR "integer out of range: ~a" n)]))

(define (check-reg-range n)
  (cond
    [(<= 0 n 31) n]
    [else (error 'ERROR "register out of range: ~a" n)]))

;; Some very basic tests

(define (scan str)
  (scan-func str asmtrlst 'start asmfinal))

;(scan "01")
;(scan "0xabcd ; should be ignored")
;(scan ".word 01234")
;(scan "0add")
;(scan "foo:     add $1, $2, $3   ; A comment.")

;; Here's an example of processing tokens that can be generalized to
;; the tasks required in CS 241.

;; Read lines from stdin until EOF, process each line with process-line,
;;  write result to stderr.

(define (with-input process-line)
  (define line (read-line))
  (cond
    [(eof-object? line) (void)]
    [(> (string-length line) 0) ; Ignore blank lines
	    (begin
              (fprintf (current-error-port) "~a" (process-line line))
              (with-input process-line))]
    [else (with-input process-line)]))

;; This will just print stdin to stderr, deleting empty lines:  
; (with-input (lambda (line) line))

; Creates one particular human-readable representation of a token
(define (token->string tkn)
  (define kind (token-kind tkn))
  (define lex (token-lexeme tkn))
  (case (token-kind tkn)
    [(register) (format "$~a " lex)]
    [(hexint) (format "0x~a " lex)]
    [(int zero) (format "~a " lex)]
    [else (format "~a {~a} " (token-trans tkn) (list->string lex))]))

(define (token-trans tkn)
  (cond
    [(assoc (token-kind tkn) token-table) => second]
    [else "##########"])) ;; unknown type, error in token-table

(define token-table
  '((register "REGISTER")
    (int "INT")
    (id "ID")
    (label "LABEL")
    (comma "COMMA")
    (lparen "LPAREN")
    (rparen "RPAREN")
    (zero "ZERO")
    (hexint "HEXINT")
    (comment "COMMENT")
    (dotword "DOTWORD")
    (whitespace "WHITESPACE")))

;; If we're going to do a lot of appending, it's better to keep things
;; as lists of characters instead of strings, but for a demo, it's okay

(define (line->tokenline line)
  (string-append* (map token->string (scan line))))

;; Same basic tests
;(line->tokenline "01")
;(line->tokenline "0xabcd ; should be ignored")
;(line->tokenline ".word 01234")
;(line->tokenline "0add")
;(line->tokenline "foo:     add $1, $2, $3   ; A comment.")

;; This will process all of input and print the readable-token representation:
;; (with-input line->tokenline)

(define (read-all-input)
  (local ((define item (read-line)))
    (if (eof-object? item)
        empty
        (cons item (read-all-input)))))

;jr:   0000 00ss sss0 0000 0000 0000 0000 1000
;jalr: 0000 00ss sss0 0000 0000 0000 0000 1001
;jr: 00000000000000000000000000 000000
;    000000000000000000000000000 sssss
;    00000000000 000000000000000001000
; jr $31

(define (byte-jr num)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift num 21)
                               (arithmetic-shift 8 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-jalr num)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift num 21)
                               (arithmetic-shift 9 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

; add sub slt sltu

(define (byte-add d s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 32 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-sub d s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 34 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-slt d s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 42 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-sltu d s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 43 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-beq s t i)
  (local
    [(define word (bitwise-ior (arithmetic-shift 4 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (bitwise-and i #xffff)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (cond
      [(or (and (>= i -32768)(<= i 32767))
           (equal? i 65535))(printbyte word)]
      [else (fprintf (current-error-port) "ERROR\n")])))

(define (byte-bne s t i)
  (local
    [(define word (bitwise-ior (arithmetic-shift 5 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (bitwise-and i #xffff)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (cond
      [(or (and (>= i -32768)(<= i 32767))
           (equal? i 65535))(printbyte word)]
      [else (fprintf (current-error-port) "ERROR\n")])))

(define (byte-lis d)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 20 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-mfhi d)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 16 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-mflo d)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 16)
                               (arithmetic-shift d 11)
                               (arithmetic-shift 18 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-mult s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift 24 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-multu s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift 25 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-div s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift 26 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-divu s t)
  (local
    [(define word (bitwise-ior (arithmetic-shift 0 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (arithmetic-shift 27 0)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (byte-sw t i s)
  (local
    [(define word (bitwise-ior (arithmetic-shift 43 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (bitwise-and i #xffff)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (cond
      [(and (>= i -32768)(<= i 32767))(printbyte word)]
      [else (fprintf (current-error-port) "ERROR\n")])))

(define (byte-lw t i s)
  (local
    [(define word (bitwise-ior (arithmetic-shift 35 26)
                               (arithmetic-shift s 21)
                               (arithmetic-shift t 16)
                               (bitwise-and i #xffff)))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (cond
      [(and (>= i -32768)(<= i 32767))(printbyte word)]
      [else (fprintf (current-error-port) "ERROR\n")])))

(define (byte-word i)
  (local
    [(define word (bitwise-ior i))
     (define (printbyte num)
       (write-byte (bitwise-and (arithmetic-shift num -24) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -16) #xff))
       (write-byte (bitwise-and (arithmetic-shift num -8) #xff))
       (write-byte (bitwise-and word #xff)))]
    (printbyte word)))

(define (findoutID char)
  (cond
    [(equal? "" char) empty]
    [(empty? (scan char)) empty]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'dotword)
          (equal? (token-lexeme (first (scan char))) (list #\. #\w #\o #\r #\d))
          (or (equal? (token-kind (second (scan char))) 'int)
              (equal? (token-kind (second (scan char))) 'hexint))
          )
     (byte-word (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 1)
          (equal? (token-kind (first (scan char))) 'label))
     empty]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\j #\r))
          (equal? (token-kind (second (scan char))) 'register)
          )
     (byte-jr (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\j #\a #\l #\r))
          (equal? (token-kind (second (scan char))) 'register)
          )
     (byte-jalr (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\a #\d #\d))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          )
     (byte-add (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\s #\u #\b))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          )
     (byte-sub (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\s #\l #\t))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          )
     (byte-slt (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\s #\l #\t #\u))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          )
     (byte-sltu (token-lexeme (second (scan char)))
                (token-lexeme (fourth (scan char)))
                (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\b #\e #\q))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          (or (equal? (token-kind (sixth (scan char))) 'int)
              (equal? (token-kind (sixth (scan char))) 'hexint))
          )
     (byte-beq (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\b #\n #\e))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          (or (equal? (token-kind (sixth (scan char))) 'int)
              (equal? (token-kind (sixth (scan char))) 'hexint))
          )
     (byte-bne (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 7)
          (equal? (token-kind (first (scan char))) 'label)
          (equal? (token-kind (second (scan char))) 'id)
          (equal? (token-lexeme (second (scan char))) (list #\b #\e #\q))
          (equal? (token-kind (third (scan char))) 'register)
          (equal? (token-kind (fifth (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'comma)
          (equal? (token-kind (sixth (scan char))) 'comma)
          (equal? (token-kind (seventh (scan char))) 'id)
          (equal? (list->string (token-lexeme (first (scan char))))(string-append (list->string (token-lexeme (seventh (scan char))))":"))
          )
     (byte-beq (token-lexeme (third (scan char)))
               (token-lexeme (fifth (scan char)))
               -1)]
    [(and (equal? (length (scan char)) 7)
          (equal? (token-kind (first (scan char))) 'label)
          (equal? (token-kind (second (scan char))) 'id)
          (equal? (token-lexeme (second (scan char))) (list #\b #\n #\e))
          (equal? (token-kind (third (scan char))) 'register)
          (equal? (token-kind (fifth (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'comma)
          (equal? (token-kind (sixth (scan char))) 'comma)
          (equal? (token-kind (seventh (scan char))) 'id)
          (equal? (list->string (token-lexeme (first (scan char))))(string-append (list->string (token-lexeme (seventh (scan char))))":"))
          )
     (byte-bne (token-lexeme (third (scan char)))
               (token-lexeme (fifth (scan char)))
               -1)]
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\b #\e #\q))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          (equal? (token-kind (sixth (scan char))) 'id)
          )
     (byte-beq (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (-(/(- (hash-ref ht char)(hash-ref ht (string-append (list->string (token-lexeme (sixth (scan char)))) ":"))4)4)1)
               )]
    
    [(and (equal? (length (scan char)) 6)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\b #\n #\e))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'comma)
          (equal? (token-kind (sixth (scan char))) 'id)
          )
     (byte-bne (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char)))
               (-(/(- (hash-ref ht char)(hash-ref ht (string-append (list->string (token-lexeme (sixth (scan char)))) ":"))4)4)1)
               )]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\l #\i #\s))
          (equal? (token-kind (second (scan char))) 'register)
          )
     (byte-lis (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\m #\f #\h #\i))
          (equal? (token-kind (second (scan char))) 'register)
          )
     (byte-mfhi (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 2)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\m #\f #\l #\o))
          (equal? (token-kind (second (scan char))) 'register)
          )
     (byte-mflo (token-lexeme (second (scan char))))]
    [(and (equal? (length (scan char)) 4)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\m #\u #\l #\t))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          )
     (byte-mult (token-lexeme (second (scan char)))
                (token-lexeme (fourth (scan char))))]
    [(and (equal? (length (scan char)) 4)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\m #\u #\l #\t #\u))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          )
     (byte-multu (token-lexeme (second (scan char)))
                 (token-lexeme (fourth (scan char))))]
    [(and (equal? (length (scan char)) 4)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\d #\i #\v))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          )
     (byte-div (token-lexeme (second (scan char)))
               (token-lexeme (fourth (scan char))))]
    [(and (equal? (length (scan char)) 4)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\d #\i #\v #\u))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (fourth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          )
     (byte-divu (token-lexeme (second (scan char)))
                (token-lexeme (fourth (scan char))))]
    [(and (equal? (length (scan char)) 7)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\s #\w))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'lparen)
          (equal? (token-kind (seventh (scan char))) 'rparen)
          (or (equal? (token-kind (fourth (scan char))) 'int)
              (equal? (token-kind (fourth (scan char))) 'hexint))
          )
     (byte-sw (token-lexeme (second (scan char)))
              (token-lexeme (fourth (scan char)))
              (token-lexeme (sixth (scan char))))]
    [(and (equal? (length (scan char)) 7)
          (equal? (token-kind (first (scan char))) 'id)
          (equal? (token-lexeme (first (scan char))) (list #\l #\w))
          (equal? (token-kind (second (scan char))) 'register)
          (equal? (token-kind (sixth (scan char))) 'register)
          (equal? (token-kind (third (scan char))) 'comma)
          (equal? (token-kind (fifth (scan char))) 'lparen)
          (equal? (token-kind (seventh (scan char))) 'rparen)
          (or (equal? (token-kind (fourth (scan char))) 'int)
              (equal? (token-kind (fourth (scan char))) 'hexint))
          )
     (byte-lw (token-lexeme (second (scan char)))
              (token-lexeme (fourth (scan char)))
              (token-lexeme (sixth (scan char))))]
    [else (fprintf (current-error-port) "ERROR\n")]))

(define (input)
  (local
    [(define item (read-all-input))
     (define (helper listofc)
       (cond       
         [(empty? listofc) empty]
         [else (findoutID (first listofc))(helper (rest listofc))]))
     (define (symbol-table loc)
       (local
         [(define (helper loc addr)
            (cond
              [(empty? loc) empty]
              [else (hash-set! ht (first loc) addr)(helper (rest loc) (+ 4 addr))]))]
         (helper loc 0)))]
    (symbol-table item)
    (helper item)
    ))

(define ht (make-hash))

(void (input))

; (/(- (hash-ref ht char (fprintf (current-error-port) "ERROR\n"))(hash-ref ht (string-append (list->string (token-lexeme (sixth (scan char)))) ":"))4)4)
;   )]

