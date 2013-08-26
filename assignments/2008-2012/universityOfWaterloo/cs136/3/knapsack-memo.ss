#lang scheme
(provide knapsack-memo sacktable)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 3 Question 2
;; (knapsack-memo)
;;
;; ***********************************************

;;Question 2

(define sacktable empty)

;; Purpose:
;; To calculate to highest value of elements from knapsack since it is restrict by the limit weight

;; knapsack: (listof (listof num)) num -> num

;; Examples:
;;(check-expect (knapsack (list (list 5 10) (list 4 40) (list 6 30) (list 3 50)) 10) 90)
;;(check-expect (knapsack (list (list 2 3) (list 3 4) (list 4 5) (list 5 6)) 5) 7)


(define (knapsack-memo ilst W)
  (local
    [(define (combination list1 list2)
       (cond
         [(empty? list2) empty]
         [else (cons (cons list1 (cons (first list2) empty))
                     (combination list1 (rest list2)))]))
     (define (combination1 list1 list2)
       (cond
         [(empty? list1) empty]
         [else (append (combination (first list1) list2)
                       (combination1 (rest list1) list2))]))
     (define (remove-bad list W)
       (local
         [(define (remove-duplicate lst)
            (cond
              [(empty? lst) true]
              [(equal? (first lst)(second lst)) false]
              [else true]))
          (define (remove-bigger lst)
            (cond
              [(<=(+ (first (first lst))(first (second lst))) W) true]
              [else false]))]
         (filter remove-bigger (filter remove-duplicate list))))]
    (begin (set! sacktable (remove-bad (combination1 ilst ilst) W))
           (count sacktable))))


;; Helper function:
;; To add up the all value v and find the max value from the list

;; count;(listof (listof (listof num))) -> num

;; Example:(count (list (list (list 3 6)(list 5 8))(list (list 10 1)(list 4 5)))) => 14

(define (count lst)
  (local
    [(define (helper lst)
       (cond
         [(empty? lst)empty]
         [else (+ (second (first lst))
                  (second (second lst)))]))
     (define (maximum lst)
       (cond
         [(empty? lst) 0]
         [else (max (first lst)(maximum (rest lst)))]))]
    (maximum (map helper lst))))
