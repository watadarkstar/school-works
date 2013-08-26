#include <stdio.h>

/*
Darren Poon
CS 136 F09 Assignment 5 Question 5
(bianry)
*/

int s = 1;
int binary_num = 0;
int remainder_num = 1;

void binary(int n){
	if(n == 0){
		printf("%d\n",binary_num);
                s = 1;
                binary_num = 0;
                remainder_num = 1;
	} 
	else {
		remainder_num = n % 2;
		n = n / 2;
		binary_num = binary_num + (s * remainder_num);
		s = s * 10;
		return binary(n);
	}
}
