##
## *****************************************************
##
## CS 116 Assignment 6, Question 1

## Darren Poon

## (Average)
##
## *****************************************************

## Contract: average: None -> float

## Purpose: it finds the average of from one to four numbers, and should prompt the user to input a number or type the world end; after four numbers have been typed in it should produces the average

## Examples:
## average() 
## Input number or end: 1 
## Input number or end: 1 
## Input number or end: 1
## Input number or end:end
## 1

## average() 
## Input number or end: 6 
## Input number or end: 7 
## Input number or end:end
## 6.5

## Definition:
def average():
    num1 = raw_input ("Input number or end:")
    num2 = raw_input ("Input number or end:")
    if num2 == "end":
        print float(num1)
    else: num3 = raw_input ("Input number or end:")
    if num3 == "end":
        print (float(num1)+ float(num2))/2
    else: num4 = raw_input ("Input number or end:")
    if num4 == "end":
        print (float(num1)+ float(num2)+ float(num3))/3
    else:
        print (float(num1)+ float(num2)+ float(num3)+ float(num4))/4
        
## No test is needed         