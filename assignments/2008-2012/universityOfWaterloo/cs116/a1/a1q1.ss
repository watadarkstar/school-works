;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 1, Question 1
;; (two-three-or-five)
;;
;; ***********************************************


;; Contract: two-three-or-five: num -> (listof num)

;; Purpose: To produce a list of positive integers from 1 up to n that are divisible by 2, 3 or 5 given a number n.

;; Example: (two-three-or-five 7) => (list 2 3 4 5 6)
;           (two-three-or-five 9) => (list 2 3 4 5 6 8)
;           (two-three-or-five 1) => empty

;; Contract: count-from-i: num -> (listof num)

;; Purpose: To produce a list of number by counting up given a number n.

;; Example: (count-from-i 7) => (list 1 2 3 4 5 6 7)
;           (two-three-or-five 9) => (list 2 3 4 5 6 8)
;           (two-three-or-five 1) => empty

;; Definition:
(define (two-three-or-five n)
  (local
    [(define (count-from-i i)
       (cond
         [(= n i) empty]
         [else (cons i (count-from-i (add1 i)))]))
    (define (find-nums a)
       (cond
         [(zero? (remainder a 2)) true]
         [(zero? (remainder a 3)) true]
         [(zero? (remainder a 5)) true]
         [else false]))]
    (filter find-nums (count-from-i 1))))

;; Tests for two-three-or-five:
(check-expect (two-three-or-five 7)(list 2 3 4 5 6))
(check-expect (two-three-or-five 9)(list 2 3 4 5 6 8))
(check-expect (two-three-or-five 10) (list 2 3 4 5 6 8 9))
(check-expect (two-three-or-five 1) empty)
                      