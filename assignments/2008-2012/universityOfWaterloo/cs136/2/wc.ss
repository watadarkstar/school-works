#lang scheme

(provide wc)
;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 2 Question 2
;; (wc)
;;
;; ***********************************************

;; Program: wc.ss
;; To run on the coommand line:
;; mzscheme wc.ss < my-int.txt > my-output.txt

;; Purpose: To count the numbers of line, the numbers of letters , and the numbers of characters that i have input

;; Contract: wc: (void) -> (void)

;; Definition
(define (wc)
(begin (set! hwc (make-cons))
       (printf "~a ~a ~a" (count-line hwc)(count-letter hwc)(count-char hwc))))

;; This is a helper function to store the input into a list
(define hwc empty)

;; count: (listof characters) -> num
;; To count the number of elements that has contained in thhe list
(define (count lst)
       (cond
         [(empty? lst) 0]
         [else (+ 1 (count (rest lst)))]))

;; make-cons: (void) -> (listof characters)
;; To build a list of character that i have input
(define (make-cons)
  (local
      [(define nl (read-char))]
      (cond
        [(eof-object? nl) empty]
        [else (cons nl (make-cons))])))

;; count-car: (listof character) -> num
;; To count the numbers of character that have contained in the list
(define (count-char lst)
  (length lst))

;; count-line: (listof characters) -> num
;; To count the numbers of line that have contained in the list
(define (count-line lst)
  (cond
    [(empty? lst) 0]
    [(equal? #\newline (first lst)) (+ 1 (count-line (rest lst)))]
    [else (count-line (rest lst))]))

;; count-letter: (listof characters) -> num
;; To count the numbers of letter that have contained in the list
(define (count-letter lst)
  (local
    [(define (remove-space-newline lst)
       (cond
         [(empty? lst) empty]
         [(and (equal? (first lst) #\newline)
               (empty? (rest lst)))(cons #\newline empty)]
         [(and (equal? (first lst) #\space)
               (equal? (first (rest lst)) #\space))(remove-space-newline (rest lst))]
         [(and (equal? (first lst) #\newline)
               (equal? (first (rest lst)) #\newline))(remove-space-newline (rest lst))]
         [else (cons (first lst)(remove-space-newline (rest lst)))]))]
    (cond
      [(empty? (remove-space-newline lst)) 0]
      [(equal? #\space (first (remove-space-newline lst)))(+ 1 (count-letter (rest (remove-space-newline lst))))]
      [(equal? #\newline (first (remove-space-newline lst)))(+ 1 (count-letter (rest (remove-space-newline lst))))]
      [else (count-letter (rest lst))])))

;; This function application does all the work
(wc)

;; Tested with the following files:
;; *An empty file => 0 0 0
;; *a file with one alphabetic character => 1 1 2
;; *a file with one word character => 1 1 2
;; *a file with one word and a newline => 2 1 3
;; (e.g.
;; This is a line
;; count all.)
;; (this should produce 2 6 26)

