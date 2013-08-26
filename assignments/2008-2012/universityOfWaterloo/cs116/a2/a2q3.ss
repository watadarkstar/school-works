;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a2q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 2, Question 2
;; (can-we-top?)
;;
;; ***********************************************

;; structure defintiion: a card is a structure (make-card v a) where v is an integer in the range 1 to 10 and s is a symbol from the set containing 'hearts 'diamonds 'clubs and 'spades
(define-struct card (value suit))

;; Contract: can-we-top?: (listof card) card -> boolean

;; Purpose: To produce a true if there exists a card in hand whose value is higher than played, and false otherwise, given a list of card and a card.

;; Examples: (can-we-top? (list (make-card 5 'hearts)(make-card 7 'diamonds))(make-card 6 'spades)) => true
;;           (can-we-top? (list (make-card 2 'hearts))(make-card 2 'diamonds)) => false
;;           (can-we-top? (list (make-card 3 'diamonds)(make-card 4 'clubs))(make-card 8 'spades)) => false
;;           (can-we-top? (list (make-card 10 'hearts)(make-card 5 'clubs))(make-card 1 'diamonds)) => true

;; Definition:
(define (can-we-top? hand played)
  (cond
    [(empty? hand) false]
    [(> (card-value (first hand)) (card-value played)) true ]
    [else (can-we-top? (rest hand) played)]))

;; Tests for can-we-top?
(check-expect (can-we-top? (list (make-card 5 'hearts) (make-card 7 'diamonds))(make-card 6 'spades)) true)
(check-expect (can-we-top? (list (make-card 2 'hearts))(make-card 2 'diamonds)) false)
(check-expect (can-we-top? (list (make-card 3 'diamonds)(make-card 4 'clubs))(make-card 8 'spades)) false)
(check-expect (can-we-top? (list (make-card 10 'hearts)(make-card 5 'clubs))(make-card 1 'diamonds)) true)
