#lang scheme
(provide sum-of-squares)

(define (sum-of-squares num1 num2)
  (+ (* num1 num1)(* num2 num2)))
