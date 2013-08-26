;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname a5q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;;
;; ***********************************************
;;
;; Darren Poon
;; CS116 Assignment 5, Question 4
;; (place, reset, find)
;;
;; ***********************************************

;; A sample structural definition
(define-struct entry (key visit something-else))

;; Question 4a)

;; Contract: place: entry (listof entry) -> (listof entry)

;; Purpose: Consumed list does not contain an entry structure with the same key as new-entry, produce the list with the same elements as the consumed list with new-entry added to the end of the list. If the consumed list does contain an entry structure with the same key as new-entry, mutate the visist field of that entry in the list to be zero but leave all entry elements in the list unchanged, and return this list.

;; Examples: (place empty empty) => (list empty)
;;           (place (make-entry 1 1 1) empty) => (list (make-entry 1 1 1))
;;           (place (make-entry 10 2 3) (list (make-entry 10 1 1))) => (list (make-entry 10 0 1))
;;           (place (make-entry 5 2 2)(list (make-entry 1 1 1))) => (list (make-entry 1 1 1)(make-entry 5 2 2))
;;           (place (make-entry 5 1 1)(list (make-entry 1 1 1)(make-entry 2 2 2)(make-entry 3 3 3)(make-entry 4 4 4))) => 
;;                  (list (make-entry 1 1 1)(make-entry 2 2 2)(make-entry 3 3 3)(make-entry 4 4 4)(make-entry 5 1 1))
;;           (place (make-entry 1 1 1)(list (make-entry 1 9 2)(make-entry 2 2 3)(make-entry 3 3 4)(make-entry 4 4 5))) => 
;;                  (list (make-entry 1 0 2)(make-entry 2 2 3)(make-entry 3 3 4)(make-entry 4 4 5))

;; Definition:
(define (place new-entry lst)
  (local
    [;; Contract: entry (listof entry) -> boolean
     ;; Purpose: To produce a boolean to see if the key are the same or not given a entry and a list of entry
     (define (same-key new-entry lst)
       (cond
         [(empty? lst) false]
         [(equal? (entry-key new-entry)
                  (entry-key (first lst))) true]
         [else (or false (same-key new-entry (rest lst)))]))
     ;; Contract: different-key: entry (listof entry) -> (void)
     ;; Purpose: To produce a void
     (define (different-key new-entry lst)
       (cond
         [(empty? lst) void]
         [(equal? (entry-key new-entry)
                  (entry-key (first lst)))
          (begin (set-entry-visit! (first lst) 0)(first lst))]
         [else (different-key new-entry (rest lst))]))]
    (cond
      [(not (same-key new-entry lst))(append lst (list new-entry))]
      [else (begin (different-key new-entry lst) lst)])))

;; Tests for place:
(check-expect (place empty empty)(list empty))
(check-expect (place (make-entry 1 1 1) empty)(list (make-entry 1 1 1)))
(check-expect (place (make-entry 10 2 3) (list (make-entry 10 1 1)))
              (list (make-entry 10 0 1)))
(check-expect (place (make-entry 5 2 2)(list (make-entry 1 1 1)))
              (list (make-entry 1 1 1)(make-entry 5 2 2)))
(check-expect (place (make-entry 5 1 1)(list (make-entry 1 1 1)(make-entry 2 2 2)(make-entry 3 3 3)(make-entry 4 4 4)))
              (list (make-entry 1 1 1)(make-entry 2 2 2)(make-entry 3 3 3)(make-entry 4 4 4)(make-entry 5 1 1)))
(check-expect (place (make-entry 1 1 1)(list (make-entry 1 9 2)(make-entry 2 2 3)(make-entry 3 3 4)(make-entry 4 4 5)))
              (list (make-entry 1 0 2)(make-entry 2 2 3)(make-entry 3 3 4)(make-entry 4 4 5)))

;; Question 4b)

;; Contract: reset: (listof entry) -> (void)

;; Purpose: consumes a list of entry structure and mutates all of the visit fields to be 0. This function should return (void)

;; Examples: (rest test) => (make-entry 1 0 1)

;; Definition:
(define (reset lst)
  (cond
    [(empty? lst) void]
    [else (begin (set-entry-visit! (first lst) 0)
                 (reset (rest lst)))]))

;; Tests for reset:
(define test (list (make-entry 1 1 1)))
(equal? (begin (reset test) test)
        (list (make-entry 1 0 1)))



;; Question 4c)

;; Contract: find: num (listof entry) -> num

;; Purpose: To produce 0 if there is no structure with the given integer as its key, or increments (by mutating) the visit field value for the structure in the list that has the given integer as its key, and returns this new visit value given a number and a list of entry

;; Examples:

;; Definition:
(define (find val lst)
  (local
    [(define (same-key num list)
       (cond[(empty? list) false]
            [(= (entry-key (first list)) num) true]
            [else (or false (same-key num (rest list)))]))
     (define (different-key num list)
       (cond
         [(empty? list) void]
         [(equal? (entry-key (first list)) num) 
          (begin (set-entry-visit! (first list)(add1 (entry-visit (first list))))
                 (entry-visit (first list)))]
         [else (different-key num (rest list))]))]
    (cond
      [(not (same-key val lst)) 0]
      [else (different-key val lst)])))

;; Tests for find:
(check-expect (find 1 empty) 0)
(check-expect (find 10 (list (make-entry 1 1 1))) 0)
(check-expect (find 1 (list (make-entry 1 1 1)(make-entry 2 2 2))) 2)
(check-expect (find 3 (list (make-entry 1 1 1)(make-entry 2 2 2)(make-entry 3 3 3)(make-entry 4 4 4))) 4)
