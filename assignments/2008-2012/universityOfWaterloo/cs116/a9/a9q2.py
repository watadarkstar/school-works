## *****************************************************
##
## CS 116 Assignment 9, Question 2

## Darren Poon

## (highest_in_each)
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

## Contract: highest_in_each: (listof Cards) -> dictionary

## Purpose: function that consumes a list of cards, hand and produces a dictionary D. The keys of the dictionary are the suits for which there is a card with that suit in hand, and the value of D[s] is the highest value of a card with suit s in hand.

## Examples: highest_in_each([c1,c2,c3,c4]) => {'hearts': 9, 'clubs': 9, 'spades': 9}

## Definition:
def highest_in_each(hand):
   dictionary_D = {}
   ## Contract: find_highest: (listof card) -> integer
   ## Purpose: this is a helper function find_highest that find the highest number in the list of card
   ## Example: find_highest ([c1,c2,c3,c4]) => 9
   def find_highest(listofcard):
      value = 0
      while listofcard != []:
         if value > (listofcard[0]).value:
            listofcard = listofcard[1:]
         else:
            value = (listofcard[0]).value
            listofcard = listofcard[1:]
      return value
   funct = find_highest (hand)
   while hand != []:
      dictionary_D [(hand[0]).suit] = funct
      hand = hand[1:]
   return dictionary_D

## No additional test is needed