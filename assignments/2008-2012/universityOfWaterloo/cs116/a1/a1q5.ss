;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 1, Question 5
;; (extend-nats)
;;
;; ***********************************************

;; Contract: extend-nats: (listof num) -> (listof string)

;; Purpose: To produce a list of string given a list of num

;; Examples: (extend-nats empty) => empty
;;           (extend-nats (list 0 0)) => (list empty empty)
;;           (extend-nats (list 2 0)) => (list (list "repeat" "repeat") empty)
;;           (extend-nats (list 1 2 3)) => (list (list "repeat") (list "repeat" "repeat") (list "repeat" "repeat" "repeat"))

;; Definition:
(define (extend-nats natlist)
  (local
    [(define (get-string num)
       (cond
         [(= num 1) (cons "repeat" empty)]
         [(= num 0) empty]
         [else (cons "repeat" (get-string (- num 1)))]))]
    (map get-string natlist)))

;; Tests for extend-nats:
(check-expect (extend-nats empty) empty)
(check-expect (extend-nats (list 0 0))(list empty empty))
(check-expect (extend-nats (list 2 0))(list (list "repeat" "repeat") empty))
(check-expect (extend-nats (list 1 2 3))(list (list "repeat") (list "repeat" "repeat") (list "repeat" "repeat" "repeat")))
  
