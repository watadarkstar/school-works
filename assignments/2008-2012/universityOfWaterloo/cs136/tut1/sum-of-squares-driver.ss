#lang scheme
(require test-engine/scheme-tests)
(require "sum-of-squares.ss")

(check-expect (sum-of-squares 0 0) 0)
(check-expect (sum-of-squares 0 1) 1)
(check-expect (sum-of-squares 1 1) 2)
(test)