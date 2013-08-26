;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname a3q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 3, Question 1
;; (evens, odds, mergesort)
;;
;; ***********************************************

;; Contract: evens: (listof number) => (listof number)

;; Purpose: To returns only the elements at the even positions in a given list of numbers

;; Examples: (evens '(1 2 3 4 5 6 7 8 9 10)) => '(1 3 5 7 9)
;;           (evens '(0)) => empty
;;           (evens empty) => empty
;;           (evens '(1 3 5 7)) => '(1 3 5 7)
;;           (evens '(2 4 6 8) => empty

;; Definition:
(define (evens lst) 
  (cond
    [(empty? lst) empty]
    [else (filter odd? lst)]))

;; Tests for evens:
(check-expect (evens '(1 2 3 4 5 6 7 8 9 10)) '(1 3 5 7 9))
(check-expect (evens '(0)) empty)
(check-expect (evens empty) empty)
(check-expect (evens '(1 3 5 7)) '(1 3 5 7))
(check-expect (evens '(2 4 6 8)) empty)

;; Contract: odds: (listof number) => (listof number)

;; Purpose: To returns only the elements at the odd positions in a given list of numbers

;; Examples: (odds '(1 2 3 4 5 6 7 8 9 10)) => '(2 4 6 8 10)
;;           (odds '(0)) => (list 0)
;;           (odds empty) => empty
;;           (odds '(1 3 5 7)) => empty
;;           (odds '(2 4 6 8)) => '(2 4 6 8)

;; Definition:
(define (odds lst)
  (cond
    [(empty? lst) empty]
    [else (filter even? lst)]))

;; Tests for odds:
(check-expect (odds '(1 2 3 4 5 6 7 8 9 10)) '(2 4 6 8 10))
(check-expect (odds '(0)) (list 0))
(check-expect (odds empty) empty)
(check-expect (odds '(1 3 5 7)) empty)
(check-expect (odds '(2 4 6 8)) '(2 4 6 8))

;; Contract: mergesort: (listof number) => (listof num)

;; Purpose: Which takes a list of numbers, and divides it into two lists of roughly equal length of part(a) and merge together

;; Examples: (mergesort '(10 9 8 7 6 5 4 3 2 1)) => '(1 2 3 4 5 6 7 8 9 10)
;;           (mergesort empty) => empty
;;           (mergesort '(1 4 3 7 5 8 10) => (list 1 3 4 5 7 8 10)

;; Definition:
(define (mergesort lst)
  (cond
    [(empty? lst) empty]
    [else 
     (local
       [(define (merge lst)
          (cond
            [(empty? lst) empty]
            [else (append (cons (evens lst) empty) (cons (odds lst)empty))]))
        (define (quick-sort lst)
          (cond
            [(empty? lst) empty]
            [else 
             (local [ (define pivot (first lst))
                      (define less-than-pivot
                        (filter (lambda (x) (< x pivot)) lst))
                      (define more-than-pivot
                        (filter (lambda (x) (> x pivot)) lst))]
               (append (quick-sort less-than-pivot)
                       (list pivot)
                       (quick-sort more-than-pivot)))]))]
       (quick-sort (append (first (merge lst))(first (rest (merge lst))))))]))


;; Tests for mergesort:
(check-expect (mergesort '(10 9 8 7 6 5 4 3 2 1)) (list 1 2 3 4 5 6 7 8 9 10))
(check-expect (mergesort '(1 4 3 7 5 8 10)) (list 1 3 4 5 7 8 10))
(check-expect (mergesort empty) empty)

