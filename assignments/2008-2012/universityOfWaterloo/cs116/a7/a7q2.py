## *****************************************************
##
## CS 116 Assignment 7, Question 2

## Darren Poon

## (draw_for_match)
##
## *****************************************************

## Contract: draw_for_match: (listof card) card -> (union None or (listof card))

## Purpose: If hand has includes no card of the same value as drawn, causes drawn to be added to the end of hand, and None is returned. Otherwise, it removes the same value from hand, and return the list containing drawn and match, in that order.

## Tests Case:
H = [[2, "clubs"],[4,"clubs"],[3,"hearts"]]
## Examples: draw_for_match (H, [5, "hearts"]) => None
##           draw_for_match (H, [2, "hearts"]) => [[2, 'hearts'], [2, 'clubs'], [4, 'clubs'], [3, 'hearts']]
##           draw_for_match ([],[2, "hearts"]) => None

## Definition:
def draw_for_match(hand, drawn):
    find_same = lambda x: x[0] == drawn[0]
    if filter (find_same, hand) == []:
        hand.extend (drawn)
        return None
    else:
        find_same1 = lambda x: x[0] == drawn
        pair = [drawn,filter (find_same1, hand)]
        hand = filter (lambda match: (not match[0] == drawn), hand)
        return [drawn] + hand

## additional test:
## draw_for_match (H, [3, "clubs"]) => [[3, 'clubs'], [2, 'clubs'], [4, 'clubs'], [3, 'hearts']]
## draw_for_match (H, [7, "spades"]) => None