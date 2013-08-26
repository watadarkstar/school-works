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

(define (newhash in t)
  (cond
    [(empty? in) empty]
    [else (hash-set! t (first in) 0)
          (newhash (rest in) t)]))

(define (read-transition n t)
  (cond
    [(zero? n) empty]
    [else (begin (set-box! t (append (unbox t)(cons (read-line) empty)))
                 (read-transition (sub1 n) t))]))

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

(define (input1)
  (local
    [(define f (read-line))]
    (cond
      [(eof-object? f)empty]
      [else (append (string-tokenize f)(input1))])))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;//////////////////////////////////

;(sub (list 1 2 3 4 5 6)(list 3 4 5)(list 5)) => (list 1 2 5 6)
(define (sub lostring lotoken lontoken)
  (local
    [(define (helper lostring lotoken lontotoken accum lasttoken number)
       (cond
         [(empty? lostring) "does not match"]
         [(equal? true (check-eq lostring lotoken))
          (list (append accum lontoken (cdr-n lostring (length lotoken))) lasttoken number)]
         [else (helper (rest lostring) lotoken lontoken (append accum (cons (first lostring)empty))(first lostring)(add1 number))]))]
    (helper lostring lotoken lontoken empty empty 0)))

(define (check-eq lostring lotoken)
  (cond
    [(empty? lostring) false]
    [(empty? lotoken) true]
    [(equal? (first lostring)(first lotoken))(check-eq (rest lostring)(rest lotoken))]
    [else false]))

(define (cdr-n list n)
  (cond
    [(zero? n) list]
    [else (cdr-n (cdr list)(sub1 n))]))

(define (print-rule r n)
  (cond
    [(zero? n)(printf "~a\n" (car r))]
    [else (print-rule (cdr r)(sub1 n))]))

(define (rule r n)
  (cond
    [(zero? n)(car r)]
    [else (rule (cdr r)(sub1 n))]))

(define (print-list l)
  (cond
    [(empty? l)(printf "\n")]
    [else (printf "~a " (first l))
          (print-list (rest l))]))

(define (pop list n)
  (cond
    [(zero? n)list]
    [else (pop (rest list)(sub1 n))]))
;//////////////////////////////////
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(substitute (list "BOF" "id" "-" "(" "id" ")" "-" "id" "EOF") "id" (list "term")
;(list "BOF" "term" "-" "(" "id" ")" "-" "id" "EOF")
;; LR
;; (transition 0 "BOF" (unbox G)) => (list "shift" 6 "BOF")
(define (transition firstS in-string t)
  (cond
    [(empty? t) "error"]
    [(and (equal? firstS (string->number (first (string-tokenize (first t)))))
          (equal? in-string (second (string-tokenize (first t)))))
     (cons (third (string-tokenize (first t)))
           (cons (string->number (fourth (string-tokenize (first t))))
                 (cons in-string empty)))]
    [else (transition firstS in-string (rest t))]))

(define a empty)
(define b 0)
;;
(define (parsing state)
  (local
    [(define (helper state in number)
       (cond
         [(empty? in) (printf "~a " S)(print-list input)]
         [(equal? "error" (transition state (first in) (unbox G)))(fprintf (current-error-port)"ERROR at ~a\n" number)]
         [(equal? "shift" (first (transition state (first in) (unbox G))))
          (hash-set! GH (third (transition state (first in) (unbox G)))(second (transition state (first in)(unbox G))))
          (helper (second (transition state (first in) (unbox G)))(rest in) number)
          ]
         [(equal? "reduce" (first (transition state (first in) (unbox G))))
          (print-rule (unbox R)(second (transition state (first in) (unbox G))))
          (set! a (second (sub input 
                               (cdr (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))
                               (list (car (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))))))
          (set! b (third (sub input 
                              (cdr (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))
                              (list (car (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))))))
          (set! input (first (sub input 
                                  (cdr (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))
                                  (list (car (string-tokenize (rule (unbox R)(second (transition state (first in) (unbox G))))))))))
          (helper (hash-ref GH a)
                  (pop input b) (add1 number))]
         ))]
    (helper 0 input 1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Main program
;;

(define T (make-hash))  ;; terminals
(define N (make-hash))  ;; nonterminals
(define R (box empty))  ;; production rules
(define G (box empty))  ;; transition
(define GH (make-hash))

(void (readsyms (readln) T))  ;; read terminals into hashtable T
(void (readsyms (readln) N))  ;; read nonterminals into hashtable N
(define S (read-line))        ;; start symbol
(void (read-transition (readln) R))  ;; read production rules (as strings)
(define SN (read-line))       ;; read number of states
(void (read-transition (readln) G))  ;; read the grammar
(define input (input1))    ;; read input
;(define parsetree (lr))       ;; read reverse rightmost derivation into parsetree
;(void (dump T))               ;; write terminals in .cfg format
;(void (dump N))               ;; write nonterminals
;(void (printf "~a\n" S))      ;; write start symbol
;(void (dump R))               ;; write production rules
;(void (traverse parsetree 0)) ;; write forward leftmost derivation
(void (newhash input GH))
(parsing 0)
