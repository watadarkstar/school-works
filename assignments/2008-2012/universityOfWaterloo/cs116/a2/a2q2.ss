;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a2q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 2, Question 2
;; (op-tester)
;;
;; ***********************************************

;; Contract: op-tester: (num -> num) (listof num) (listof num) -> (listof boolean)

;; Purpose: To produce a list of boolean if the function applied to the element or not given two lists of number.

;; Examples:  (op-tester sqr empty empty) => empty
;             (op-tester sqr (list 2 3 4) (list 4 9 16)) => (list true true true)
;             (op-tester sqr (list 2) (list 5)) => (list false)
;             (op-tester sqrt (list 4 9 16)(list 2 3 4)) => (list true true true)

;; Definition:
(define (op-tester func lst1 lst2)
  (cond 
    [(empty? lst1) empty]
    [(= (func (first lst1))(first lst2)) 
     (cons true 
          (op-tester func (rest lst1)(rest lst2)))]
    [else (cons false
                (op-tester func (rest lst1)(rest lst2)))]))

;; Tests for op-tester
(check-expect (op-tester sqr empty empty) empty)
(check-expect (op-tester sqr (list 2 3 4) (list 4 9 16)) 
              (list true true true))
(check-expect (op-tester sqr (list 2) (list 5)) 
              (list false))
(check-expect (op-tester sqrt (list 4 9 16)(list 2 3 4))
              (list true true true))