#include <iostream>
#include "pizzaobject.h"
#include "pizzadata.h"
#include "pizzaok.h"
#include <cstdlib>
using namespace std;

int main(){
	cout.setf(ios::fixed);
    cout.setf(ios::showpoint);
    cout.precision (2);

	// print hello message and size options
	cout << helloPhrase << sizePrompt;
	cout << "    ";
	for (int i=0; i<SIZE_RANGE; i++){
		cout << char(BASIC_SIZE + i) << "=" << sizeName[i] << " ";
	}

	// check size is within a given range or else print error and halt
	cin >> size;
	if(char_valid(size,(int)BASIC_SIZE, SIZE_RANGE)){
		size_num = size - (int)BASIC_SIZE;
		total_cost = total_cost + pizzaPrice[size_num];
		cout << "    " << sizeName[size_num] << endl;
	}else {
		cout << abortPhrase << " '" << size << "'" << endl;
		exit(-1);
	}

	// initialize topping_list to be an empty array which is to use for 
	// counting the number of toppings for pizza
	itemlist(topping_list, TOPPING_RANGE);
	for (int i=0; i<TOPPING_RANGE; i++){
		topping_list[i] = 0;
	}

	// print topping prompt and topping options
	while(true){
		cout << toppingPrompt;
		cout << "    ";
		for (int i=0; i<TOPPING_RANGE; i++){
			cout << i+1 << "=" << toppingName[i] << " ";
		}
		cin >> topping_num;
		if ((int)topping_num-(int)FIRST_TOPPING == TOPPING_RANGE-1){
			int j = int(topping_num) - (int)FIRST_TOPPING;
			cout << "    " << toppingName[j] << endl;
			break;
		}

		// check input is within a given range, and prints the chosen output
		// if input is valid, or else print error message and halt
		if(char_valid(topping_num,(int)FIRST_TOPPING, TOPPING_RANGE)){
			int j  = int(topping_num) - (int)FIRST_TOPPING;
			cout << "    " << toppingName[j] << endl;
			total_cost = total_cost + toppingPrice[j];
			topping_list[j] = topping_list[j] + 1;
		}else {
			cout << abortPhrase << " '" << topping_num << "'" << endl;
			exit (-1);
		}
	}

	// finally, prints the results and goodbye message
	cout << sizeNotice << sizeName[size_num] << endl;
	cout << toppingNotice << endl;
	cout << "    ";
	for(int i=0;i<TOPPING_RANGE-1;i++){
		cout << " " << topping_list[i] << " " << toppingName[i];
	}
	cout << endl;
	cout << requestPayment << "$" << total_cost << endl;
	cout << goodbyePhrase;
	return 0;
}

