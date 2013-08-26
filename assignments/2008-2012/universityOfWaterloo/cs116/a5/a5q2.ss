;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname a5q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 5, Question 2
;; (alter)
;;
;; ***********************************************

;; State variables:
;; x: num
;; number of apples
(define x 0)
;; y: num
;; number of oranges
(define y 0)
;; z: bool
;; should I eat an apple?
(define z false)

;; Contract: alter: num num num -> (void)

;; Purpose: To return (void)

;; Effects: To convert parameters into boolean or number given three integer parameters

;; Examples: (alter 3 2 1) => x, y, and z will turn into 1, 4, and true
;;           (set! z true)(alter 2 2 3) => x, y, and z will turn into 2, 12, and false
;;           (set! z true)(alter 2 3 3) => x, y, and z will turn into 3, 18, and false
;;           (set! z true)(alter 1 2 3) => x, y, and z will turn into 1, 9, and false
;;           (set! z false)(alter 1 2 3) => x, y, and z will turn into 1, 9, and true

;; Defintion:
(define (alter a b c)
  (cond
    [(> a b)(begin (set! x c)
                   (set! y (+ a c))
                   (set! z true))]
    [(and (equal? true z)(<= a b))(begin (set! x b)
                                         (set! y (* a b c))
                                         (set! z false))]
    [else (begin (set! x a)
                 (set! y (* c 3))
                 (set! z (not z)))]))


;; Tests for alter:
(begin (alter 3 2 1) (and (equal? x 1)
                          (equal? y 4)
                          (equal? z true)))
(begin (set! z true)(alter 2 2 3) (and (equal? x 2)
                                       (equal? y 12)
                                       (equal? z false)))
(begin (set! z true)(alter 2 3 3) (and (equal? x 3)
                                       (equal? y 18)
                                       (equal? z false)))
(begin (set! z true)(alter 1 2 3) (and (equal? x 2)
                                       (equal? y 6)
                                       (equal? z false)))
(begin (set! z false)(alter 1 2 3) (and (equal? x 1)
                                       (equal? y 9)
                                       (equal? z true)))

