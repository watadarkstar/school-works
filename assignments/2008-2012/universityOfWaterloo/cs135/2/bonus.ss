;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bonus) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "htdp")))))
;;; Question 5

;; Purpose: to determine it is true or false that the first number is the biggest

;; Examples: (isMax-without-using-and 30 20 10 5 29) => true
;;           (isMax-without-using-cond 30 29 28 27 26) => true

;; Definitions:
(define (isMax-without-using-and first second third forth fifth)
  (cond
    [(> first second) true]
    [(> first third) true]
    [(> first forth) true]
    [(> first fifth) true]
    [else false]))

(define (isMax-without-using-cond first second third forth fifth)
  (and (> first second)(> first third)(> first forth)(> first fifth)))


;; Tests for isMax-without-using-and and isMax-without-using-cond
(check-expect (isMax-without-using-and 30 20 10 5 29) true)
(check-expect (isMax-without-using-cond 30 29 28 27 26) true)