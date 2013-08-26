#lang scheme
;; Assignment 9 Problem 1 2 3 4(partial solution)
;; Assignment 10 Problem 1 (partial solution)
;;
;; Author:  Gordon V. Cormack + Darren Poon
;; Modified: Matt McPherrin and Ondrej Lhotak (update for Scheme 4.x)
;; Version: 081110.1
;;

(require (lib "string.ss" "srfi" "13"))

;;
;; Helper functions and data structures
;;

(define T     ;; table of terminal symbols, needed for reading WLI format
  (make-immutable-hash 
   '(("BOF") ("BECOMES") ("COMMA") ("ELSE") ("EOF") ("EQ") ("GE") ("GT") ("ID")
             ("IF") ("INT") ("LBRACE") ("LE") ("LPAREN") ("LT") ("MINUS") ("NE")
             ("NUM") ("PCT") ("PLUS") ("PRINTLN") ("RBRACE") ("RETURN") ("RPAREN") 
             ("SEMI") ("SLASH") ("STAR") ("WAIN") ("WHILE")) ))

(define (read-parse lhs)          ;; read and return wli parse tree
  (define line (read-line))
  (define r (rest (string-tokenize line)))
  (cons line
        (if (hash-ref T lhs #f) 
            empty
            (map read-parse r))))

(define (gen-symbols t)                ;; compute symbols defined in t 
  (match (string-tokenize (first t))
    [(list "S" "BOF" "procedure" "EOF") 
     (gen-symbols (third t))]         ;; recurse on "procedure"
    [(list "procedure" "INT" "WAIN" "LPAREN" "dcl" "COMMA" "dcl" "RPAREN" "LBRACE" "dcls" "statements" "RETURN" "expr" "SEMI" "RBRACE")
     (cond
       [(equal? (gen-symbols (fifth t))(gen-symbols (seventh t)))
        (fprintf (current-error-port) "ERROR\n")]
       [else (list (gen-symbols (fifth t)) (gen-symbols (seventh t)))])]  ;; recurse on "dcl" and "dcl"
    [(list "dcl" "INT" "ID")
     (gen-symbols (third t))]         ;; recurse on "ID"
    [(list "ID" name) name]))               ;; return lexeme for "ID"

(define (gen-code t)                   ;; returns code tree
  (match (string-tokenize (first t))
    [(list "S" "BOF" "procedure" "EOF")
     (list (gen-code (third t)) "jr $31\n")]
    [(list "procedure" "INT" "WAIN" "LPAREN" "dcl" "COMMA" "dcl" "RPAREN" "LBRACE" "dcls" "statements" "RETURN" "expr" "SEMI" "RBRACE")
     (list (gen-dcls (list-ref t 9))(gen-statements (list-ref t 10))(gen-expr (list-ref t 12)))]  ;; (gen-code (thirteenth t))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; test
(define (gen-test t)
  (match (string-tokenize (first t))
    [(list "test" "expr" "LT" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "slt $3,$4,$3\n")]
    [(list "test" "expr" "EQ" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "beq $3,$4,3\n"
           "lis $3\n"".word 0\n""beq $0,$0,2\n"
           "lis $3\n"".word 1\n")]
    [(list "test" "expr" "NE" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "bne $3,$4,3\n"
           "lis $3\n"".word 0\n""beq $0,$0,2\n"
           "lis $3\n"".word 1\n")]
    [(list "test" "expr" "GT" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "slt $3,$3,$4\n")]
    [(list "test" "expr" "LE" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "bne $3,$4,3\n"
           "lis $3\n"".word 1\n""beq $0,$0,1\n"
           "slt $3,$4,$3\n")]
    [(list "test" "expr" "GE" "expr")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "bne $3,$4,3\n"
           "lis $3\n"".word 1\n""beq $0,$0,1\n"
           "slt $3,$3,$4\n")]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dcls
(define variable (make-hash))
(define num (box empty))
(define var (box empty))
(define (gen-dcls t)
  (match (string-tokenize (first t))
    [(list "dcls" ) empty]
    [(list "dcls" "dcls" "dcl" "BECOMES" "NUM" "SEMI")
     (list (gen-dcls (second t))
           (set-box! num (second (string-tokenize (first (fifth t)))))
           (gen-dcl (third t)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dcl
(define (gen-dcl t)
  (match (string-tokenize (first t))
    [(list "dcl" "INT" "ID")
     (gen-dcl (third t))]
    [(list "ID" name)
     (cond
       [(number? (hash-ref variable name false))(fprintf (current-error-port) "ERROR\n")]
       [(list? (member name symbols))(fprintf (current-error-port) "ERROR\n")]
       [else (hash-set! variable name 0)
             (set-box! var name)
             (list "lis $23\n"
                   (string-append ".word " (unbox var) "\n")
                   "lis $24\n"
                   (string-append ".word " (unbox num) "\n")
                   "sw $24, 0($23)\n")])]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; expr
(define (gen-expr t)
  (match (string-tokenize (first t))
    [(list "expr" "term")
     (gen-term (second t))]
    [(list "expr" "expr" "PLUS" "term")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-term (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "add $3,$4,$3\n")]
    [(list "expr" "expr" "MINUS" "term")
     (list (gen-expr (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-term (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "sub $3,$4,$3\n")]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; term
(define (gen-term t)
  (match (string-tokenize (first t))
    [(list "term" "factor")
     (gen-factor (second t))]
    [(list "term" "term" "STAR" "factor")
     (list (gen-term (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-factor (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "mult $3,$4\n" "mflo $3\n")]
    [(list "term" "term" "SLASH" "factor")
     (list (gen-term (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-factor (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "div $4,$3\n" "mflo $3\n")]
    [(list "term" "term" "PCT" "factor")
     (list (gen-term (second t))
           "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
           (gen-factor (fourth t))
           "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $4,-4($30)\n"
           "div $4,$3\n" "mfhi $3\n")]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; factor
(define (gen-factor t)
  (match (string-tokenize (first t))
    [(list "factor" "ID")
     (gen-factor (second t))]
    [(list "factor" "NUM")
     (gen-factor (second t))]
    [(list "factor" "LPAREN" "expr" "RPAREN")
     (gen-expr (third t))]
    [(list "ID" name)
     (cond
       [(and (list? (member name symbols))(equal? name (first symbols))) "add $3,$0,$1\n"]
       [(and (list? (member name symbols))(equal? name (second symbols))) "add $3,$0,$2\n"]
       [(number? (hash-ref variable name false))(list "lis $21\n"
                                                      (string-append ".word " name "\n")
                                                      "lw $3,0($21)\n")]
       [else (fprintf (current-error-port) "ERROR\n")])]
    [(list "NUM" name)
     (list "lis $3\n" (string-append ".word " name "\n"))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; statements
(define (gen-statements t)
  (match (string-tokenize (first t))
    [(list "statements")
     empty]
    [(list "statements" "statements" "statement")
     (list (gen-statements (second t))
           (gen-statement (third t)))]
    [else (fprintf (current-error-port) "ERROR\n")]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; statement
(define labelCounter 0)
(define condition 0)
(define statement-var (box empty))
(define (gen-statement t)
  (match (string-tokenize (first t))
    [(list "statement" "PRINTLN" "LPAREN" "expr" "RPAREN" "SEMI")
     (list ".import print\n""sw $1,-4($30)\n""sw $31,-8($30)\n""lis $14\n"".word 8\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "add $1,$3,$0\n""lis $4\n"".word print\n""jalr $4\n"
           "lis $14\n"".word 8\n""add $30,$30,$14\n""lw $31,-8($30)\n""lw $1,-4($30)\n")]
    [(list "statement" "ID" "BECOMES" "expr" "SEMI")
     (set-box! statement-var (second (string-tokenize (first (second t)))))
     (cond
       [(number? (hash-ref variable (unbox statement-var) false))
        (list "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
              "lis $11\n"
              (string-append ".word "(unbox statement-var)"\n")
              (gen-expr (fourth t))
              "sw $3,0($11)\n"
              "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $3,-4($30)\n")]
       [(and (list? (member (unbox statement-var) symbols))(equal? (unbox statement-var)(first symbols)))
        (list "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
              (gen-expr (fourth t))
              "add $1,$0,$3\n"
              "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $3,-4($30)\n")]
       [(and (list? (member (unbox statement-var) symbols))(equal? (unbox statement-var)(first symbols)))
        (list "sw $3,-4($30)\n""lis $14\n"".word 4\n""sub $30,$30,$14\n"
              (gen-expr (fourth t))
              "add $2,$0,$3\n"
              "lis $14\n"".word 4\n""add $30,$30,$14\n""lw $3,-4($30)\n")]
       [else (fprintf (current-error-port) "ERROR\n")])]
    [(list "statement" "WHILE" "LPAREN" "test" "RPAREN" "LBRACE" "statements" "RBRACE")
     (add1 labelCounter)
     (list (string-append "Start"(number->string labelCounter)":\n")
           (gen-test (fourth t))
           (string-append "beq $3,$0,"(string-append "End"(number->string labelCounter)"\n"))
           (gen-statements (seventh t))
           (string-append "beq $0,$0,"(string-append "Start"(number->string labelCounter)"\n"))
           (string-append "End"(number->string labelCounter)":\n"))]
    [(list "statement" "IF" "LPAREN" "test" "RPAREN" "LBRACE" "statements" "RBRACE" "ELSE" "LBRACE" "statements" "RBRACE")
     (add1 condition)
     (list (gen-test (list-ref t 3))
           (string-append "beq $3,$0,""ConElse"(number->string condition)"\n")
           (gen-statements (list-ref t 6))
           (string-append "beq $0,$0,""ConEnd" (number->string condition) "\n")
           (string-append "ConElse" (number->string condition) ":\n")
           (gen-statements (list-ref t 10))
           (string-append "ConEnd" (number->string condition)":\n"))]
           ))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Static Memory
(define (gen-SM h)
  (hash-for-each h (lambda (x y)(printf "~a: .word 0\n"x))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (print-code c)                      ;; flatten and output assembly code
  (cond
    [(pair? c) (print-code (first c)) (print-code (rest c))]
    [(string? c) (display c)]
    [else empty]))


;;
;; Main Program
;;

(define parse-tree (read-parse "S"))        ;; read in wli format parse tree
(define symbols (gen-symbols parse-tree))   ;; extract list of symbol definitinos
(define code-tree (gen-code parse-tree))    ;; generate code
(void (print-code code-tree))                      ;; flatten and output code
(void (print-code (gen-SM variable)))

