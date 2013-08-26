#lang scheme

(provide remove-remarks)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 2 Question 3
;; (remove-remarks)
;;
;; ***********************************************

;; Program:remove-remarks.ss
;; To run on the command line:
;; mzscheme remove-remarks.ss < my-input.txt > my-output.txt

;; Purpose: To print a new version of input where all parenthetical remarks including the inputs between the parenthetical remarks are removed.

;; Contract: remomve-remarks: (void) -> (void)

;; Definition:
(define (remove-remarks)
  (printf "~a\n" (list->string (remove-space-newline (print (cons-remarks))))))

;; remove-space-newline: list -> list
;; To remove all duplicated #\spaces and #\newlines

(define (remove-space-newline lst)
       (cond
         [(empty? lst) empty]
         [(and (equal? (first lst) #\newline)
               (empty? (rest lst)))(cons #\newline empty)]
         [(and (equal? (first lst) #\space)
               (equal? (first (rest lst)) #\space))(remove-space-newline (rest lst))]
         [(and (equal? (first lst) #\newline)
               (equal? (first (rest lst)) #\newline))(remove-space-newline (rest lst))]
         [else (cons (first lst)(remove-space-newline (rest lst)))]))

;; cons-remarks: (void) -> (listof characters)
;; To build a list with elements of each characters that i have input

(define (cons-remarks)
  (local
    [(define nl (read-char))]
    (cond
      [(eof-object? nl) empty]
      [else (cons nl (cons-remarks))])))

;; remove: (listof characters) -> (listof characters)
;; To remove the elements of the list end with the #\) (the parenthetical remarks)

(define (remove lst)
  (cond
    [(empty? lst) empty]
    [(equal? #\)(first lst))(print (rest (rest lst)))]
    [else (remove (rest lst))]))

;; print: (list-of character) -> (listof characters)
;; To remove the elements of the list begin with the #\( (the parenthetical remarks)
(define (print lst)
  (local
    [(define (r-print lst)
       (cond
         [(empty? lst) empty]
         [(empty? (rest lst)) empty]
         [(and (equal? (first lst)(first (rest lst)))
               (equal? (first lst) #\space))(r-print (rest lst))]
         [(equal? #\( (first lst))(remove lst)]
         [else (cons (first lst)(r-print (rest lst)))]))]
    (r-print lst)))

;; This function application does all the work
(remove-remarks)

;; Tested with the following files:

;; *An empty file (no characters)
;; *A file with one alphabetic character
;; *A file with one newline character
;; *A file with one word
;; *A file with one word and a newline
;; (the previous five files have output identical to input)
;; *A file with several newlines and nothing else
;; (it will remove the duplicated newlines)
;; *A file with several spaces and nothing else
;; (it will remove the duplicated spaces)
;; *A file with two words seperated by two newlines
;; *A file with several words and a newline
;; (the previous two files have output identical to input)
;; *A file with words and parenthetical remark
;; (the text between the parenthetical remarks will be removed)
;; *A file with parenthetical remark
;; (nothing comes out)
;; *A file with several parenthetical remarks and words
;; (the text between the outermost parenthetical remarks including the words will be removed)
