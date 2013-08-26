;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a2q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 2, Question 1
;; (build-range)
;;
;; ***********************************************

;; Contract: build-range: num num num -> (listof num)

;; Purpose: To produce a list containing pts number, evenly spaced from start to finish inclusively given three numbers start, finish and pts.

;; Examples: (build-range 0 0 0) => (list 0)
;;           (build-range 2 3 5) => (list 2 2.25 2.5 2.75 3)
;;           (build-range 4 2 3) => (list 4 3 2)
;;           (build-range 1 3 3) => (list 1 2 3)
;;           (build-range 6 0 7) => (list 6 5 4 3 2 1 0)

;; Definition:
(define (build-range start finish pts)
  (local
    ;; contract: range: num num num -> num
    ;; purpose: To find the range of each points
    ;; example: (range 2 3 5) => 0.25
    ;; definition:
    [(define (range first-num last-num num-of-pt)
       (/ (- last-num first-num) (sub1 num-of-pt)))
     
     ;; contractL add-pts: num num num num num num -> (listof num)
     ;; purpose: To make a list by adding all points in to the interval
     ;; example: (add-pts 2 3 5 2 3 5) => (list 2 2.25 2.5 2.75 3)
     ;; definition:
     (define (add-pts start finish pts first-num last-num num-of-pt)
       (cond
         [(= finish start)(cons finish empty)]
         [else (cons start (add-pts (+ start (range first-num last-num num-of-pt)) finish pts first-num last-num num-of-pt))]))]
    (add-pts start finish pts start finish pts)))

;; Tests for build-range
(check-expect (build-range 0 0 0) (list 0))
(check-expect (build-range 2 3 5) (list 2 2.25 2.5 2.75 3))
(check-expect (build-range 4 2 3) (list 4 3 2))
(check-expect (build-range 1 3 3) (list 1 2 3))
(check-expect (build-range 6 0 7) (list 6 5 4 3 2 1 0))