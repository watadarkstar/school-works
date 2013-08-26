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
     (list (gen-statements (list-ref t 10))(gen-expr (list-ref t 12)))]  ;; (gen-code (thirteenth t))
    [(list "dcls")
     empty]
    ;[(list "dcls" "dcls" "dcl" "BECOMES" "NUM" "SEMI")
    ;(gen-dcls t)]
    ;[(list "statements")
    ;empty]
    ;[(list "statements" "statements" "statement")
    ;(gen-statement t)]
  
    ))


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
       [else (fprintf (current-error-port) "ERROR\n")])]
    [(list "NUM" name)
     (list "lis $3\n" (string-append ".word " name "\n"))]))


(define (gen-statements t)
  (match (string-tokenize (first t))
    [(list "statements")
     empty]
    [(list "statements" "statements" "statement")
     (list (gen-statements (second t))
           (gen-statement (third t)))]))

(define (gen-statement t)
  (match (string-tokenize (first t))
    [(list "statement" "PRINTLN" "LPAREN" "expr" "RPAREN" "SEMI")
     (list ".import print\n""sw $1,-4($30)\n""sw $31,-8($30)\n""lis $14\n"".word 8\n""sub $30,$30,$14\n"
           (gen-expr (fourth t))
           "add $1,$3,$0\n""lis $4\n"".word print\n""jalr $4\n"
           "lis $14\n"".word 8\n""add $30,$30,$14\n""lw $31,-8($30)\n""lw $1,-4($30)\n")]))

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


