;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname a2q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 2, Question 4
;; (x-distance-to)
;;
;; ***********************************************

;; Contract: x-distance-to: num -> (num num -> num)

;; Purpose: To create a function that can find out the distance of x between to coordinate

;; Examples: ((x-distance-to (make-posn 1 1))(make-posn 4 1)) => 3
;;           ((x-distance-to (make-posn 0 0))(make-posn 4 4)) => 4

;; Definition:
(define (x-distance-to p)
  (lambda (x)
    (cond
      [(> (posn-x p)(posn-x x))(- (posn-x p) (posn-x x))]
      [else (- (posn-x x) (posn-x p))])))

;; Tests for x-distance-to
(check-expect ((x-distance-to (make-posn 3 5))(make-posn 1 3)) 2)
(check-expect ((x-distance-to (make-posn 1 1))(make-posn 4 1)) 3)
(check-expect ((x-distance-to (make-posn 0 0))(make-posn 4 4)) 4)
(check-expect ((x-distance-to (make-posn 0 1))(make-posn 0 1)) 0)
(check-expect ((x-distance-to (make-posn -5 1))(make-posn -2 1)) 3)
(check-expect ((x-distance-to (make-posn -4 1))(make-posn -8 1)) 4)
