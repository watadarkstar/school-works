;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname equiv) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Question 2

;; my-weird: num/symbol num/symbol num/symbol -> num

;; Purpose: To make a equilvalent function same as weird-fun

;; Examples: (my-weird 10 3 5) => 18
;;           (my-weird 10 'b 5) => 0

;; Definition:
(define (my-weird-fun a b c)
  (cond
    [(symbol? c) 0]
    [(symbol? b) 0]
    [else (+ a b c)]))

;; Tests for my-weird
(check-expect (my-weird-fun 4 2 5) 11)
(check-expect (my-weird-fun 5 'symbol 3) 0)
(check-expect (my-weird-fun 5 2 'symbol) 0)


;; my-strange: num num-> 0

;; Purpose: To produce a 0 by input numbers

;; Examples: (my-strange 10 20) => 0
;;           (my-strange 4 4) => 0

;; Definition:
(define (my-strange a b)
  (cond
    [(= a b) 0]
    [else 0]))

;; Tests for my-strange
(check-expect (my-strange 10 49) 0)
(check-expect (my-strange 7 7) 0)
