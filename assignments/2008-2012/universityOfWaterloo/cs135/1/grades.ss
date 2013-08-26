;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname grades) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #8(#t constructor repeating-decimal #f #t none #f ())))
(define (participation x)(* x 0.05))
(define (assignment y)(* y 0.2))
(define (midterm-1 z)(* z 0.1))
(define (midterm-2 w)(* w 0.2))
(define (final-exam a)(* a 0.45))
(define (final-CS135-grade x y z w a) (+ (participation x) (assignment y) (midterm-1 z) (midterm-2 w) (final-exam a)))
(define (final-exam-grade-needed-CS135 x y z w f) (* (/ (+ (participation x) (assignment y) (midterm-1 z) (midterm-2 w)) 45) 100))