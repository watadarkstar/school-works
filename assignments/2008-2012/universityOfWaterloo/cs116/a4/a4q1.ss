;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname a4q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 4, Question 1
;; (count-suits)
;;
;; ***********************************************

;; structure defintiion: a card is a structure (make-card v a) where v is an integer in the range 1 to 10 and s is a symbol from the set containing 'hearts 'diamonds 'clubs and 'spades
(define-struct card (value suit))

;; structure definition: a suit-count is a structure (make-suit-count h d c s), where h d c and s are all natural numbers
(define-struct suit-count (hearts diamonds clubs spades))

;; Contract: count-suits: (listof card) -> (suit-count)

;; Purpose: To calculate the number of the total suits given a list of cards

;; Examples: (count-suits (list (make-card 1 'hearts)(make-card 2 'diamonds)(make-card 3 'clubs)(make-card 4'spades))) => (make-suit-count 1 1 1 1)
;;           (count-suits (list (make-card 1 'hearts)(make-card 2 'hearts))) => (make-suit-count 2 0 0 0)
;;           (count-suits (list (make-card 1 'hearts))) => (make-suit-count 1 0 0 0)
;;           (count-suits (list (make-card 1 'diamonds))) => (make-suit-count 0 1 0 0)
;;           (count-suits (list (make-card 1 'clubs))) => (make-suit-count 0 0 1 0)
;;           (count-suits (list (make-card 1 'spades))) => (make-suit-count 0 0 0 1)
;;           (count-suits empty) => (make-suit-count 0 0 0 0))

;; Definition:
(define (count-suits cardlist)
  (local
    ;; Contract: count-suits-accum: (listof card) suit-count -> suit-count
    ;; Purpose: To calculate the number of the total suits given a list of cards
    ;; Example: (count-suits-accum (list (make-card 1 'hearts)(make-card 2 'hearts))) => (make-suit-count 2 0 0 0)
    [(define (count-suits-accum l suit-count-so-far)
       (cond
         [(empty? l) suit-count-so-far]
         [else (cond
                 [(equal? (card-suit (first l)) 'hearts)
                  (count-suits-accum (rest l) (make-suit-count (+ (suit-count-hearts suit-count-so-far) 1) 
                                                               (suit-count-diamonds suit-count-so-far)
                                                               (suit-count-clubs suit-count-so-far)
                                                               (suit-count-spades suit-count-so-far)))]
                 [(equal? (card-suit (first l)) 'diamonds)
                  (count-suits-accum (rest l) (make-suit-count (suit-count-hearts suit-count-so-far) 
                                                               (+ (suit-count-diamonds suit-count-so-far) 1)
                                                               (suit-count-clubs suit-count-so-far)
                                                               (suit-count-spades suit-count-so-far)))]
                 [(equal? (card-suit (first l)) 'clubs)
                  (count-suits-accum (rest l) (make-suit-count (suit-count-hearts suit-count-so-far) 
                                                               (suit-count-diamonds suit-count-so-far)
                                                               (+ (suit-count-clubs suit-count-so-far) 1)
                                                               (suit-count-spades suit-count-so-far)))]
                 [(equal? (card-suit (first l)) 'spades)
                  (count-suits-accum (rest l) (make-suit-count (suit-count-hearts suit-count-so-far) 
                                                               (suit-count-diamonds suit-count-so-far)
                                                               (suit-count-clubs suit-count-so-far)
                                                               (+ (suit-count-spades suit-count-so-far) 1)))])]))]
    (count-suits-accum cardlist (make-suit-count 0 0 0 0))))
  
;; Tests for count-suits:
(check-expect (count-suits (list (make-card 1 'hearts)(make-card 2 'diamonds)(make-card 3 'clubs)(make-card 4'spades))) (make-suit-count 1 1 1 1))
(check-expect (count-suits (list (make-card 1 'hearts)(make-card 2 'hearts)))(make-suit-count 2 0 0 0))
(check-expect (count-suits (list (make-card 1 'hearts))) (make-suit-count 1 0 0 0))
(check-expect (count-suits (list (make-card 1 'diamonds))) (make-suit-count 0 1 0 0))
(check-expect (count-suits (list (make-card 1 'clubs))) (make-suit-count 0 0 1 0))
(check-expect (count-suits (list (make-card 1 'spades))) (make-suit-count 0 0 0 1))
(check-expect (count-suits empty)(make-suit-count 0 0 0 0))
