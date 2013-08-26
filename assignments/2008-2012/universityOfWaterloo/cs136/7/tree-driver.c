#include<stdio.h>
#include<stdlib.h>
#include "mem.h"
#include "tree.h"

/*
Darren Poon
CS 136 F09 Assignment 7 Question 1
(tree-driver)
*/

int main(){
	struct node *btree;
	btree = buildTree();
	printTree(btree);
	PrintUnmarkedBlocks();
	return 0;
}
