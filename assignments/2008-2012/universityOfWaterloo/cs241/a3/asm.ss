#lang scheme

;; Here is the main function provided, which uses the data definitions
;; and helper functions that follow. Sample tests are at the bottom of the file.

;; scan-func: (listof char) trans-table symbol (listof symbol) -> (listof token)

(define (scan-func str trans start final)
  (scan-acc (string->list str) trans start final empty empty))



(define-struct token (kind lexeme) #:transparent)

(define-struct transition (state charset next) #:transparent)


(define (one-to-nine? ch)
  (and (char<=? #\1 ch) (char<=? ch #\9)))

(define (hex-digit? ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\f))
   (and (char<=? #\A ch) (char<=? ch #\F))))

(define (chartest ch)
  (lambda (x) (char=? x ch)))



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


(define (found-trans? state ch tr)
  (and (symbol=? state (transition-state tr))
       ((transition-charset tr) ch)))

(define (finalize-token state l) 
  (cond
    [(symbol=? state 'int) (make-token 'int (check-int-range (list->number l)))]
    [(symbol=? state 'zero) (make-token 'int 0)]
    [(symbol=? state 'hexint) (make-token 'hexint (check-hexint-range (list->hexint (rest (rest l)))))]
    [(symbol=? state 'register) (make-token 'register (check-reg-range (list->number (rest l))))]
    [else (make-token state l)]))


(define (list->number lst) (string->number (list->string lst)))

(define (list->hexint lst) (string->number (list->string lst) 16))

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


(define (scan str)
  (scan-func str asmtrlst 'start asmfinal))


(define (with-input process-line)
  (define line (read-line))
  (cond
    [(eof-object? line) (void)]
    [(> (string-length line) 0) 
	    (begin
              (fprintf (current-error-port) "~a" (process-line line))
              (with-input process-line))]
    [else (with-input process-line)]))

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
    [else "##########"])) 

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

(define (line->tokenline line)
  (string-append* (map token->string (scan line))))





;(define (myfun)
;  (let
;      [(define 
;    (cond
;      [(empty? (read-all-input)) null]
;      [(empty? (scan (first (read-all-input)))) null]
;      [(equal? (token-kind (first (scan (first (read-all-input))))) 'dotword)
;       (printbit (token-lexeme (second (scan (first (read-all-input))))))
;       ]
;      [else (fprintf (current-error-port) "ERROR\n")]))
;       

(define (read-all-input) 
  (local ((define item (read-line))) 
    (if (eof-object? item) 
        empty 
        (cons item (read-all-input))))) 

(define (byte-word i)
  (local
    [(define word (bitwise-ior  i ))
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
    [(and (equal? (token-kind (first (scan char))) 'dotword)
          (equal? (token-lexeme (first (scan char))) (list #\. #\w #\o #\r #\d))
          (equal? (length (scan char)) 2))
     (byte-word (token-lexeme (second (scan char))))]
    [else (fprintf (current-error-port) "ERROR\n")]))


(define (input)
  (local
    [(define item (read-all-input))
     (define (helper listofc)
       (cond       
         [(empty? listofc) empty]
         [else (findoutID (first listofc))(helper (rest listofc))]))]
    (helper item)))

(void (input))

