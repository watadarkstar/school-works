#include "pizzaok.h"


// char_valid is a function to test if the input char is in
// a given range, type is the ASCII number of the input, and
// range is the TOPPING_RANGE/SIZE_RANGE given from the pizzadata

bool char_valid(char & input,int type, int range){
        if(range >= 1){
                if(type <= input && input <= type+range-1){
                        return true;
                }else {
                        return false;
                }
        }else {
                return false;
        }
}

