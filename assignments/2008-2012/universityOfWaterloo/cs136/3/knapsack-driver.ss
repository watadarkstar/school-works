#lang scheme

;; knapsack-memo driver
(require test-engine/scheme-tests)
(require "knapsack.ss")

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 3 Question 2
;; (knapsack)
;;
;; ***********************************************

;; examples for knapsack
(check-expect (knapsack (list (list 5 10) (list 4 40) (list 6 30) (list 3 50)) 10) 90)
(check-expect (knapsack (list (list 2 3) (list 3 4) (list 4 5) (list 5 6)) 5) 7)

;; tests for knapsack
(check-expect (knapsack (list (list 5 10) (list 4 40) (list 6 30) (list 3 50)) 100) 130)
(check-expect (knapsack empty 10) 0)
(check-expect (knapsack (list (list 5 10) (list 4 40) (list 6 30) (list 3 50)) 0) 0)
(check-expect (knapsack (list (list 2 3) (list 7 4) (list 4 5) (list 5 6)) 5) 2)
(check-expect (knapsack (list (list 60 10) (list 15 70) (list 30 90) (list 22 40)) 50) 160)
(check-expect (knapsack (list (list 2 2) (list 3 4) (list 4 5) (list 5 6)) 9) 11)
;; actually run tests and report results
(test)
