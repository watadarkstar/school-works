#include<stdio.h>
#include<stdlib.h>
#include"hash.h"
#include"mem.h"

struct node{
  int key;
  char *value;
  struct node *next;
};


struct hash{
  int size;
  struct node **table;
};

/*
Darren Poon
CS 136 F09 Assignment 9 Question 2
(hash)
*/

struct hash make_table(int s){
	struct hash t = dmalloc (sizeof (struct hash));
	if (t == NULL){
		printf("not enough memory\n");
		abort();
	}
	struct node **table1 = dmalloc (sizeof (struct node));
	if (table == NULL){
		printf("not enough memory\n");
		abort();
	}
	t->size = s;
	t->table = table1;
	table1->key = NULL;
	table1->value = NULL;
	table1->next = NULL;
	&table1 = table1[s];
	return t;
}

char *search(struct hash T, int k){
	if(T->table == NULL){ // if Null
		printf("search:trying to search a value from a NULL hash.\n");
		abort();
	}
	char c = NULL;
	int h = T->size;
	int i = 0;
	struct node *j = T->table[i];
	for (i = 0; i <= h; i++){ //search all the elements in array
		while(1){ //search all keys in the nodes in one elements
			if (k == j->key){
				c = j->value;
				return c;
			}
			if (j->next == NULL){
				return c;
			}
			else {
				j = j->next;
			}
		}
	}
}

/*
void add(struct hash T, int k, char *v){
	if (T == NULL)
		return NULL;
	if (search (T, k = NULL){
		struct node t = 
		T->table->next = v;
	else {
		T = 
*/
		
void free_table(struct hash T){
	if(T==NULL){
		return;
	}
	while(T->table != NULL){
		dfree(T->node->value);
		free_table(T->node->next);
		dfree(T);
	}
}
