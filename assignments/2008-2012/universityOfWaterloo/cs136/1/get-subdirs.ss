#lang scheme
(provide get-subdirs my-dir get-number binary num-of-zero add-zero-to-list all-together change-path)

(require test-engine/scheme-tests)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 1 Question 1
;; (get-subdirs)
;;
;; ***********************************************

;; Structure definition: a dir is a structure (make-dir n f sub1 sub2) where n is the name of the directory (Symbol), f is the list of files in the directory (List of symbol), sub1 and sub2 are the subdirectory (directory structure or empty).
(define-struct dir (name flst subdir1 subdir2))

;; For testing the function (get-subdirs)
(define my-dir (make-dir 'p (cons 'info.txt empty) 
                         (make-dir 'm1 empty 
                                   (make-dir 'b1 empty empty empty) 
                                   (make-dir 'b2 empty empty empty))
                         (make-dir 'm2 empty 
                                   empty 
                                   (make-dir 'b4 empty empty empty))))

;; Contract: get-subdirs: directory num -> (listof symbol)

;; Purpose: To return a list of names of all subdirectories at that depth

;; Examples: 
;;(check-expect(get-subdirs my-dir 0)'(p))        
;;(check-expect(get-subdirs my-dir 1)'(m1 m2))         
;;(check-expect(get-subdirs my-dir 2)'(b1 b2 b4))      
;;(check-expect(get-subdirs my-dir 4)'())

;; Definition:
(define (get-subdirs dtree depth)
  (change-path (all-together depth) dtree))


;; Helper functions:

;; get-number: num -> (listof number)
;; Purpose: To create a list of number from 1 to (2^n -1) while the directories are increasing at 2^n.
;; Examples:
;;(check-expect (get-number 0) empty)
;;(check-expect (get-number 2)'(1 2 3))
;;(check-expect (get-number 3)'(1 2 3 4 5 6 7))
;;(check-expect (get-number 4)'(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))

(define (get-number x)
  (local
    [(define (count-up n i)
      (cond
        [(equal? n i)(cons i empty)]
        [else (cons n (count-up (add1 n) i))]))
     (define (pow num1 num2)
       (cond
         [(> num2 0) (* num1 (pow num1 (- num2 1)))]
         [(= num2 0) 1]))]
    (rest (count-up 0 (- (pow 2 x)1)))))


;; binary: num -> (listof number)
;; Purpose: To convert a number in to binary numbers.
;; Examples:
;;(check-expect (binary 0) empty)
;;(check-expect (binary 2)'(1 0))
;;(check-expect (binary 9)'(1 0 0 1))
;;(check-expect (binary 33)'(1 0 0 0 0 1))
;;(check-expect (binary 59)'(1 1 1 0 1 1))
;;(check-expect (binary 75)'(1 0 0 1 0 1 1))

(define (binary num)
  (local
    [(define (binary-digit-list n)
       (cond
         [(zero? n) empty]
         [(even? n)(cons 0 (binary-digit-list (quotient n 2)))]
         [else (cons 1 (binary-digit-list (quotient n 2)))]))]
    (reverse (binary-digit-list num))))


;; num-of-zero: num -> (listof number)
;; Purpose: To create a list of number to put it in the front of every single list of binary numbers.
;; Example: 
;;(check-expect (num-of-zero 0) empty)
;;(check-expect (num-of-zero 3)'(0 0 0))
;;(check-expect (num-of-zero 4)'(0 0 0 0))

(define (num-of-zero num)
  (cond
    [(= 0 num) empty]
    [else (cons 0 (num-of-zero (sub1 num)))]))


;; add-zero-to-list: (listofnum) num -> (listof num)
;; Purpose: To fit in to the correct number of digits in front of the list of list of number
;; Examples:
;;(check-expect (add-zero-to-list empty 3) empty)
;;(check-expect (add-zero-to-list (list (list 1 2)) 3)'((0 1 2)))
;;(check-expect (add-zero-to-list (list (list 1 2)) 4)'((0 0 1 2)))
;;(check-expect (add-zero-to-list (list (list 1 3)(list 2 4)) 3)'((0 1 3)(0 2 4)))
;;(check-expect (add-zero-to-list (list (list 1)(list 1 2)(list 1 2 3)) 5)'((0 0 0 0 1) (0 0 0 1 2) (0 0 1 2 3)))

(define (add-zero-to-list alol num)
  (cond
    [(empty? alol) empty]
    [(equal? num (length (first alol))) (cons (first alol) (add-zero-to-list (rest alol) num))]
    [else (cons (append (num-of-zero (- num (length (first alol))))(first alol))(add-zero-to-list (rest alol) num))]))


;; all-together: num -> (listof num)
;; Purpose: To combine most of the helper function together to generate a list of all combination of 1 and 0 by inserting a digit of num.
;; Examples:
;;(check-expect (all-together 0)'(()))
;;(check-expect (all-together 1)'((0) (1)))
;;(check-expect (all-together 3)'((0 0 0) (1 0 0) (0 1 0) (1 1 0) (0 0 1) (1 0 1) (0 1 1) (1 1 1)))
;;(check-expect (all-together 4)'((0 0 0 0) (1 0 0 0) (0 1 0 0) (1 1 0 0) (0 0 1 0) (1 0 1 0) (0 1 1 0) (1 1 1 0) (0 0 0 1) (1 0 0 1) (0 1 0 1) (1 1 0 1) (0 0 1 1) (1 0 1 1) (0 1 1 1) (1 1 1 1)))

(define (all-together n)
  (map reverse (append (cons (num-of-zero n) empty)(add-zero-to-list (map binary (get-number n)) n))))


;; Change-path: (listof (listof num)) dir -> (union dir or empty)
;; Purpose: To create a structure path in order to get in to the directories and get dir-name.
;; Examples:
;;(check-expect (change-path '((0 0)) my-dir) '(b1))
;;(check-expect (change-path '((0 0)(1 0)) my-dir) '(b1 b2))

(define (change-path alol struct)
  (local
    [(define (change lst struct)
       (cond
         [(empty? lst) struct]
         [(empty? (change (rest lst) struct)) empty]
         [(= 0 (first lst))(dir-subdir1 (change (rest lst) struct))]
         [(= 1 (first lst))(dir-subdir2 (change (rest lst) struct))]))]
    (cond
      [(empty? alol) empty]
      [(empty? (change (first alol) struct)) (change-path (rest alol) struct)]
      [(empty? (dir-name (change (first alol) struct))) (change-path (rest alol) struct)]
      [else (cons (dir-name (change (first alol) struct)) (change-path (rest alol) struct))])))

