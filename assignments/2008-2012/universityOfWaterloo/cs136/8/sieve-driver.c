#include<stdio.h>
#include<stdlib.h>
#include "sieve.h"

/*
Darren Poon
CS 136 F09 Assignment 8 Question 1
(sieve-driver)
*/

int main(){
	int n=30;
	int A[n+1];
	sieve(A,n);
	for(int i = 0; i < n - 1; i++){
		if(A[i] != 0){
			printf("%d ",A[i]);
		}
	}
	return 0;
}
