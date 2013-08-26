;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname temp) (read-case-sensitive #t) (teachpacks ((lib "convert.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "convert.ss" "teachpack" "htdp")))))
(define (Fahrenheit->Celsius x) (/(*(- x 32) 5) 9))
(convert-gui Fahrenheit->Celsius)
(convert-repl Fahrenheit->Celsius)
(define (Celsius->Fahrenheit x) (+ (/ (* x 9) 5) 32))
(define (I f)
  (Celsius->Fahrenheit (Fahrenheit->Celsius f)))
;; The value of I remain unchanged because the number f convert from Fahrenheit to Celsius but then convert back to Fahrenheit.