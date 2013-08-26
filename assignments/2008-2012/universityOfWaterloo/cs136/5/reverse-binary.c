#include <stdio.h>

/*
Darren Poon
CS 136 F09 Assignment 5 Question 6
(reverse_binary)
*/

void reverse_binary(int n){
    if (n == 0){
	    printf ("0");
	}
	else {
	for (int s = n; s > 0;s = s/2){
		if (s % 2 == 0){
			printf ("0");
		}
		else {
			printf ("1");			
		}
    }
	}
	printf ("\n");
}

