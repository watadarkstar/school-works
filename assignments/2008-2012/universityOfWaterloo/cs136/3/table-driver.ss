#lang scheme

(require test-engine/scheme-tests)
(require "table.ss")

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 3 Question 1
;; (add remove search)
;;
;; ***********************************************

;; table-driver
(define table (make-table))


;; examples for add and remove
;; (add 1 1 table) => ((1 1))
;; (add 2 3 table) => ((2 3) (1 1))
;; (add 1 5 table) => ((2 3) (1 5))
;; (add 0 -1 table) => ((0 -1) (2 3) (1 5))
;; (add 0 -30 table) => ((0 -30) (2 3) (1 5))
;; (remove 2 table) => ((0 -30) (1 5))
;; (remove 3 table) => ((0 -30) (1 5))

;; exampels for search
;; (search 1 table) => 5

;; tests for add and remove
(check-expect (add 1 2 table) (list (list 1 2)))
(check-expect (add 3 4 table) (list (list 3 4)(list 1 2)))
(check-expect (add 7 8 table) (list (list 7 8)(list 3 4)(list 1 2)))
(check-expect (add 1 5 table) (list (list 7 8)(list 3 4)(list 1 5)))
(check-expect (remove 3 table) (list (list 7 8)(list 1 5)))
(check-expect (search 7 table) 8)
(check-expect (search 3 table) empty)

;; actually run tests and report results
(test)

