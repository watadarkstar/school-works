#include "tokenbuffer.h"
#include <iostream>

using namespace std;

void TokenBuffer::inputCookedTokensIntoBuffer(){
	for(;;){
		Token T;
		char temp_head;
		T.inputCookedToken();
		temp_head = T.getHead();
		if (temp_head == 'E'){
			buffer.push_back(T);
			break;
		}
		buffer.push_back(T);
		
	}
	it = buffer.begin();
}

void TokenBuffer::outputCookedTokensFromBuffer(){
	rewind();
	for (it; it != buffer.end(); it++){
		it->outputCookedToken();
	}
	rewind();
}

void TokenBuffer::outputRawTokensFromBuffer(){
	rewind();
	for (it; it != buffer.end(); it++){
		char temp_head = it->getHead();
		if (temp_head == 'E'){
			break;
		}
		cout << *it;
	}
	rewind();
}

void TokenBuffer::rewind(){
	it = buffer.begin();
}

Token TokenBuffer::getToken(){
	Token temp;
	temp = *it;
	it++;
	return temp;
}

