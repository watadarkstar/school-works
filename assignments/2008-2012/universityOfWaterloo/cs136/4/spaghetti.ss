#lang scheme

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 3
;; (Spaghetti)
;;
;; ***********************************************

;; Purpose: To form a cons structure by substitution among a to f

(define a (cons 1 empty))
(define b (cons 2 a))
(define c (cons 3 b))
(define d (cons c b))
(define f (cons 4 d))

(define Spaghetti (cons f d))
