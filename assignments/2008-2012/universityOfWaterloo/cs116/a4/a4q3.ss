;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a4q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 4, Question 3
;; (rev-num)
;;
;; ***********************************************

;; Contract: num {=> 0} -> num

;; Purpose: To produce a number consisting of the digits of n in reverse given a positive number

;; Examples:(rev-num 12345) => 1234
;;          (rev-num 12342) => 1342

;; Definition:
(define (rev-num n)
  (local
    [(define (rev-num-acc num acc)
       (cond
         [(zero? num) acc]
         [else (rev-num-acc num (+ (* 10 acc) (first num)))]))]))

; Tests for rev-num:
(check-expect (rev-num 12345) 1234)
(check-expect (rev-num 12342) 1342)
(check-expect (rev-num 54321) 4321)
