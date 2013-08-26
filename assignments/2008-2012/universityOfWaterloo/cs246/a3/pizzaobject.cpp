#include "pizzaobject.h"


int size_num;
double total_cost = 0;
char size;
char topping_num;
int topping_list[1]={0};


// itemlist is a function to initialize the array into
// zeros
int itemlist(int toppinglist[], int a){
	for(int i=0; i<a; i++){
		toppinglist[i] = 0;
	}
	return 0;
}
	
