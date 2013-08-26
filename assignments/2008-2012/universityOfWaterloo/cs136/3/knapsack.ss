#lang scheme
(provide knapsack)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 3 Question 2
;; (knapsack)
;;
;; ***********************************************

;;Question 2

;; Purpose:
;; To calculate to highest value of elements from knapsack since it is restrict by the limit weight

;; knapsack: (listof (listof num)) num -> num

;; Examples:
;;(check-expect (knapsack (list (list 5 10) (list 4 40) (list 6 30) (list 3 50)) 10) 90)
;;(check-expect (knapsack (list (list 2 3) (list 3 4) (list 4 5) (list 5 6)) 5) 7)

(define (knapsack ilst W)
  (local
    ;; count:(listof num) -> (listof num)
    ;; To calculate all the value in the elements
    [(define (count lst)
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
     ;; remove-bad: (listof (listof (listof num))) num -> (listof (listof (listof num)))
     ;; To remove all elements in list which exceed the limit weight and duplicate
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
    (count (remove-bad (combination ilst) W))))


;; Helperfunction:
;; To produce all possible combinations from the elements in the list

;; combination: (listof (listof num)) => (listof (listof (listof num)))

;; Examples: 
;; (combination (list (list 5 10) (list 4 40) (list 6 30))) => 
;(((5 10) (5 10))
; ((5 10) (4 40))
; ((5 10) (6 30))
; ((4 40) (5 10))
; ((4 40) (4 40))
; ((4 40) (6 30))
; ((6 30) (5 10))
; ((6 30) (4 40))
; ((6 30) (6 30)))

(define (combination list)
  (local
    [(define (combination1 list1 list2)
       (cond
         [(empty? list2) empty]
         [else (cons (cons list1 (cons (first list2) empty))
                     (combination1 list1 (rest list2)))]))
     (define (combination2 list1 list2)
       (cond
         [(empty? list1) empty]
         [else (append (combination1 (first list1) list2)
                       (combination2 (rest list1) list2))]))]
    (combination2 list list)))
