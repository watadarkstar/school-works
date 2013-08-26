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

(define (wexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\v))
   (and (char<=? #\x ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (aexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\b ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (ahexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\b ch) (char<=? ch #\g))
   (and (char<=? #\i ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (iexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\h))
   (and (char<=? #\j ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (nexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\m))
   (and (char<=? #\o ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (hexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\g))
   (and (char<=? #\i ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (lexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\k))
   (and (char<=? #\m ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (eexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\d))
   (and (char<=? #\f ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (fexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\e))
   (and (char<=? #\g ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (texclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\s))
   (and (char<=? #\u ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (pexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\o))
   (and (char<=? #\q ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (rexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\q))
   (and (char<=? #\s ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (sexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\r))
   (and (char<=? #\t ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (uexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\t))
   (and (char<=? #\v ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (fnexclu ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\e))
   (and (char<=? #\g ch) (char<=? ch #\m))
   (and (char<=? #\o ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (letterswithout ch)
  (or
   (and (char<=? #\a ch) (char<=? ch #\d))
   (and (char<=? #\f ch) (char<=? ch #\h))
   (and (char<=? #\j ch) (char<=? ch #\o))
   (and (char<=? #\q ch) (char<=? ch #\q))
   (and (char<=? #\s ch) (char<=? ch #\v))
   (and (char<=? #\x ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (dec ch)
  (or
   (char-numeric? ch)))

(define (lettersDigits ch)
  (or
   (char-numeric? ch)
   (and (char<=? #\a ch) (char<=? ch #\z))
   (and (char<=? #\A ch) (char<=? ch #\Z))))

(define (chartest ch)
  (lambda (x) (char=? x ch)))

;; sample transition table

(define asmtrlst 
  (list
   (make-transition 'start char-whitespace? 'WHITESPACE)
   (make-transition 'start letterswithout 'ID)
   (make-transition 'ID char-alphabetic? 'ID)
   (make-transition 'ID char-numeric? 'ID)
   (make-transition 'start (chartest #\0) 'ZERO)
   (make-transition 'start one-to-nine? 'NUM)
   (make-transition 'INT char-numeric? 'INT)
   (make-transition 'start (chartest #\/) 'comment) 
   (make-transition 'comment (lambda (x) true) 'comment) 
   (make-transition 'start (chartest #\() 'LPAREN)
   (make-transition 'start (chartest #\)) 'RPAREN)
   (make-transition 'start (chartest #\{) 'LBRACE)
   (make-transition 'start (chartest #\}) 'RBRACE)
   (make-transition 'start (chartest #\=) 'BECOMES)
   (make-transition 'BECOMES (chartest #\=) 'EQ)
   (make-transition 'start (chartest #\<) 'LT)
   (make-transition 'LT (chartest #\=) 'LE)
   (make-transition 'start (chartest #\>) 'GT)
   (make-transition 'GT (chartest #\=) 'GE)
   (make-transition 'start (chartest #\+) 'PLUS)
   (make-transition 'start (chartest #\-) 'MINUS)
   (make-transition 'start (chartest #\*) 'STAR)
   (make-transition 'start (chartest #\/) 'SLASH)
   (make-transition 'start (chartest #\%) 'PCT)
   (make-transition 'start (chartest #\,) 'COMMA)
   (make-transition 'start (chartest #\;) 'SEMI)
   (make-transition 'start (chartest #\!) 'EXPO)
   (make-transition 'EXPO (chartest #\=) 'NE)      
   (make-transition 'start (chartest #\w) 'W)
   (make-transition 'W ahexclu 'ID)
   (make-transition 'W (chartest #\a) 'WA)
   (make-transition 'WA iexclu 'ID)
   (make-transition 'WA (chartest #\i) 'WAI)
   (make-transition 'WAI nexclu 'ID)
   (make-transition 'WAI (chartest #\n) 'WAIN)
   (make-transition 'WAIN lettersDigits 'ID)
   (make-transition 'W (chartest #\h) 'WH)
   (make-transition 'WH iexclu 'ID)
   (make-transition 'WH (chartest #\i) 'WHI)
   (make-transition 'WHI lexclu 'ID)
   (make-transition 'WHI (chartest #\l) 'WHIL)
   (make-transition 'WHIL eexclu 'ID)
   (make-transition 'WHIL (chartest #\e) 'WHILE)
   (make-transition 'WHILE lettersDigits 'ID)
   (make-transition 'start (chartest #\i) 'I)
   (make-transition 'I fnexclu 'ID)
   (make-transition 'I (chartest #\f) 'IF) 
   (make-transition 'I (chartest #\n) 'IN)
   (make-transition 'IF lettersDigits 'ID)
   (make-transition 'IN texclu 'ID)
   (make-transition 'IN (chartest #\t) 'INT) 
   (make-transition 'INT lettersDigits 'ID)
   (make-transition 'start (chartest #\e) 'E)
   (make-transition 'E lexclu 'ID)
   (make-transition 'E (chartest #\l) 'EL)
   (make-transition 'EL sexclu 'ID)
   (make-transition 'EL (chartest #\s) 'ELS)
   (make-transition 'ELS eexclu 'ID)
   (make-transition 'ELS (chartest #\e) 'ELSE)
   (make-transition 'ELSE lettersDigits 'ID)
   (make-transition 'start (chartest #\p) 'P)
   (make-transition 'P rexclu 'ID)
   (make-transition 'P (chartest #\r) 'PR)
   (make-transition 'PR iexclu 'ID)
   (make-transition 'PR (chartest #\i) 'PRI)
   (make-transition 'PRI nexclu 'ID)
   (make-transition 'PRI (chartest #\n) 'PRIN)
   (make-transition 'PRIN texclu 'ID)
   (make-transition 'PRIN (chartest #\t) 'PRINT)
   (make-transition 'PRINT lexclu 'ID)
   (make-transition 'PRINT (chartest #\l) 'PRINTL)
   (make-transition 'PRINTL nexclu 'ID)
   (make-transition 'PRINTL (chartest #\n) 'PRINTLN)
   (make-transition 'PRINTL lettersDigits 'ID)
   (make-transition 'start (chartest #\r) 'R)
   (make-transition 'R eexclu 'ID)
   (make-transition 'R (chartest #\e) 'RE)
   (make-transition 'RE texclu 'ID)
   (make-transition 'RE (chartest #\t) 'RET)
   (make-transition 'RET uexclu 'ID)
   (make-transition 'RET (chartest #\u) 'RETU)
   (make-transition 'RETU rexclu 'ID)
   (make-transition 'RETU (chartest #\r) 'RETUR)
   (make-transition 'RETUR nexclu 'ID)
   (make-transition 'RETUR (chartest #\n) 'RETURN)
   (make-transition 'RETURN lettersDigits 'ID)
   ))

;; sample list of final states

(define asmfinal
  (list
   'ID        
   'INT      
   'COMMA    
   'LPAREN   
   'RPAREN  
   'WHITESPACE 
   'NUM
   'ZERO
   'LBRACE
   'RBRACE
   'RETURN
   'IF
   'ELSE
   'WHILE
   'PRINTLN
   'BECOMES
   'WAIN
   'EQ
   'NE
   'LT
   'GT
   'LE
   'GE
   'PLUS
   'MINUS
   'STAR
   'SLASH
   'PCT
   'SEMI
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
    (ID "ID")        
    (INT "INT")
    (COMMA "COMMA") 
    (LPAREN "LPAREN")
    (RPAREN "RPAREN")
    (WHITESPACE "WHITESPACE")
    (NUM "NUM")
    (ZERO "ZERO")
    (LBRACE "LBRACE")
    (RBRACE "RBRACE")
    (RETURN "RETURN")
    (IF "IF")
    (ELSE "ELSE")
    (WHILE "WHILE")
    (PRINTLN "PRINTLN")
    (BECOMES "BECOMES")
    (WAIN "WAIN")
    (EQ "EQ")
    (NE "NE")
    (LT "LT")
    (GT "GT")
    (LE "LE")
    (GE "GE")
    (PLUS "PLUS")
    (MINUS "MINUS")
    (STAR "STAR")
    (SLASH "SLASH")
    (PCT "PCT")
    (SEMI "SEMI")))

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

(define (print loc)
  (cond
    [(empty? loc) empty]
    [else (printf "~a" (first loc))(print (rest loc))]))

(define (output lot)
  (cond
    [(empty? lot)empty]
    [(equal? (token-kind (first lot)) 'WHITESPACE)(output (rest lot))]
    [(and (equal? (token-kind (first lot)) 'INT)(not (equal? (token-kind (second lot)) 'WAIN)))
     (printf "INT int\n")
     (printf "ID ")(print (token-lexeme (first (rest (rest lot)))))(printf "\n")
     (printf "SEMI ;\n")
     (output (rest (rest (rest (rest lot)))))]
    [else (printf (string-append (symbol->string (token-kind (first lot)))" "))
          (print (token-lexeme (first lot)))
          (printf "\n")
          (output (rest lot))]))

(define (read-all-input)
  (local ((define item (read-line)))
    (if (eof-object? item)
        empty
        (cons item (read-all-input)))))

(define (input)
  (local
    [(define item (read-all-input))
     (define (helper listofc)
       (cond
         [(empty? listofc) empty]
         [else (output (scan (first listofc)))
               (helper (rest listofc))]))]
    (printf "INT int\nWAIN wain\nLPAREN (\nINT int\nID a\nCOMMA ,\nINT int\nID b\nRPAREN )\nLBRACE {\n")
    (helper (rest item))))

(void (input))

