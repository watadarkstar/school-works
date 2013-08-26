#lang scheme

(require test-engine/scheme-tests)
(require "stack.ss")

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 2
;; (stack)
;;
;; ***********************************************


;; examples for stack
;;(let ((ms (make-stack)))(stack-empty? ms) (push 1 ms) (push 2 ms) (top ms) (pop ms)(content ms)) => (list 1)
;; (stack-empty? (make-stack)) => true
;; (stack-empty? (box (list 1 empty))) => false
;; (push 5 (make-stack)) => void
;; (pop (box (list 1 2 3))) => 1
;; (top (box (list 3 2 1))) => 3
;; (content (box (list 4 2 empty))) => (list 4 2 empty)

;; Tests for stack
(define ms (make-stack))
(check-expect (stack-empty? ms) #t)
(check-expect (push 1 ms) (void))
(check-expect (push 2 ms) (void))
(check-expect (top ms) 2)
(check-expect (pop ms) 2)
(check-expect (let ((ms (make-stack))) 
                (stack-empty? ms) 
                (push 1 ms) 
                (push 2 ms) 
                (top ms) 
                (pop ms)
                (content ms)) (list 1))

;; actually run tests and report results
(test)

