#include <stdio.h>
#include <stdlib.h>
#include "mem.h"

/*
Darren Poon
CS 136 F09 Assignment 7 Question 1
(tree)
*/

struct node{
	int value;
	struct node *rightsibling;
	struct node *leftchild;
	struct node *parent;
};

/* create a new pointer node by given n which the
struct node have value n */
struct node *helper (int n){
	struct node *temp = dmalloc(sizeof(struct node));
	temp->value=n;
	temp->parent=NULL;
	temp->rightsibling=NULL;
	temp->leftchild=NULL;
	return temp;
}

/* to build a tree given input */
struct node *buildTree(){
	struct node *new = dmalloc(sizeof(struct node));
	if (new == NULL){
		printf("insertNode: out of memory\n");
		abort();
	}
	int ch;
	struct node *previous;
	ch = getchar();	
	previous = helper(ch);
	new = helper(ch);
	for(ch = getchar();ch != EOF;ch = getchar()) {
		if (ch == '[') {
			ch = getchar();			
			new->leftchild = helper(ch);
			new->parent = previous;
			previous = helper(ch);
			return new;
		} else if (ch == ']') {
			new = new->parent;
			return new;
		} else if (ch == ' ') {
			return new;
		} else {
			new->rightsibling = helper(ch);
			new->parent = previous;
			return new;
		}
	}
	return new;
}

/* to print the tree */
void printTree(struct node *tree){
	if (tree == NULL) {			
		return;
	}else{
		printTree(tree->leftchild);
		printTree(tree->rightsibling);
		printf("%c", tree->value);
	}
}

/* To free the tree */
void freeTree(struct node *tree){
  struct node *p;
  struct node *tmp;
  if (tree!=NULL) {
    tmp=tree;
    tree=tree->rightsibling;
    while(tree!=tmp) {
      p=tree->leftchild;
	  dfree(tree->parent);
	  tree=p;
	}
	while(tree!=tmp) {
	  p=tree->rightsibling;
      dfree(tree->parent);
      tree=p;
    }
    dfree(tree);
  }
  else{
	  if (tree != NULL){
		dfree(tree);
	}
  }
}
