#include<stdio.h>
#include<stdlib.h>
#include"mem.h"

/*
Darren Poon
CS 136 F09 Assignment 9 Question 2
(hash-driver)
*/

int main(void){
	struct hash *table = make_table(5);
		add (table, 1, 'a');
		add (table, 2, 'b');
		add (table, 1, 'c');
		search (table, 1);
		free_table (table);
		PrintUnmarkedBlocks();
	return 0;
}
