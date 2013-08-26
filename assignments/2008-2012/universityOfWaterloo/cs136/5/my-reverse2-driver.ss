#lang scheme
(require test-engine/scheme-tests)
(require "my-reverse2.ss")

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 3
;; (my-reverse2-driver)
;;
;; ***********************************************

;; examples for my-reverse2
(check-expect(my-reverse2 empty) empty)
(check-expect(my-reverse2 (list 1)) (list 1))
(check-expect(my-reverse2 (list 1 2)) (list 2 1))
(check-expect(my-reverse2 (list 1 2 3 4 5)) (list 5 4 3 2 1))

;; Tests for my-reverse2
(check-expect(my-reverse2 empty) empty)
(check-expect(my-reverse2 (list 'a))(list 'a))
(check-expect(my-reverse2 (list 'a 'b))(list 'b 'a))
(check-expect(my-reverse2 (list 'a 'b 'c 'd))(list 'd 'c 'b 'a))
(check-expect(my-reverse2 (list 1 1))(list 1 1))
(check-expect(my-reverse2 (list 5 7 5))(list 5 7 5))
(check-expect(my-reverse2 (list "a"))(list "a"))
(check-expect(my-reverse2 (list "a" "b"))(list "b" "a"))

;; actually run tests and report results
(test)
