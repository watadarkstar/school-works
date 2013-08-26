#lang scheme
(provide my-cons my-first my-rest mlist-empty mlist-empty? my-cons? set-first! set-rest! print-mlist)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 1
;; (mlist)
;;
;; ***********************************************

(define-struct mt ())
(define mlist-empty (make-mt))
(define-struct kons (fbox rbox) #:transparent)

;; To determine mlist is empty or not
;; mlist-empty?: mt -> boolean
;; Examples: (mlist-empty? mlist-empty) => true
;;           (mlist-empty? (make-kons (box 1) empty)) => false
(define (mlist-empty? mlst)
  (cond
    [(equal? mlst mlist-empty) true]
    [else false]))


;; To test if that argument is an mlist which satisfying the second "nonempty" case
;; my-cons?: mt -> boolean
;; Examples: (my-cons? (my-cons 2 (my-cons 1 (my-cons 3 empty)))) => true
;;           (my-cons? (make-kons (box 1) mlist-empty)) => false
(define (my-cons? mlst)
  (cond
    [(mlist-empty? mlst) false]
    [(mlist-empty? (kons-rbox mlst)) false]
    [else true]))


;; To build a tree of make-cons
;; my-cons: num mt -> mt
;; Examples: (my-cons 2 (my-cons 5 (my-cons 1 mlist-empty))) => (make-kons (box 2) (box (make-kons (box 5) (box (make-kons (box 1) (box (make-mt ...)))))))
(define (my-cons v mlst)
  (make-kons (box v) (box mlst)))


;; To produce fbox of mt
;; my-first: mt -> num
;; Examples: (my-first (my-cons 3 mlist-empty)) => 3
(define (my-first mlst)
  (unbox (kons-fbox mlst)))

;; To produce rbox of mt
;; my-rest: mt -> mt
;; Examples: (my-rest (my-cons 3 (my-cons 1 (my-cons 2 (my-cons 3 mlist-empty)))))=> (make-kons (box 1) (box (make-kons (box 2) (box (make-kons (box 3) (box (make-mt ...)))))))
(define (my-rest mlst)
  (unbox (kons-rbox mlst)))

;; To mutate the fbox of mt
;; set-first!: mt num -> void
;; Examples: (set-first (my-cons 2 mlist-empty) 3) => (void)
(define (set-first! mlst v)
  (set! mlst (make-kons (box v)(box (my-rest mlst)))))

;; To mutate the rbox of my
;; set-rest!: mt mt -> void
;; Examples: (set-rest! (my-cons 1 mlist-empty) (my-cons 2 mlist-empty)) => (void)
(define (set-rest! mlst1 mlst2)
  (set! mlst1 (make-kons (box (my-first mlst1))(box mlst2))))

;; To print the mlist
;; print-mlsit: mt -> (void)
;; Examples:  
;; if we excute the function: (print-mlist (my-cons 1 (my-cons 2 mlist-empty)))
;; then it will print [1 2]
(define (print-mlist mlst)
  (begin (define a (printf "["))
         (local 
           [(define (b mlst1)
              (cond
                [(mlist-empty? mlst1) (printf "]\n")]
                [(mlist-empty? (my-rest mlst1))
                 (begin (printf "~a" (my-first mlst1))
                        (set! mlst1 (my-rest mlst1))
                        (b mlst1))]
                [else
                 (begin (printf "~a " (my-first mlst1))
                        (set! mlst1 (my-rest mlst1))
                        (b mlst1))]))]
           (b mlst))))
