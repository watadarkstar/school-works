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
;;           (llis '(1 1 1 1 1 1 1 1)) => 1

;; Definition:
(define (llis alon)
  (local 
    [;; Contract: llist-accum: (listof num) num num -> num
     ;; Purpose: To find the length of the longest sublist
     ;; Example: (llis-accum (list 1 2 3 4) 0 0) => 4
     (define (llis-accum l num1 num2)
       (cond 
         [(empty? l) num1]
         [(empty? (rest l))(add1 (max num1 num2))]
         [(>= (first l) (first (rest l))) (llis-accum (rest l)  0  (max num1 num2))]
         [else (llis-accum (rest l)(add1 num1) num2)]))] 
    (llis-accum alon 0 0)))
         

;; Tests for llis:
(check-expect (llis '(1 1 1 1 1 1 1 1)) 1)
(check-expect (llis '(1 1 2 4 4 1 5 6)) 3)
(check-expect (llis '(5 4 3 2 1 )) 1)
(check-expect (llis '(1 3 5 7 9)) 5)