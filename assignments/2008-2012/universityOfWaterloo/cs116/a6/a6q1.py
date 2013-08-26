##
## *****************************************************
##
## CS 116 Assignment 6, Question 1

## Darren Poon

## (How_many_buckets)
##
## *****************************************************

## Contract: how_many_buckets: int[>o] int[>0] int[>0] -> int[>0]

## Purpose: consumes the height and radius of a cylindrical bucket and the number of cubic centimetres of sand available and produce an integer indicating the number of complete buckets of sand possible.

## Examples:
## how_many_buckets(2,1,62.8) => 39
## how_many_buckets(1,1,1) => 0
## how_many_buckets(2,1,30) => 4

## Definition:
import math
def how_many_buckets(height,radius,cubic_cm):
    return int(cubic_cm /(radius *radius *math.pi *height))

## No test is needed
