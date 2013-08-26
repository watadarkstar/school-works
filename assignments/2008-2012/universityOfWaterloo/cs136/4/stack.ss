#lang scheme
(provide make-stack push pop top stack-empty? content)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 4 Question 2
;; (stack)
;;
;; ***********************************************

;; To define an empty stack
(define (make-stack)
  (box empty))

;; To mutate a new stack which a number e in front of the stack
;; push: num (box (listof num)) -> (box (listof num))
(define (push e stk)
  (local
    [(define (push1 e1 stk1)
       (set-box! stk (cons e1 stk1)))]
    (push1 e (unbox stk))))

;; To mutate a new stack which the first number in the stack is removed
;; pop: (box (listof num)) -> (box (listof num))
(define (pop stk)
  (local
    [(define (pop1 stk1)
       (cond
         [(empty? stk1) empty]
         [else (begin (set-box! stk (rest stk1))
                      (first stk1))]))]
    (pop1 (unbox stk))))
     
;; To produce the value of the first element in the list
;; top (box (listof num)) -> num
(define (top stk)
  (local
    [(define (top1 stk1)
       (cond
         [(empty? stk1) empty]
         [else (first stk1)]))]
    (top1 (unbox stk))))

;; To determine the stk is empty or not
;; (box (listof num)) -> boolean
(define (stack-empty? stk)
  (local
    [(define (s-empty? stk1)
       (cond
         [(empty? stk1) true]
         [else false]))]
    (s-empty? (unbox stk))))

;; To display the content of the stk
;; (box (listof num)) -> (listof num)
(define (content stk)
  (unbox stk))
