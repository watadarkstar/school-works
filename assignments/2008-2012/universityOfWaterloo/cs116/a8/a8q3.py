## *****************************************************
##
## CS 116 Assignment 8, Question 3

## Darren Poon

## (rotate_suits)
##
## *****************************************************

## Contract: (listof card) => (union None or (listof card))

## Purpose: a function rotate_suits that consumes a non_empty list of cards and produces nothing. Instead, rotate_suits changes the suit of each card in the list to be the suit of the card following it in the list. The first card is considered to follow the last card.

## Examples: rotate_suits ([[9, "spades"], [7, "clubs"], [9, "clubs"]]) => [[9, "clubs"], [7, "clubs"], [9, "spades"]]
##           rotate_suits ([[9, "spades"], [8, "hearts"]]) => None

## Definition:
def rotate_suits(hand):
    x = 0
    y = 1
    while x <= len (hand):
    if (not (hand [x] [0] == hand [y] [0])):
        return None
        x = x + 1
        
    
## No additional Test is needed    