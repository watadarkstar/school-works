## *****************************************************
##
## CS 116 Assignment 9, Question 1

## Darren Poon

## (who_wins)
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

## Contract: who_wins: card card string -> card 

## Purpose: function that consumes two distinct Cards c1 and c2 and a string trump and determine which card wins in a typical card game with trump.

## Examples: who_wins (c1, c2, "hearts") => 1
##           who_wins (c2, c1, "hearts") => 2
##           who_wins (c1, c3, "clubs") => 2
##           who_wins (c1, c4, "diamonds") => 1

## Definition:
def who_wins(c1, c2, trump):
   if c1.suit == c2.suit:
      if c1.value > c2.value:
         return 1
      if c1.value < c2.value:
         return 2
   elif not (c1.suit == c2.suit):
      if c2.suit == trump:
         return 2
      else:
         return 1
      
## No additional Test is needed