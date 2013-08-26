## *****************************************************
##
## CS 116 Assignment 8, Question 5

## Darren Poon

## (diamond)
##
## *****************************************************

## Contract: diamond: integer [>= 0] -> string (k-size diamond)

## Purpose: it is a function that consumes a non-negative integer k and prints a k-size diamond which is

## Examples: print_diamond (1) =>   d 
##                                 ddd
##                                  d 

##           print_diamond (2) =>   d  
##                                 ddd 
##                                ddddd
##                                 ddd 
##                                  d

## Definition:
def print_diamond(k):
    symbol = "d"
    num1 = 0
    num2 = 1
    string = " "
    while k > num1:
        print ((k-num1) * string) + (symbol*(2 * num1 +1))+ (string * (k-num1))
        num1 = num1 + 1
    print symbol * ((2 * k) +1)
    while num1 > 0:
        print (string * num2) + (symbol * (2 * num1 -1)) + (string * num2)
        num1 = num1 - 1 
        num2 = num2 + 1

## No additional Test is needed