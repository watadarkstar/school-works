;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a4q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 4, Question 3
;; (rev-num)
;;
;; ***********************************************

;; Contract: num {> 0} -> num

;; Purpose: To produce a number consisting of the digits of n in reverse given a positive number

;; Examples: (rev-num 12345) 54321)
;;           (rev-num 12342) 24321)
;;           (rev-num 54321) 12345)
;;           (rev-num 0) 0)
;;           (rev-num 1) 1)

;; Definition:
(define (rev-num n)
  (local
    [;; Contract: rev-num-acc: num num -> num
     ;; Purpose: To produce a number which is reverse
     ;; Example: (rev-num-acc 12345 0) => 54321
     (define (rev-num-acc num acc)
       (cond
         [(< num 1) acc]
         [else (rev-num-acc (/ (- num (remainder num 10)) 10)
                            (+ (* 10 acc) (remainder num 10)))]))]
    (rev-num-acc n 0)))

; Tests for rev-num:
(check-expect (rev-num 12345) 54321)
(check-expect (rev-num 12342) 24321)
(check-expect (rev-num 54321) 12345)
(check-expect (rev-num 0) 0)
(check-expect (rev-num 1) 1)
