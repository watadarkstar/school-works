#lang scheme
(define (copyinput)
  (let ((i (read)))
    (cond
      ((eof-object? i) '())
      (#t (display i)
          (display "\n")
          (copyinput)
          ))))
(void (copyinput))
