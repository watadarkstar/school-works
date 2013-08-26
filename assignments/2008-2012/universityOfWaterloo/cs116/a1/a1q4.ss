;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 1, Question 4
;; (count-suits)
;;
;; ***********************************************

;; structure defintiion: a card is a structure (make-card v a) where v is an integer in the range 1 to 10 and s is a symbol from the set containing 'hearts 'diamonds 'clubs and 'spades
(define-struct card (value suit))

;; structure definition: a suit-count is a structure (make-suit-count h d c s), where h d c and s are all natural numbers
(define-struct suit-count (hearts diamonds clubs spades))

;; Contract: count-suits: (listof card) -> suit-count

;; Purpose: To produce a suit-count indicating the number of cards of each suit given a list of cards

;; Examples: (count-suits (list (make-card 1 'hearts)(make-card 2 'hearts))) => (make-suit-count 2 0 0 0)
;;           (count-suits (list (make-card 1 'diamonds))) => (make-suit-count 0 1 0 0)
;;           (count-suits (list (make-card 10 'clubs))) => (make-suit-count 0 0 1 0)
;;           (count-suits (list (make-card 5 'spades))) => (make-suit-count 0 0 0 1)
;;           (count-suits empty => (make-suit-count 0 0 0 0)


;; Definition:
(define (count-suits cardlist)
  (local
    [(define (find-num aloc suit-count)
       (cond 
         [(empty? aloc) suit-count]
         [else 
     (cond 
       [(equal? 'hearts (card-suit (first aloc))) 
        (find-num (rest aloc)
                  (make-suit-count (+ (suit-count-hearts suit-count) 1) 
                                   (+ (suit-count-diamonds suit-count) 0)
                                   (+ (suit-count-clubs suit-count) 0)
                                   (+ (suit-count-spades suit-count) 0)))]
       [(equal? 'diamonds (card-suit (first aloc))) 
        (find-num (rest aloc) 
                  (make-suit-count (+ (suit-count-hearts suit-count) 0)
                                   (+ (suit-count-diamonds suit-count) 1)
                                   (+ (suit-count-clubs suit-count) 0)
                                   (+ (suit-count-spades suit-count) 0)))]
       [(equal? 'clubs (card-suit (first aloc))) 
        (find-num (rest aloc)
                  (make-suit-count (+ (suit-count-hearts suit-count) 0) 
                                   (+ (suit-count-diamonds suit-count) 0)
                                   (+ (suit-count-clubs suit-count) 1)
                                   (+ (suit-count-spades suit-count) 0)))]
       [(equal? 'spades (card-suit (first aloc))) 
        (find-num (rest aloc)
                  (make-suit-count (+ (suit-count-hearts suit-count) 0) 
                                   (+ (suit-count-diamonds suit-count) 0)
                                   (+ (suit-count-clubs suit-count) 0)
                                   (+ (suit-count-spades suit-count) 1)))]
       )]))]
    (find-num cardlist (make-suit-count 0 0 0 0))))

;; Tests for count-suits:
(check-expect (count-suits (list (make-card 1 'hearts)(make-card 2 'hearts)))(make-suit-count 2 0 0 0))
(check-expect (count-suits (list (make-card 1 'diamonds)))(make-suit-count 0 1 0 0))
(check-expect (count-suits (list (make-card 10 'clubs)))(make-suit-count 0 0 1 0))
(check-expect (count-suits (list (make-card 5 'spades)))(make-suit-count 0 0 0 1))
(check-expect (count-suits empty)(make-suit-count 0 0 0 0))