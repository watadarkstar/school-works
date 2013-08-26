#include<stdio.h>
#include<stdlib.h>
#include"matrix.h"
#include"mem.h"

/*
Darren Poon
CS 136 F09 Assignment 8 Question 3
(matrix-driver)
*/

int main(){
	struct matrix *matrix_A=newmat(6,8);
	struct matrix *matrix_A=newmat(6,8);
	setvalue(matrix_A,0,1,3);
	getvalue(matrix_A,1,1);
	add(matrix_A,matrix_B);
	multiply(matrix_A,matrix_B);
	transpose(matrix_A);
	freeMatrix(matrix_A);
	PrintUnmarkedBlocks();
	return 0;
}
