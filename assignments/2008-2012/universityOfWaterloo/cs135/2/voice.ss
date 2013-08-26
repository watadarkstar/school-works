;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname voice) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "htdp")))))
;;; Question 1

;; Coaster: image image image -> image

;; Purpose: To make a picture of voice of fire

;; Definition:
(define (left-most x) (rectangle x (* 5 x) 'solid 'red))
(define (middle x) (rectangle (* 3 x) (* 5 x) 'solid 'blue))
(define (right-most x) (rectangle x (* 5 x) 'solid 'red))

(define (voice-of-fire x)
  (overlay (left-most x) (middle x) (right-most x)))