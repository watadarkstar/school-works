;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a4q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 4, Question 2
;; (2nd-largest)
;;
;; ***********************************************

;; Contract: 2nd-largest: (listof number) -> num

;; Purpose: To produce the second largest number in the list given a list of numbers

;; Examples: (2nd-largest (list 1 2 3 4 5)) => 4
;;           (2nd-largest (list 4 1)) 1
;;           (2nd-largest (list 5 4 3 2 1)) 4
;;           (2nd-largest (list 1 2 3 4 5)) 4
;;           (2nd-largest (list 0 5)) 0
;;           (2nd-largest (list 1 1)) 1

;; Definition:
(define (2nd-largest alon)
  (local
    [ ;; Contract: remove-max: (listof num) (listof num) -> (listof num)
      ;; Purpose: To remove the largest number from the list given two same lists of numbers
      ;; Example: (remove-max (list 1 2 3 4 5) (list 1 2 3 4 5)) => (list 1 2 3 4)
     (define (remove-max list alist)
       (cond
         [(empty? list) empty]
         [(equal? (first list) (list-max-accum (rest alist) (first alist)))(remove-max (rest list) alist)]
         [else (cons (first list)(remove-max (rest list) alist))]))
      ;; Contract: list-max-accum: (listof num) num -> num
      ;; Purpose: To get the largest number from the list and given number
      ;; Examples: (list-max-accum (list 1 2 3 4 5) 1) => 5
      ;;           (list-max-accum (list 1 2 3 4 5) 7) => 7
     (define (list-max-accum l max-so-far)
       (cond
         [(empty? l) max-so-far]
         [else (list-max-accum (rest l)(max max-so-far (first l)))]))]
    (list-max-accum (remove-max alon alon) (min (first alon)(second alon)))))
      
;; Tests for 2nd-largest
(check-expect (2nd-largest (list 4 1)) 1)
(check-expect (2nd-largest (list 5 4 3 2 1)) 4)
(check-expect (2nd-largest (list 1 2 3 4 5)) 4)
(check-expect (2nd-largest (list 0 5)) 0)
(check-expect (2nd-largest (list 1 1)) 1)
(check-expect (2nd-largest (list 1 2 9 6 3 4)) 6)

