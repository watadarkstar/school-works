;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname mm) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "htdp")))))
;;; Question 2

;; Coaster: image image image -> image

;; Purpose: Make a picture of mickey mouse by inserting radius and colour

;; Definition:
(define (ear-left x colour) (circle (/ x 2) 'solid colour))
(define (ear-right x colour) (circle (/ x 2) 'solid colour))
(define (face x colour) (circle x 'solid colour))
(define (mickey-mouse x colour)
   (overlay (move-pinhole (ear-left x colour) (* -1 x) x) (move-pinhole (ear-right x colour) x x) (face x colour)))