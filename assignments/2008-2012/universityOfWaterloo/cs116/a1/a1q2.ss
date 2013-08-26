;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 1, Question 2
;; (just-nums)
;;
;; ***********************************************

;; Contract: just-nums: (listof list) -> (listof list)

;; Purpose: produce a lists of the lists that nonempty list of numbers given a lists of lists

;; Example:(just-nums (list (list 'a) (list 1 'b) (list 2))) => (list (list 2))
;;         (just-nums (list (list 'x 10)(list 1'b)(list 2))) => (list (list 2))
;;         (just-nums (list empty) => empty

;; Definition:
(define (just-nums alol)
  (local
    [(define (remove-list alist)
       (cond
         [(empty? alist) true]
         [(number? (first alist))
          (remove-list (rest alist))]
         [else false]))]
    (filter remove-list alol)))

;; Tests for just-nums
(check-expect (just-nums (list (list 'a) (list 1 'b) (list 1 2 3))) (list (list 1 2 3)))
(check-expect (just-nums (list (list 'a) (list 1 'b) (list 2))) (list (list 2)))
(check-expect (just-nums (list (list 'x 10)(list 1'b)(list 2))) (list (list 2)))
(check-expect (just-nums empty) empty)

