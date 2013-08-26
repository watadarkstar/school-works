;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname a2q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 2, Question 5
;; (make-range-filter)
;;
;; ***********************************************

;; Contract: make-range-filter: num num -> (boolean alon -> alon)

;; Purpose: To produce a function that applied to a list of numbers and produce a list of only those entries, given two numbers entries lft and rgy

;; Examples: ((make-range-filter 4 10) '(1 3 8 4 12 10 6)) => '(8 4 10 6)

;; Definition:
(define (make-range-filter lft rgt)
  (local 
    [(define right
       (lambda (x) (<= x rgt)))
     (define left
       (lambda (x) (>= x lft)))] 
    (lambda (x)(filter right (filter left x)))))
    
;; Tests for make-range-filter
(check-expect ((make-range-filter 4 6) empty) empty)
(check-expect ((make-range-filter 0 0) '(1 2 3 4 5 6 7)) empty)
(check-expect ((make-range-filter 4 10) '(1 3 8 4 12 10 6))(list 8 4 10 6))
(check-expect ((make-range-filter 3 4) '(1 2 3 4 5 6 7))(list 3 4))
(check-expect ((make-range-filter 3 4) '(1 2 3 3 4 4 6 7 3)) (list 3 3 4 4 3))


