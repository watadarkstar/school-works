##
## *****************************************************
##
## CS 116 Assignment 7, Question 1

## Darren Poon

## (words_without)
##
## *****************************************************

## Contract: words_without: str str -> int [>= 0]

## Purpose: a function that produce the number of words in sentence that do not contain the one-character string letter.

## Examples: words_without ('abc def ghi jkl', 'a') => 3
##           words_without ('a a a a a' , 'a') => 0
##           words_without ('a a a a a 1 2 a', 'a') => 2
##           words_without ('a bc de f g h' , 'a') => 5
##           words_without ('a a a 3 a' , 'a') => 1

## Definition:
def words_without (sentence,letter):
    # remove_with_same_wirds: str -> bool
    # Examples: Let letter = 'a' (remove_with_same_words ('a a a a') => False)
    #           Let letter = 'a' (remove_with_same_words ('1 a a a') => True)
    def remove_with_same_words (new_sentence):
        if letter in new_sentence.split () [0]:
            return False
        else:
            return True
        # get_new_list are the function that produce new list taken from string 'sentence'
    get_new_list = filter (remove_with_same_words, sentence.split())
    return len (get_new_list)

## additional test:
## words_without ('abc def ghi jkl', '1') => 4
## words_without ('a a a a a 1 2 a', '1') => 7
## words_without ('a a a a', 'a') => 0
