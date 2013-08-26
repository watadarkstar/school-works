;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname geometry) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Question 3a

;; line: posn num -> line

;; Data definition: a line is a structure (make-line point slope) where point is a posn, and the slope is a number
(define-struct line (point slope))

;; Question 3b

;; points->line: posn posn -> line

;; Purpose: to create a line by 2 points

;; Examples: (points->line (make-posn 3 6)(make-posn 6 2) => (make-line (make-posn 3 6)-1.3)
;;           (points->line (make-posn 7 8)(make-posn 7 21) => (make-line (make-posn 7 8) 'vertical)

;; Definition:
(define (points->line point1 point2)
  (make-line point1 
             (cond
               [(and (= (posn-x point1)(posn-x point2))
                     (= (posn-y point1)(posn-y point2))) 
                (error 'points->line "bad things happened")]
               [(= (- (posn-x point2)
                      (posn-x point1)) 0) 'vertical]                            
               [else (/ (- (posn-y point2)(posn-y point1))
                        (- (posn-x point2)(posn-x point1)))])))


;; Tests for points->line
(check-expect (points->line (make-posn 6 2)(make-posn 6 8)) (make-line (make-posn 6 2) 'vertical))
(check-expect (points->line (make-posn 8 3)(make-posn 9 4)) (make-line (make-posn 8 3) 1))
(check-error (points->line (make-posn 3 5)(make-posn 3 5)) "points->line: bad things happened")

;; Question 3c

;; parallel? : line line -> boolean

;; Purpose: to see both lines are parallel or not

;; Example: (parallel? (make-line (make-posn 4 1)5)(make-line (make-posn 9 4)5)) => true
;;          (parallel? (make-line (make-posn 9 4)9)(make-line (make-posn 4 4)5)) => false

;; Definition:
(define (parallel? line1 line2)
  (cond
    [(and (symbol? (line-slope line1))
          (symbol? (line-slope line2))) true]
    [(= (line-slope line1)
        (line-slope line2)) true]
    [else false]))

;; Tests for parallel?
(check-expect (parallel? (make-line (make-posn 8 3)1)(make-line (make-posn 9 2)1)) true)
(check-expect (parallel? (make-line (make-posn 4 8)6)(make-line (make-posn 9 8)2)) false)

;; perpendicular? : line line -> boolean

;; Purpose: to see both lines are perpendicular or not

;; Example:(perpendicular? (make-line (make-posn 9 4)9)(make-line (make-posn 4 4)5))=> false

;; Definition:
(define (perpendicular? line1 line2)
  (cond
    [(and (symbol? (line-slope line1))
          (= (line-slope line2) 0)) true]
    [ (= (* (line-slope line1)
            (line-slope line2)) -1) true]
    [else false]))

;; Tests for perpendicular?
(check-expect (perpendicular? (make-line (make-posn 7 8)-0.6)(make-line (make-posn 4 9)6)) false)
(check-expect (perpendicular? (make-line (make-posn 5 2)5)(make-line (make-posn 8 1) -0.2)) true)


;; Question 3d

;; quad: posn posn posn posn -> quad

;; Data definition: a quad is a structure (make-quad point1 point2 point3 point4) where point1, point2, point3 and point4 are posn
(define-struct quad (point1 point2 point3 point4))

;; Purpose: These are helper function to calculate the distance and slope between two points

(define (distance point1 point2)
  (sqrt (+ (sqr (- (posn-x point1)(posn-x point2)))
           (sqr (- (posn-y point1)(posn-y point2))))))

(define (slope point1 point2)
    (cond
      [(= (- (posn-x point2)
             (posn-x point1)) 0) 'vertical]
      [else (/ (- (posn-y point2)(posn-y point1))
               (- (posn-x point2)(posn-x point1)))]))

;; Question 3e 

;; classify: quad -> symbol

;; Purpose: To classify what shape it is by quad

;; Example: (classify (make-quad (make-posn 2 2)(make-posn 3 5)(make-posn 9 3)(make-posn 8 0))) => rectangle

;; Definition:
(define (classify quad)
  (cond
    ;; square
    [(= (distance (quad-point1 quad)(quad-point2 quad))
        (distance (quad-point2 quad)(quad-point3 quad))
        (distance (quad-point3 quad)(quad-point4 quad))
        (distance (quad-point4 quad)(quad-point1 quad))) 'square]
    ;; rectangle
    [(and (= (distance (quad-point1 quad)(quad-point2 quad))
             (distance (quad-point3 quad)(quad-point4 quad))) 
(perpendicular?  (points->line (quad-point1 quad)(quad-point2 quad))
                 (points->line (quad-point2 quad)(quad-point3 quad)))) 'rectangle]
    [(and (= (distance (quad-point3 quad)(quad-point4 quad))
             (distance (quad-point4 quad)(quad-point1 quad))) 
(perpendicular?  (points->line (quad-point3 quad)(quad-point4 quad))
                 (points->line (quad-point4 quad)(quad-point1 quad)))) 'rectangle]
    [(and (= (distance (quad-point1 quad)(quad-point2 quad))
             (distance (quad-point3 quad)(quad-point4 quad))) 
          (= (* (slope (quad-point1 quad)(quad-point2 quad))
                (slope (quad-point2 quad)(quad-point3 quad)))  -1)) 'rectangle]
    [(and (= (distance (quad-point3 quad)(quad-point4 quad))
             (distance (quad-point4 quad)(quad-point1 quad)))
          (= (* (slope (quad-point3 quad)(quad-point4 quad))
                (slope (quad-point4 quad)(quad-point1 quad)))  -1)) 'rectangle]
    ;; parallelogram 
    [(and (parallel? (points->line (quad-point1 quad)(quad-point2 quad))
                     (points->line (quad-point3 quad)(quad-point4 quad))) 
          (parallel? (points->line (quad-point2 quad)(quad-point3 quad))
                     (points->line (quad-point4 quad)(quad-point1 quad)))
          (= (distance (quad-point1 quad)(quad-point2 quad))
             (distance (quad-point3 quad)(quad-point4 quad)))
          (= (distance (quad-point2 quad)(quad-point3 quad))
             (distance (quad-point4 quad)(quad-point1 quad)))) 'parallelogram]
    ;; trapezoid
    [(and (parallel? (points->line (quad-point1 quad)(quad-point2 quad))
                     (points->line (quad-point3 quad)(quad-point4 quad)))
          (not (= (distance (quad-point1 quad)(quad-point2 quad))
                  (distance (quad-point3 quad)(quad-point4 quad))))) 'trapezoid]
    [(and (parallel? (points->line (quad-point2 quad)(quad-point3 quad))
                     (points->line (quad-point4 quad)(quad-point1 quad)))
          (not (= (distance (quad-point2 quad)(quad-point3 quad))
                  (distance (quad-point4 quad)(quad-point1 quad))))) 'trapezoid]
    ;; rhombus
    [(and (parallel? (points->line (quad-point1 quad)(quad-point2 quad))
                     (points->line (quad-point3 quad)(quad-point4 quad)))
          (parallel? (points->line (quad-point2 quad)(quad-point3 quad))
                     (points->line (quad-point4 quad)(quad-point1 quad)))
          (not (= (distance (quad-point1 quad)(quad-point2 quad))
                  (distance (quad-point3 quad)(quad-point4 quad))))
          (not (= (distance (quad-point2 quad)(quad-point3 quad))
                  (distance (quad-point4 quad)(quad-point1 quad))))) 'rhombus]
    ;; quadrilateral
    [else 'quadrilateral]))
          
;; Tests for classify    
(check-expect (classify (make-quad (make-posn 5 5)(make-posn -5 5)(make-posn -5 -5)(make-posn 5 -5))) 'square)
    
    


    
         



             
