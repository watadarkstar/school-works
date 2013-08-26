#include <stdio.h>
#include <stdlib.h>
#include "mem.h"

/*
Darren Poon
CS 136 F09 Assignment 8 Question 3
(matrix)
*/

struct matrix *newmat(int row, int column){
	struct matrix *new = dmalloc((sizeof(struct matrix)) + row * column);
	if (new == NULL){
		printf("insertNode: out of memory\n");
		abort();
	}
	for (int i = 0; i<row*column; i++){
		new->elements[i] = 0;
	}
	return new;
}

void setvalue(struct matrix *mat, int row, int column, int value);

int getvalue(struct matrix *mat, int row, int column);

struct matrix *add(struct matrix *mat1, struct matrix *mat2);

struct matrix *multiply(struct matrix *mat1, struct matrix *mat2);

struct matrix *transpose(struct matrix *mat1);

void freeMatrix(struct matrix *mat){
	int n , j;
	n = 0;
	j = 1;
	struct matrix *temp;
	while(mat!=NULL){
		temp = mat->elements[j];
		dfree(mat[n]);	
		n++;
		mat[n]=temp[j];
		j++;
	}
}
