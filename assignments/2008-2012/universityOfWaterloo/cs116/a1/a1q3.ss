;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 1, Question 3
;; (all-reds)
;;
;; ***********************************************

;; structure defintiion: a card is a structure (make-card v a) where v is an integer in the range 1 to 10 and s is a symbol from the set containing 'hearts 'diamonds 'clubs and 'spades
(define-struct card (value suit))

;; Contract: all-reds: (listof card) -> (listof card)

;; Purpose: To produce a list of cards which is red suited given a list of card

;; Examples: (all-reds (list (make-card 1 'hearts)(make-card 2 'clubs)(make-card 3 'diamonds)(make-card 4 'spades))) => (list (make-card 1 'hearts) (make-card 3 'diamonds))
;;           (all-reds (list (make-card 1 'spades)(make-card 1 'clubs))) => empty
;;           (all-reds empty) => empty
;;           (all-reds (list (make-card 1 'hearts))) => (list (make-card 1 'hearts))

;; Definition:
(define (all-reds cardlist)
  (local 
    [(define (find-red card)
       (cond 
         [(or (equal? (card-suit card) 'diamonds) 
              (equal? (card-suit card) 'hearts))
          true]
         [else false]))] 
    (filter find-red cardlist)))

;; Tests for all-reds
(check-expect (all-reds (list (make-card 1 'hearts)(make-card 2 'clubs)(make-card 3 'diamonds)(make-card 4 'spades)))
              (list (make-card 1 'hearts) (make-card 3 'diamonds)))
(check-expect (all-reds (list (make-card 1 'spades)(make-card 1 'clubs))) empty)
(check-expect (all-reds empty) empty)
(check-expect (all-reds (list (make-card 1 'hearts))) (list (make-card 1 'hearts)))
