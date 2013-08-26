##
## *****************************************************
##
## CS 116 Assignment 6, Question 2

## Darren Poon

## (is_prime)
##
## *****************************************************

## Contract: is_prime: int[>1] -> boolean

## Purpose: consumes a positive integer n and produces True if n is prime and False otherwise.

## Examples:
## is_prime(3) will produce true
## is_prime(10000) will produce false
## is_prime(11) will produce true

## Definition:
def is_prime(n):
 if n < 8:
  if n == 6 or n == 4:
   return False
  else:
   return True
  elif (n % 2.0) == 0.0:
   return False
  elif (n % 3.0) == 0.0:
   return False
  elif (n % 5.0) == 0.0:
   return False
  elif (n % 7.0) == 0.0:
   return False
  else:
   return True 
  
## No test is needed 
 