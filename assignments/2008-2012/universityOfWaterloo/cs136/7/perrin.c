#include<stdio.h>
#include<stdlib.h>

/*
Darren Poon
CS 136 F09 Assignment 7 Question 2
(perrin)
*/

/* to find the perrin sequence */
void perrin(int P[], int n){
	P[0]=3;
	P[1]=0;
	P[2]=2;
	int m;
	for (m=3; m<=n; m++){
		P[m] = P[m-2] + P[m-3];
	}
	printf("%d\n",P[n]);
	return;
}
