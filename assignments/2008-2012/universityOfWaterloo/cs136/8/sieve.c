#include<stdio.h>
#include<stdlib.h>

/*
Darren Poon
CS 136 F09 Assignment 8 Question 1
(sieve)
*/
	   
void sieve(int A[], int n){
	int m = 2;
	for(int l = 0; l < n ; l++){
		A[l] = m;
		m++;
		if(m > n){
			break;
		}
	}
	for(int i = 1; i <= n; i++){
		if(A[i] != 0){
			for(int j = i + 1; j <= n; j++){
				if(A[j] % A[i] == 0){
					A[j] = 0;
				}
			}
		}
	}
}

