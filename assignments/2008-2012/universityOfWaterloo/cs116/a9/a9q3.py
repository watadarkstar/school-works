## *****************************************************
##
## CS 116 Assignment 9, Question 3

## Darren Poon

## (go_fish)
##
## *****************************************************

## Card information: while it consumes two fields, suit, which is a string drom the set that contains "clubs", "spades", "diamonds", "hearts", and value, which is an integer from 1 to 10 inclusive.
class Card:
   'Fields: suit, value'

## Card values for testing purposes
c1 = Card()
c1.suit = "hearts"
c1.value = 7
c2 = Card()
c2.suit = "hearts"
c2.value = 3
c3 = Card()
c3.suit = "clubs"
c3.value = 5
c4 = Card()
c4.suit = "spades"
c4.value = 9

## Contract: (listof cards) integer => (union card or string)

## Purpose: a function that consumes a list of Cards, hand, and an integer, v. If hand has a card with value v, then the effect of calling go_fish is that one such card is returned. If hand has no card with value v, then the string "Go fish" is returned.

## Examples: go_fish ([c1,c2,c3,c4], 1) => 'Go fish'
##           go_fish ([c1,c2,c3,c4], 7) => return c1


## Definition:
def go_fish(hand, v):
   while hand != []:
      if (hand[0]).value == v:
         return hand[0]
         hand = hand [1:]
      else:
         hand[1:]
         return "Go fish"

## No additional Test is needed