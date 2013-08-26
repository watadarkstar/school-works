;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname grades) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "htdp")))))
;;; Question 4a

;; Coaster: num num num num num -> num

;; Purpose: To calculate to final grade of CS

;; Example: (final-CS135-grade 80 72 75 78 77) => 76.15
(define (participation parti) (* parti 0.05))
(define (assignment assn) (* assn 0.2))
(define (midterm-1 mid1) (* mid1 0.1))
(define (midterm-2 mid2) (* mid2 0.2))
(define (final-exam final) (* final 0.45))
(define (avg-exam mid1 mid2 final)(*(/ (+ (midterm-1 mid1)(midterm-2 mid2)(final-exam final))75)100))


(define (final-CS135-grade parti assn mid1 mid2 final)
  (cond
    [(< (avg-exam mid1 mid2 final) 50) 46]
    [(< assn 46) 46]
    [else (+ (participation parti)(assignment assn)(* (avg-exam mid1 mid2 final) 0.75))]))

;; Tests for final-CS135-grade
(check-expect (final-CS135-grade 80 72 75 78 77) 76.15)
(check-expect (final-CS135-grade 90 10 80 90 85) 46)

;;; Question 4b

;; Coaster: num num -> num

;; Purpose: Calculate the result of the iClicker score by a particular student

;; Examples: (clicker-marks 40 0) => 5
;;           (clicker-marks 18 15)=> 4.25

;; Definition:
(define (clicker correct incorrect)(/ (* (/ (+ (* incorrect 1)(* correct 2)) 80) 100) 75))
(define (clicker-marks correct incorrect)
  (cond
    [(> (clicker correct incorrect) 1) 5]
    [else (* (clicker correct incorrect) 5)]))

;; Tests for clicker-marks
(check-expect (clicker-marks 40 0) 5)
(check-expect (clicker-marks 0 30) 2.5)
(check-expect (clicker-marks 18 15) 4.25)