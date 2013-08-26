;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname wave) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp") (lib "graphing.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp") (lib "graphing.ss" "teachpack" "htdp")))))
(define (blu x)(+ (sin x)1))
(graph-fun blu 'blue)
(define (ora y)(+ (* (sin y)-1) 1))
(graph-fun ora 'orange)
(define (re w)(+ (cos w)1))
(graph-fun re 'red)
(define (bla z)(+(* (cos z) -1)1))
(graph-fun bla 'black)