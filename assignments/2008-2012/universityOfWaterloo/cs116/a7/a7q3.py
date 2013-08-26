## *****************************************************
##
## CS 116 Assignment 7, Question 3

## Darren Poon

## (anagram, find_anagrams)

## *****************************************************

## Contract: anagram: str str -> bool

## Purpose: a function that consumes two words and returns True if one word can be created by rearranging the characters of the other word, and False otherwise.

## Examples: anagram ("dog", "god") => True
##           anagram ("abc", "def") => False

## Definition:
def anagram(str1, str2):
    if len(str1) == len(str2):
        first_string = list(str1)
        first_string.sort()
        second_string = list(str2)
        second_string.sort()
        if first_string == second_string:
            return True
        else:
            return False
    else:
        return False

## additional Tests:
## anagram ("abc", "cba") => True
## anagram ("123", "124") => False
## anagram ("123", "321") => True

## Contract: find_anagrams (listof words) -> (listof words)

## Purpose: a function that consumes a list of words wordlist, and then reads in a word new_word from console imput. And the function should return all members of wordlist that are anagrams of new+word, in alphabetical order.

## Examples: (Let input = 231) find_anagrams (["123", "234", "456" , "789", "321"]) => ['123', '321']
##           (let input = abc) find_anagrams (["abc", "def", "ghi", "bca", "jkl"]) => ['abc', 'bca']
##           (Let input = fed) find_anagrams (["abc", "def", "ghi"]) => ["def"]
##           (Let input = 123) find_anagrams (["abc", "def", "ghi"]) => []

## Definition:
def find_anagrams(wordlist):
    new_word = raw_input("Input string:")
    anagram_funct = lambda x: anagram (new_word, x)
    L = filter(anagram_funct, wordlist)
    L.sort()
    return L

## additional Tests:
## (Let input = 231) find_anagrams (["123", "234", "456" , "789"]) => ["123"]
## (Let input = abc) find_anagrams (["123", "234", "456" , "789"]) => []