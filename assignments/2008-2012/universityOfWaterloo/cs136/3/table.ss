#lang scheme
(provide make-table add remove search)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 3 Question 1
;; (add remove search)
;;
;; ***********************************************

;;Question 1

(define (make-table) (box empty))
(define table (make-table))

;; Purpose: 
;; To add new '(k v) into the table, if identical k exists before will be replaced by new one.

;; add: num num (box (listof (listof num))) -> (listof (listof num))

;; Examples:
;;(check-expect (add 1 2 table) (list (list 1 2)))
;;(check-expect (add 3 4 table) (list (list 3 4)(list 1 2)))
;;(check-expect (add 7 8 table) (list (list 7 8)(list 3 4)(list 1 2)))
;;(check-expect (add 1 5 table) (list (list 7 8)(list 3 4)(list 1 5)))


(define (add k v table)
  (local
    [(define (add1 k1 v1 accum t1)
       (cond
         [(empty? t1)(begin (set-box! table (cons (cons k1 (cons v1 empty))
                                                  (unbox table)))
                            (unbox table))]
         [(equal? k1 (first (first t1)))(begin (set-box! table (append (reverse accum)(list (list k1 v1))(rest t1)))
                                               (unbox table))]
         [else (begin (set! accum (cons (first t1) accum))
                      (add1 k1 v1 accum (rest t1)))]))]
    (add1 k v empty (unbox table))))

;; Purpose:
;; To remove the element from the list by the same key

;; remove: num (box (listof (listof num))) -> (listof (listof num))
;; Example:
;;(check-expect (remove 3 table) (list (list 7 8)(list 1 5)))


(define (remove k table)
  (local
    [(define (remove1 k1 accum t1)
       (cond
         [(empty? t1)(void)]
         [(equal? (first (first t1)) k1)(begin (set-box! table (append (reverse accum)(rest t1)))
                                                 (unbox table))]

         [else (begin (set! accum (cons (first t1) accum))
                      (remove1 k1 accum (rest t1)))]))]
    (remove1 k empty (unbox table))))

;; Purpose:
;; To find the value of the elements from the list by a key

;; search: num (box (listof (listof num))) -> (listof (listof num))
;; Example:
;;(check-expect (search 7 table) 8)
;;(check-expect (search 1 table) 5)


(define (search k table)
  (local
    [(define (search1 k1 t1)
       (cond
         [(empty? t1) empty]
         [(equal? k1 (first (first t1)))(second (first t1))]
         [else (search1 k1 (rest t1))]))]
    (search1 k (unbox table))))