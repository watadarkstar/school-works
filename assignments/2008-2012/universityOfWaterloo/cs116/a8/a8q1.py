## *****************************************************
##
## CS 116 Assignment 8, Question 1

## Darren Poon

## (percent_cold)
##
## *****************************************************

## Contract: percent_cold: (union None or float or string) -> float

## Purpose: the function percent_cold reads the temperatures typed in by the user and prompt the user to input either a temperature or the word end to stop the process. The function should produce the percentage of temperatures staisfting the temperature criterion for an Extreme Cold Weather Alert.

## Examples:
## percent_cold ()
## Enter temperature (or end): -20.9
## Enter temperature (or end): 3
## Enter temperature (or end): -15
## Enter temperature (or end): 0
## Enter temperature (or end): -23.5
## Enter temperature (or end): end
## => 60.0

## Definition:
def percent_cold():
    num = float (0)
    all_total = float (0)
    statement_input = raw_input ("Enter temperature (or end):")
    while statement_input!= "end":
        all_total = all_total + 1
        if float (statement_input) <= -15:
            num = num + 1
        statement_input = raw_input("Enter temperature (or end):")
    return num / all_total * 100

## additional Tests:
## percent_cold ()
## Enter temperature (or end): -10
## Enter temperature (or end): 5
## Enter temperature (or end): 7
## Enter temperature (or end): -20.5
## Enter temperature (or end): -40
## Enter temperature (or end): end
## => 40.0