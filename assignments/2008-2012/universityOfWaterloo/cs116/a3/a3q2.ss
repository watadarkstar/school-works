;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname a3q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 3, Question 2
;; (kth-largest)
;;
;; ***********************************************

;; Contract: kth-largest: num (listof number) => num

;; Purpose: To produce the kth largest element from a non-empty list of distinct numbers, given k and a non-empty list of numbers

;; Examples: (kth-largest 3 '(1 10 2)) => 1
;;           (kth-largest 1 '(1 10 2)) => 10

;; Definition:
(define (kth-largest k lst)
  (local
    ;; Contract: new-sort-list: (listof number) => (listof number)
    ;; Purpose: To create a new list by descending order given a list of number
    ;; Examples: (new-sort-list '(1 5 2 9 7 10 4)) => (list 10 9 7 5 4 2 1)
    ;;           (new-sort-list '(1 1 1) => (list 1)
    ;;           (new-sort-lsit empty) => empty
    [(define (new-sort-list alist)
       (cond
         [(empty? alist) empty]
         [else (local
                 [(define pivot (first alist))]
                 (append (new-sort-list (filter (lambda (x) (> x pivot)) alist))
                         (cons pivot empty)
                         (new-sort-list (filter (lambda (x) (< x pivot)) alist))))]))]
    (cond
      [(equal? k 1)(first (new-sort-list lst))]
      [else (kth-largest (sub1 k)(rest (new-sort-list lst)))])))
  
;; Tests for kth-largest
(check-expect (kth-largest 3 '(1 10 2)) 1)
(check-expect (kth-largest 1 '(1 10 2)) 10)
(check-expect (kth-largest 2 '(1 10 2)) 2)


