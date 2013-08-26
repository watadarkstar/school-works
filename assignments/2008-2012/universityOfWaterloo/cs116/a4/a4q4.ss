;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a4q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 4, Question 4
;; (llis)
;;
;; ***********************************************

;; Contract: llis: (listof num) -> num

;; Purpose: To produce the length of the longest increasing sublist of the list

;; Examples: (llis '(1 1 2 4 4 1 5 6)) => 3
;;           (llis '(5 4 3 2 1 0)) => 0
;;           (llis '(1 3 5 7 9)) => 5

;; Definition:
(define (llis alon)
  (local
    [(define (get-longest-sublist l)
       (cond
         [(empty? l) (cons first l)]
         [(< (first l)(second l))(cons (first l)(get-sublist (rest l)))]
         [else (get-sublist (rest l))]))
     (define (count-num l)
       (cond
         [(empty? l) 0]
         [else (+ 1 (count-num (rest l)))]))]
    (count-num (get-longest-sublist l))))
         

;; Tests for llis:
(check-expect (llis '(1 1 2 4 4 1 5 6)) 3)
(check-expect (llis '(5 4 3 2 1 )) 0)
(check-expect (llis '(1 3 5 7 9)) 5)