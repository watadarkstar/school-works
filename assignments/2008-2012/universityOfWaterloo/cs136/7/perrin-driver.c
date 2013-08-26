#include<stdio.h>
#include<stdlib.h>
#include "perrin.h"

/*
Darren Poon
CS 136 F09 Assignment 7 Question 2
(perrin-driver)
*/

int main(){
	int array_perrin[99999]={3,0,2};
	perrin(array_perrin, 0);
	perrin(array_perrin, 1);
	perrin(array_perrin, 2);
	perrin(array_perrin, 3);
	perrin(array_perrin, 4);
	perrin(array_perrin, 5);
	perrin(array_perrin, 6);
	perrin(array_perrin, 7);
	perrin(array_perrin, 8);
	perrin(array_perrin, 9);
	return 0;
}
