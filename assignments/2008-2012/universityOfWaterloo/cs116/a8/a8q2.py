## *****************************************************
##
## CS 116 Assignment 8, Question 2

## Darren Poon

## (fib)
##
## *****************************************************

## Contract: fib: integer [>= 0] -> integer [>= 0]

## Purpose: a function that consumes a natural number n and produces the nth fibonacci number which is the sum of the two precious numbers.

## Examples: fib (10) => 55
##           fib (5) => 5
##           fib (15) => 610
##           fib (20) => 6725
##           fib (25) => 75025

## Definition:
def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return ((fib (n -1) + fib (n -2)))

## No additional Test is needed