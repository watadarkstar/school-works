#lang scheme

(provide make-dir dir-name dir-flst dir-subdir1 dir-subdir2 ptree)

;;
;; ***********************************************
;;
;; Darren Poon
;; CS 136 F09 Assignment 2 Question 1
;; (ptree)
;;
;; ***********************************************

;; Directory structure definition  that was used in Assignment 1
(define-struct dir (name flst subdir1 subdir2)#:transparent)

;; An examples for (make-dir)
(define my-dir (make-dir 'usr (cons 'info.txt (cons 'test.txt empty))
                         (make-dir 'm1 empty
                                   (make-dir 'b1 empty empty empty)
                                   (make-dir 'b2 (cons 'file1.txt empty) empty empty))
                         (make-dir 'm2 empty
                                   empty
                                   (make-dir 'b4 empty empty empty))))

;; Program: ptree.ss

;; Purpose: To print out the root from the structue (make-dir) that have given

;; Example: (ptree my-dir) => 
;/usr
; info.txt
; test.txt
; /m1
;  /b1
;  /b2
;   file1.txt
; /m2
;  /b4


;; ptree: dir -> (void)

;; The function ptree
(define (ptree d)
  (local
    ;; print: dir num -> (void)
    ;; To print out the root from the structure (make-dir) that have given with an accumulated number of the indentation
    [(define (print d accum)
       (cond
         [(empty? d)(void)]
         ;usr
         [(and (not (empty? (dir-subdir1 d)))
               (not (empty? (dir-subdir2 d)))
               (not (empty? (dir-flst d)))) (begin (printf "/~a" (dir-name d))
                                            (set! accum (+ 1 accum))
                                            (printf (string-append "\n" (generate-empty accum)))
                                            (print-list (dir-flst d) accum)
                                            (print (dir-subdir1 d) accum)
                                            (print (dir-subdir2 d) accum))]
         ;m1
         [(and (not (empty? (dir-subdir1 d)))
               (not (empty? (dir-subdir2 d))))
                                            (begin (printf "/~a" (dir-name d))
                                            (set! accum (+ 1 accum))
                                            (printf (string-append "\n" (generate-empty accum)))
                                            (print-list (dir-flst d) accum)
                                            (print (dir-subdir1 d) accum)
                                            (print (dir-subdir2 d) accum))]
         ;b1 b4
         [(and (empty? (dir-subdir1 d))
               (empty? (dir-subdir2 d))
               (empty? (dir-flst d)))       (begin (printf "/~a" (dir-name d))                                            
                                            (printf (string-append "\n" (generate-empty accum))))]
         ;b2
         [(and (empty? (dir-subdir1 d))
               (empty? (dir-subdir2 d))
               (not (empty? (dir-flst d)))) (begin (printf "/~a" (dir-name d))            
                                            (set! accum (+ 1 accum))
                                            (printf (string-append "\n" (generate-empty accum)))
                                            (print-list (dir-flst d) accum))]
         ;m2
         [(and (empty? (dir-flst d))
               (or (not (empty? (dir-subdir1 d)))
                   (not (empty? (dir-subdir2 d)))))
                                            (begin (set! accum (- 2 accum))
                                            (printf "/~a" (dir-name d))
                                            (set! accum (+ 1 accum))
                                            (printf (string-append "\n" (generate-empty accum)))
                                            (print-list (dir-flst d) accum)
                                            (print (dir-subdir1 d) accum)
                                            (print (dir-subdir2 d) accum))]))]
    (print d 0)))


;; print-list: (listof symbol) num
;; To print the list of symbols from the tree (dir-flst) and #newline
(define (print-list lst accum)
  (cond
    [(empty? lst) void]
    [else (begin (printf "~a" (first lst))
                 (printf (string-append "\n" (generate-empty accum)))
                 (print-list (rest lst) accum))]))

;; generate-empty: num -> string
;; To produce a certain length of empty string for the indentation
(define (generate-empty num)
  (local
    [(define (g-e num list)
       (cond
         [(zero? num) list]
         [else (string-append " " (g-e (sub1 num) list))]))]
    (g-e num "")))

;; Tested with the following make-dir

;; *an empty (make-dir empty empty empty)
;; (nothing comes out which also (void))
;; (ptree (make-dir (cons '1 empty) empty empty)) => 
;; /a
;;  1
;; (ptree my-dir) =>
;/usr
; info.txt
; test.txt
; /m1
;  /b1
;  /b2
;   file1.txt
; /m2
;  /b4