#include<stdio.h>
#include<stdlib.h>
#include"pattern.h"

/*
Darren Poon
CS 136 F09 Assignment 8 Question 2
(pattern-driver)
*/

int main(){
	int T[15] = {0,0,0,0,1,0,0,0,1,0,1,0,0,0,1};
	int P[4] = {0,0,0,1};
	pattern(T, 15, P, 4);
	return 0;
}
