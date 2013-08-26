#lang scheme

(define-struct tree (val left right))
(define (get-val root)
  (cond
    [(empty? root) empty]
    [else (append (get-val (tree-left root))
                  (get-val (tree-right root)))]))


;(provide make-dir dir-name dir-flst dir-subdir1 dir-subdir2 ptree)
(define-struct dir (name flst subdir1 subdir2)#:transparent)


(define my-dir (make-dir 'usr (cons 'info.txt (cons 'test.txt empty))
                         (make-dir 'm1 empty
                                   (make-dir 'b1 empty empty empty)
                                   (make-dir 'b2 (cons 'file1.txt empty) empty empty))
                         (make-dir 'm2 empty
                                   empty
                                   (make-dir 'b4 empty empty empty))))



;; Directory structure definition  that was used in Assignment 1
; Remember to include the contract and purpose in your documentation


;; The function ptree


(define (ptree d)
  (local
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
               (empty? (dir-flst d))) (begin (printf "/~a" (dir-name d))                                            
                                            (printf (string-append "\n" (generate-empty accum)))
                                            )]
         ;b2
         [(and (empty? (dir-subdir1 d))
               (empty? (dir-subdir2 d))
               (not (empty? (dir-flst d)))) (begin (printf "/~a" (dir-name d))            
                                            (set! accum (+ 1 accum))
                                            (printf (string-append "\n" (generate-empty accum)))
                                            (print-list (dir-flst d) accum)
                                            
                                            )]
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

(define (print-list lst accum)
  (cond
    [(empty? lst) void]
    [else (begin (printf "~a" (first lst))
                 (printf (string-append "\n" (generate-empty accum)))
                 (print-list (rest lst) accum))]))

(define (generate-empty num)
  (local
    [(define (g-e num list)
       (cond
         [(zero? num) list]
         [else (string-append " " (g-e (sub1 num) list))]))]
    (g-e num "")))
    