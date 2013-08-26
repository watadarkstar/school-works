;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a3q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 3, Question 4
;; (find-without-overlap)
;;
;; ***********************************************

;; Contract: find-without-overlap: (listof symbol) (listof symbol) => (listof symbol)

;; Purpose: Finds the number of occurrences of a given pattern of symbols in a list of symbols, without any overlap in the patterns

;; Examples: (find-without-overlap '(a b a) '(a b a b a a b a)) => 2
;;           (find-without-overlap '(a a) '(a a a a a a)) => 3
;;           (find-without-overlap '(a a) empty) => 0
;;           (find-without-overlap empty empty) => 0

;; Definition:
(define (find-without-overlap pat lst)
  (local
    ;; Contract: find-num: (listof symbol) => num
    ;; Purpose: To find how many elements that is contain in the list given a list of symbols
    ;; Examples: (find-num '(a a a a a a)) => 6
    ;;           (find-num empty) => 0
    [(define (find-num list)
       (cond
         [(empty? list) 0]
         [(symbol? (first list))(+ 1 (find-num (rest list)))]
         [else (+ 0 (find-num (rest list)))]))
     ;; Contract: find-list: num (listof symbol) => (listof symbol)
     ;; Purpose: To find the first few numbers of the list to become a new list given number and a list of symbols
     ;; Examples: (find-list 3 '(a a a a a a)) => '(a a a)
     ;;           (find-list 0 '(a a a a a a)) => empty
     ;;           (find-list 2 empty) => empty
     (define (find-list num alist)
       (cond
         [(empty? alist) empty]
         [(zero? num) empty]
         [else (cons (first alist)(find-list (sub1 num)(rest alist)))]))
     ;; Contract: remove-list: num (listof symbol) => (listof symbol)
     ;; Purpose: To remove the first few elements from the list given a number and a symbol
     ;; Examples: (remove-list 3 '(a b a b a a b a)) => '(b a a b a)
     ;;           (remove-list 1 '(a b c d e f)) => '(b c d e f)
     ;;           (remove-list 0 '(a b c d e f)) => '(a b c d e f)
     ;;           (remove-list 2 empty) => empty
     (define (remove-list num alist)
       (cond
         [(zero? num) alist]
         [(empty? alist) empty]
         [else (rest (remove-list (sub1 num) alist))]))]
    (cond
      [(empty? lst) 0]
      [(> (find-num pat)(find-num lst)) 0]
      [(equal? pat (find-list (find-num pat) lst))(+ 1 (find-without-overlap pat (remove-list (find-num pat) lst)))]
      [else (+ 0 (find-without-overlap pat (rest lst)))])))

;; Tests for find-without-overlap
(check-expect (find-without-overlap '(a b a) '(a b a b a a b a)) 2)
(check-expect (find-without-overlap '(a a) '(a a a a a a)) 3)
(check-expect (find-without-overlap '(a a) empty) 0)
(check-expect (find-without-overlap empty empty) 0)