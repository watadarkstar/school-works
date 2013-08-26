## *****************************************************
##
## CS 116 Assignment 8, Question 4

## Darren Poon

## (num_cons)
##
## *****************************************************

## Contract: num_cons: (listof string) string -> integer [>= 0]

## Purpose: It is a function that consumes a list of strings, L, and a single string s. The function produces the maximum number of consecutive elements of L equal to s.

## Examples: num_cons (["a", "bb", "bb", "bbbbbb", "bb", "bb"], "bb") => 2
##           num_cons (["a", "a"], "a") => 0
##           num_cons (["a", "aaaaaaaaaa","a"], "a") => 1

## Definition:
def num_cons(L,s):
    num1 = 0
    num2 = 0
    while len (L) > 0:
        if L [0] == s:
            num1 = num1 + 1
            L = L [1:]
        else:
            L = L [1:]
            num1 = max (num1,num2)
            num2 = num1
            num1 = 0
    return num2

## Additional Tests:
## num_cons (["a", "aaaaaaaaaa","a"], "b") => 0
## num_cons (["b","bbbb", "aaaaaaaaaa","b", "bbbb", "bbbbbbbb"], "b") => 1