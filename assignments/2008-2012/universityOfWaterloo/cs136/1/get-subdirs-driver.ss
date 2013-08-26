#lang scheme

(require test-engine/scheme-tests)
(require "get-subdirs.ss")

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 1 Question 1
;; (get-subdirs-driver)
;;
;; ***********************************************

;; examples for a1q1 
;; get-subdirs
(check-expect(get-subdirs my-dir 1)'(m1 m2))         
(check-expect(get-subdirs my-dir 2)'(b1 b2 b4))      
(check-expect(get-subdirs my-dir 4)'())

;; get-number (helper function)
(check-expect (get-number 2)'(1 2 3))
(check-expect (get-number 3)'(1 2 3 4 5 6 7))
(check-expect (get-number 4)'(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))

;; binary (helper function)
(check-expect (binary 2)'(1 0))
(check-expect (binary 9)'(1 0 0 1))
(check-expect (binary 33)'(1 0 0 0 0 1))
(check-expect (binary 59)'(1 1 1 0 1 1))
(check-expect (binary 75)'(1 0 0 1 0 1 1))

;; num-of-zero (helper function)
(check-expect (num-of-zero 3)'(0 0 0))
(check-expect (num-of-zero 4)'(0 0 0 0))

;; add-zero-to-list (helper function)
(check-expect (add-zero-to-list (list (list 1 2)) 3)'((0 1 2)))
(check-expect (add-zero-to-list (list (list 1 2)) 4)'((0 0 1 2)))
(check-expect (add-zero-to-list (list (list 1 3)(list 2 4)) 3)'((0 1 3)(0 2 4)))
(check-expect (add-zero-to-list (list (list 1)(list 1 2)(list 1 2 3)) 5)'((0 0 0 0 1) (0 0 0 1 2) (0 0 1 2 3)))

;; all-together (helper function)
(check-expect (all-together 1)'((0) (1)))
(check-expect (all-together 3)'((0 0 0) (1 0 0) (0 1 0) (1 1 0) (0 0 1) (1 0 1) (0 1 1) (1 1 1)))
(check-expect (all-together 4)'((0 0 0 0) (1 0 0 0) (0 1 0 0) (1 1 0 0) (0 0 1 0) (1 0 1 0) (0 1 1 0) (1 1 1 0) (0 0 0 1) (1 0 0 1) (0 1 0 1) (1 1 0 1) (0 0 1 1) (1 0 1 1) (0 1 1 1) (1 1 1 1)))

;; change-path (helper function)
(check-expect (change-path '((0 0)) my-dir) '(b1))
(check-expect (change-path '((0 0)(1 0)) my-dir) '(b1 b2))

;; tests for a1q1
;; get-subdirs (helper function)
(check-expect(get-subdirs my-dir 0)'(p))
(check-expect(get-subdirs my-dir 3)'())

;; get-number (helper function)
(check-expect (get-number 0) empty)
(check-expect (get-number 5)'(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31))
(check-expect (get-number 6)'(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63))

;; binary (helper function)
(check-expect (binary 0) empty)
(check-expect (binary 63)'(1 1 1 1 1 1))
(check-expect (binary 53)'(1 1 0 1 0 1))
(check-expect (binary 97)'(1 1 0 0 0 0 1))

;; num-of-zero (helper function)
(check-expect (num-of-zero 0) empty)
(check-expect (num-of-zero 2)'(0 0))
(check-expect (num-of-zero 5)'(0 0 0 0 0))
(check-expect (num-of-zero 7)'(0 0 0 0 0 0 0))

;; add-zero-to-list (helper function)
(check-expect (add-zero-to-list empty 3) empty)
(check-expect (add-zero-to-list (list (list 2)) 1)'((2)))
(check-expect (add-zero-to-list (list (list 4 7)(list 2 4)) 5)'((0 0 0 4 7) (0 0 0 2 4)))
(check-expect (add-zero-to-list (list (list 1)(list 9 2)(list 5 7)(list 1 2 3 6 8 2)) 6)'((0 0 0 0 0 1) (0 0 0 0 9 2) (0 0 0 0 5 7) (1 2 3 6 8 2)))

;; all-together (helper function)
(check-expect (all-together 0)'(()))
(check-expect (all-together 2)'((0 0) (1 0) (0 1) (1 1)))
(check-expect (all-together 5)'((0 0 0 0 0)(1 0 0 0 0)(0 1 0 0 0)(1 1 0 0 0)(0 0 1 0 0)(1 0 1 0 0)(0 1 1 0 0)(1 1 1 0 0)(0 0 0 1 0)(1 0 0 1 0)
                                (0 1 0 1 0)(1 1 0 1 0)(0 0 1 1 0)(1 0 1 1 0)(0 1 1 1 0)(1 1 1 1 0)(0 0 0 0 1)(1 0 0 0 1)(0 1 0 0 1)(1 1 0 0 1)
                                (0 0 1 0 1)(1 0 1 0 1)(0 1 1 0 1)(1 1 1 0 1)(0 0 0 1 1)(1 0 0 1 1)(0 1 0 1 1)(1 1 0 1 1)(0 0 1 1 1)(1 0 1 1 1)
                                (0 1 1 1 1)(1 1 1 1 1)))

;; change-path (helper function)
(check-expect (change-path '((1 1 0)) empty)'())
(check-expect (change-path '((0 0 1)) my-dir)'())
(check-expect (change-path '((0 0)(1 0)(1 1)) my-dir) '(b1 b2 b4))

;; actually runs test and reports results
(test)