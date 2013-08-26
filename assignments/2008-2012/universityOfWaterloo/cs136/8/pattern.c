#include<stdio.h>
#include<stdlib.h>

/*
Darren Poon
CS 136 F09 Assignment 8 Question 2
(pattern)
*/

int helper(int T[], int a, int P[],int m){
	int k = m;
	int j = 0;
	int b = a;
	while(k>=0){
		if(k == 0){
			return 1;
			k--;
		}
		if(T[b+j] == P[j]){
			j++;
			k--;
		}
		else{
			return 0;
		}
	}
	return 0;
}

void pattern(int T[], int n, int P[], int m){
	int i = 0;
	while(i+m<=n){
		if(i+m>n){
			printf("Pattern does not occur.\n");
		}
		if(helper(T,i,P,m)==1){
			printf("Pattern occurs with shift %d.\n" ,i);
			i++;
		}
		else{
			i++;
		}
	}
}

/* the running time of the function would be O((nm)^2),where m is the length of the pattern and n is the length
of the text. since the the helper function will takes O(nm), the pattern function will take O(nm); therefore,
O(nm) * O(nm) = O((nm)^2)
