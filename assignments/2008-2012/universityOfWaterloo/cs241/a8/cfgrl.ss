#lang scheme
;; cfgrl -- Convert CFG-R to CFG Format
;; 
;; Author:      Gordon V. Cormack
;; Revised by:  P. L. Ragde and Gordon V. Cormack
;; Version:     20081106.4
;;
;; Input:  .cfg file with single derivation
;; Output: equivalent .cfg file
;;
;; Usage:  mzscheme cfgrl.ss < file.cfg-r > file.cfg
;;

(require srfi/13)
;;
;; Helper functions
;;

(define (readsyms n t)  ;; read n symbols into hash-table t
  (cond 
    [(zero? n) empty]
    [else  (hash-set! t (read-line) 0)
           (readsyms (sub1 n) t)]))

(define (readln)        ;; read single line containing integer
  (string->number (read-line)))

(define (traverse t d)  ;; output leftmost derivation of tree t with indentation d
  (printf "~a~a\n" (make-string d #\space) (first t)) ;; print root
  (map (lambda (x) (traverse x (+ 1 d))) (rest t)))   ;; print all subtrees

(define (dump h)        ;; print keys in hashtable h in .cfg file format
  (printf "~a\n" (hash-count h))
  (hash-for-each h (lambda (x y) (printf "~a\n" x))))

(define (popper stack rhs lhs node) ;; pop rhs and accumulate subtrees, push new node
  (if (null? rhs) 
    (cons (cons lhs node) stack)    ;; done pops, push node = (rule . subtrees) 
    (popper (rest stack) (rest rhs) lhs (cons (first stack) node)))) ;; pop some more

(define (lr-do s)        ;; build tree from remaining input using stack s
  (define f (read-line))
  (define L (first (string-tokenize f)))                         ;; LHS symbol
  (define r (rest (string-tokenize f)))                          ;; RHS symbols
  (define n (filter (lambda (x) (hash-ref N x false)) r))  ;; remove terminals
  (define t (popper s (reverse n) f '()))                         ;; reduce rule
  (if (equal? S L) 
         (first (popper s (list S) f '()))    ;; special case reduce S' -> |- S -|
         (lr-do t)))                         ;; general case, continue

(define (lr) (lr-do '())) ;; wrapper function to read leftmost derivation, build tree

;;
;; Main program
;;

(define T (make-hash))  ;; terminals
(define N (make-hash))  ;; nonterminals
(define R (make-hash))  ;; production rules

(void (readsyms (readln) T))  ;; read terminals into hashtable T
(void (readsyms (readln) N))  ;; read nonterminals into hashtable N
(define S (read-line))        ;; start symbol
(void (readsyms (readln) R))  ;; read production rules (as strings)
(define parsetree (lr))       ;; read reverse rightmost derivation into parsetree
(void (dump T))               ;; write terminals in .cfg format
(void (dump N))               ;; write nonterminals
(void (printf "~a\n" S))      ;; write start symbol
(void (dump R))               ;; write production rules
(void (traverse parsetree 0)) ;; write forward leftmost derivation
