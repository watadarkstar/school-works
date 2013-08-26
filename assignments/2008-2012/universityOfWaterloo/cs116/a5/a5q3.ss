;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname a5q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 5, Question 3
;; (rotate)
;;
;; ***********************************************

;; State variables:
;; one: any 
;; holds the first value, initially
(define one 1)
;; two: any
;; holds the second value, initially
(define two 7)
;; three: any
;; holds the third value, initially
(define three 189)

;; Contract: rotate: (void) -> (void)

;; Purpose: To return (void) given no parameter 

;; Effects: To interchange the defined variable 

;; Examples: (rotate) => one, two, three will have the value of 189, 1, 7 
;;           (set! one 3)(set! two 2)(set! three 1)(rotate) => one, two, three will have the value of 1, 3, 2

;; Definition:
(define (rotate)
  (local
    [(define temp two)]
    (begin (set! two one)
           (set! one three)
           (set! three temp))))

;; Tests for rotate:
(begin (rotate)(and (equal? one 189)
                    (equal? two 1)
                    (equal? three 7)))
(begin (set! one 2)(rotate)(and (equal? one 7)
                                (equal? two 2)
                                (equal? three 1)))
(begin (set! two 5)(rotate)(and (equal? one 1)
                                (equal? two 7)
                                (equal? three 5)))
(begin (set! three 10)(rotate)(and (equal? one 10)
                                   (equal? two 1)
                                   (equal? three 7)))
(begin (set! one 3)(set! two 2)(set! three 1)(rotate)(and (equal? one 1)
                                                          (equal? two 3)
                                                          (equal? three 2)))
