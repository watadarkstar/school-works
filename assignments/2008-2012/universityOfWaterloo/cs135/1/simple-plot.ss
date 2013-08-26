;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname simple-plot) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp") (lib "graphing.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp") (lib "graphing.ss" "teachpack" "htdp")))))
(define (tenth-sq x)(* (* x (/ 1 10)) x))
(graph-fun tenth-sq 'blue)
(define (function y)(* 1 y))
(graph-fun function 'red)