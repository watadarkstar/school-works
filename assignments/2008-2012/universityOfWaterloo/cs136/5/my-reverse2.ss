#lang scheme
(provide my-reverse2)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 3
;; (my-reverse2)
;;
;; ***********************************************

;; Purpose: To reverse the list by using a more efficient way
;; Contract: (listof any) -> (listof any)
;; Examples: (my-reverse2 empty) => empty
;;           (my-reverse2 (list 1)) => (list 1)
;;           (my-reverse2 (list 1 2)) => (list 2 1)
;;           (my-reverse2 (list 1 2 3 4 5)) => (list 5 4 3 2 1)

(define (my-reverse2 lst)
  (cond
    [(empty? lst) empty] ;; takes O(N)
    [(empty? (rest lst)) lst] ;; takes O(N)
    [else (local
            [(define (helper lst1 accum) ;; takes O(N)
               (cond
                 [(empty? lst1) empty] ;; takes O(N)
                 [(empty? (rest lst1))(cons (first lst1) accum)] ;; takes O(N)
                 [else (helper (rest lst1) (cons (first lst1) accum))]))] ;; takes O(N)
            (helper (rest lst) (cons (first lst) empty)))]))

;; In total my-reverse2 takes O(N) to run a function in term of list with length N.
