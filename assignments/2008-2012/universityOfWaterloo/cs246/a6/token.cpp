#include "token.h"
#include <string>
#include <string.h>
#include <cstring>

using namespace std;

bool Token::isSkinny( ){
	if (tail == ""){
		return true;
	}else {
		return false;
	}
}

Token::Token (char hd, std::string tl){
	head = hd;
	tail = tl;
}

Token::Token (char hd){
	head = hd;
	tail = "";
}

Token::Token(){
	head = NULL;
	tail = "";
}

char Token::getHead(){
	return head;
}

std::string Token::getTail(){
	return tail;
}

void Token::inputCookedToken(){
	string token;
	//cin >> token;
	getline(cin, token);
	string temp_head = token.substr(0,1);
	
	char * temp_char;
	temp_char = new char[temp_head.length() + 1];
	
	strcpy(temp_char,temp_head.c_str());
	head = temp_char[0];
	tail = token.substr(1);

	delete temp_char;
}

void Token::outputCookedToken(){
	cout << head << tail << endl;
}


std::ostream& operator << (std::ostream & os,const Token & tok){
	Token T = tok;
	char raw_head;
	raw_head = T.getHead();
	// skinny
	if (T.isSkinny()){
		if (raw_head == ';'){
			os << ";" << endl;
		}else if (raw_head == 'e'){
			os << "== ";
		}else {
			os << raw_head << " ";
		}

	// fat
	}else {
		string raw_tail;
		raw_tail = T.getTail();
		raw_tail = raw_tail.substr(1);	// skip ':'
		if (raw_head == 'x'){
			os << raw_tail << " ";
		}else if (raw_head = '"'){
			
			os << '"' << raw_tail << '"' << " ";
		}
	}
	return os;
}

