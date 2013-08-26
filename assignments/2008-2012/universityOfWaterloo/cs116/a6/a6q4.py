##
## *****************************************************
##
## CS 116 Assignment 6, Question 4

## Darren Poon

## (make-oh)

## *****************************************************

## Contract: make_oh: int[>1] -> None

## Purpose: which it consumes a positive integer k and prints a k-size letter O

## Examples:
## make_oh(2) => diagram on the assignment 6 Q 4 (1)
## make_oh(3) => diagram on the assignment 6 Q 4 (2)

## Definition:
def make_oh(k): 
    def top (x,y):
        if sp == 1:
            print " " + x * "x"
        else: 
            print y * " " + x * "x"
            top (x + 2,y - 1)
    def middle (x,y):
        if c == k: None
        else:
            print x * "x" + x * " " + x * "x"
            middle (x, y + 1)
    def bottom(x,y):
        if s == k:
            print x * " " + y * "x"
        else:
            print x * " " + y * "x"            
            bottom((x + 1), (y - 2))            
    top(k,k)
    middle(k,0)
    bottom(1,((3 * k)-2))
## No additional tests were needed                
