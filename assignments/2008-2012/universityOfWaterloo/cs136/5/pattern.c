#include <stdio.h>

/*
Darren Poon
CS 136 F09 Assignment 5 Question 4
(bowtie,diamond)
*/

/* Purpose: To make a bowtie diagram given a number input */

void bowtie(int n){
	int i;
	int j;
	for (i=1;i<=n;i=i+1){
		for (j=0;j<i;j=j+1){
			printf("*");
		}
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=0;j<i;j=j+1){
			printf("*");
		}
	printf ("\n");
	}
	for (i=n;i>0;i=i-1){
		for (j=0;j<i;j=j+1){
			printf("*");
		}	
		for (j=n;j>i;j=j-1){
			printf(" ");
		}
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=0;j<i;j=j+1){
			printf("*");
		}		
	printf ("\n"); 
	} 
	return;
}
/* Purpose: To make a bowtie diagram given a number input */

void diamond(int n){
	int i;
	int j;
	for (i=n;i>0;i=i-1){
		for (j=0;j<i;j=j+1){
			printf("*");
		}	
		for (j=n;j>i;j=j-1){
			printf(" ");
		}
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=0;j<i;j=j+1){
			printf("*");
		}		
	printf ("\n"); 
	} 
	for (i=1;i<=n;i=i+1){
		for (j=0;j<i;j=j+1){
			printf("*");
		}
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=n;j>i;j=j-1){
			printf(" ");
		} 
		for (j=0;j<i;j=j+1){
			printf("*");
		}
	printf ("\n");
	}

	return;
}
