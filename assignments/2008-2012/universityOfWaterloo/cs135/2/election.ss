;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname election) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "htdp")))))
;;; Question 3a

;; Coaster: symbol->string

;; Purpose: to give the leader's name of the party

;; Example: (party->leader 'Bloc)=> "Gilles Duceppe"
;;          (party->leader 'Conservative)=> "Stephen Harper"

;; Definition:
(define (party->leader symbol)
  (cond
    [(symbol=? symbol 'Bloc) "Gilles Duceppe"]
    [(symbol=? symbol 'Conservative) "Stephen Harper"]
    [(symbol=? symbol 'Green) "Elizabeth May"]
    [(symbol=? symbol 'Liberal) "Stephane Dion"]
    [(symbol=? symbol 'NDP) "Jack Layton"]
    [else "Input Error"]))

;; Tests for party->leader
(check-expect (party->leader 'Bloc) "Gilles Duceppe")
(check-expect (party->leader 'Conservative) "Stephen Harper")

;;; Question 3b

;; Coaster: num num num num -> symbol

;; Purpose: To determine which party wins the most seats

;; Examples: (winner 10 20 18 5) => 'Green
;;           (winner 20 19 18 17) => 'Conservative

;; Definition:
(define (winner conservatives greens liberals ndp)
  (cond
    [(= conservatives greens) 'TIE]
    [(= greens liberals) 'TIE]
    [(= liberals ndp) 'TIE]
    [(= ndp conservatives) 'TIE]
    [(= conservatives liberals) 'TIE]
    [(= conservatives ndp) 'TIE]
    [(= greens ndp) 'TIE]
    [(and (> conservatives greens)(> conservatives liberals)(> conservatives ndp)) 'Conservative]
    [(and (> greens conservatives)(> greens liberals)(> greens ndp)) 'Green]
    [(and (> liberals conservatives)(> liberals greens)(> liberals ndp)) 'Liberal]
    [(and (> ndp conservatives)(> ndp greens)(> ndp liberals)) 'NDP]))

;;Tests for winner:
(check-expect (winner 10 20 18 5) 'Green)
(check-expect (winner 20 19 18 17) 'Conservative)


;;; Question 3c

;; Coaster: num num num num num -> symbol

;; Purpose: To determine which party wins the most seats

;; Examples: (winner2 17 29 48 20 10) => 'Green
;;           (winner2 30 18 27 19 10) => 'Bloc

;; Definition:
(define (winner2 bloc conservatives greens liberals ndp)
  (cond
    [(= bloc greens) 'TIE]
    [(= bloc conservatives) 'TIE]
    [(= bloc liberals) 'TIE]
    [(= bloc ndp) 'TIE]
    [(= conservatives greens) 'TIE]
    [(= greens liberals) 'TIE]
    [(= liberals ndp) 'TIE]
    [(= ndp conservatives) 'TIE]
    [(= conservatives liberals) 'TIE]
    [(= conservatives ndp) 'TIE]
    [(= greens ndp) 'TIE]
    [(and (> bloc greens)(> bloc liberals)(> bloc ndp)(> bloc conservatives)) 'Bloc]
    [(and (> conservatives greens)(> conservatives liberals)(> conservatives ndp)(> conservatives bloc)) 'Conservative]
    [(and (> greens conservatives)(> greens liberals)(> greens ndp)(> greens bloc)) 'Green]
    [(and (> liberals conservatives)(> liberals greens)(> liberals ndp)(> liberals bloc)) 'Liberal]
    [(and (> ndp conservatives)(> ndp greens)(> ndp liberals)(> ndp bloc)) 'NDP]))

;; Tests for the winner
(check-expect (winner2 17 29 48 20 10) 'Green)
(check-expect (winner2 30 17 28 14 10) 'Bloc)