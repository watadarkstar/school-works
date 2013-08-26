;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname a5q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 5, Question 1
;; (first-world)
;;
;; ***********************************************

;; State variables:
(define a (void))
(define b (void))
(define c (void))
(define d (void))
(define f (void))

;; 1a)

;; Contract: first-world: (void) -> (void)

;; Purpose: To return (void)

;; Effects: To convert defined variables to another form

;; Examples: The examples are shown on the table 1a
;;           (first-world) => a, b, c, d, f will turn into 11, 'a, (make-posn 10 14), (make-posn 10 14), (make-posn 10 14) respectively

;; Definition:
(define (first-world)
  (begin (set! a 11)
         (set! b 'a)
         (set! c (make-posn 10 14))
         (set! d c)
         (set! f (make-posn 10 14))))

;; Tests for first-world:
(begin (first-world)
       (and (equal? a 11)
            (equal? b 'a)
            (equal? c (make-posn 10 14))
            (equal? d c)
            (equal? f (make-posn 10 14))))

;; 1b)

;; Contract: second-world: (void) -> (void)

;; Purpose: To return (void)

;; Effects: To convert defined variables from 1a to 1b

;; Examples: The examples are shown on the table 1b
;;          (second-world) => a, b, c, d, f will turn into 11, 'a, (make-posn 16 30), (make-posn 16 30), (make-posn 10 14) respectively

;; Definition:
(define (second-world)
  (begin (set-posn-x! c 16)
         (set-posn-y! c 30)))

;; Tests for second-world:
(begin (second-world)
       (and (equal? a 11)
            (equal? b 'a)
            (equal? c (make-posn 16 30))
            (equal? d (make-posn 16 30))
            (equal? c d)
            (equal? f (make-posn 10 14))))

;; 1c)

;; Contract: third-world: (void) -> (void)

;; Purpose: To return (void)

;; Effects: To convert defined variables from 1b to 1c

;; Examples: The examples are shown on the table 1c
;;           (third-world) => (a 2), (b 4), c, d, f will turn into 5, 13, (make-posn 16 (make-posn 10 14)), (make-posn 16 (make-posn 10 14)), (make-posn 16 (make-posn 10 14)) respectively

;; Definition:
(define (third-world)
  (begin (set! a (lambda (x) (+ 3 x)))
         (set! b (lambda (x) (+ (a 3)(a x))))
         (set-posn-y! c f)
         (set! d c)
         (set! f c)))

;; Tests for third-world:
(begin (third-world)
       (and (equal? (a 2) 5)
            (equal? (b 4) 13)
            (equal? c (make-posn 16 (make-posn 10 14)))
            (equal? d c)
            (equal? f c)))