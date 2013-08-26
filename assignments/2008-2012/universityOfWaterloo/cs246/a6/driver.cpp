#include <string>				// string
#include <fstream>				// stream
#include <iostream>				// IO
#include <string.h>				// substr
#include <cstdlib>				// exit
#include <map>					// map
#include "extstrset3.h"
#include "tokenbuffer.h"


using namespace std;


map <string, extStrSet> save;	// save all the sets
map <string, extStrSet> temp_save;	// temp
TokenBuffer T;					// tokens are read to the buffer
Token temp;						// token
string set_name;				// temp var
string lhs_string, rhs_string;	// temp var


void expression();
void statements();

bool accept(char s){
	if (temp.getHead() == s){
		temp = T.getToken();
		return true;
	}
	return false;
}

// expect token's head is same as char s
bool expect(char s){
	if (accept(s)){
		return true;
	}else {
		cerr << "ERROR: Expected token '" << s << "' but got " << temp.getHead() << endl;
		return false;
		exit(-1);
	}
}


void factor(){

	if(temp.getHead() == '('){
		temp = T.getToken();

		expression();
		expect(')');

	}else if (temp.getHead() == '{'){
		map<string, extStrSet>::iterator it;
		for (it = save.begin(); it != save.end(); it++){
			if (set_name == it->first){
				break;
			}
		}

		for (;;){
			temp = T.getToken();
			string elements;
			if (temp.getHead() == '}'){
				break;
			}else if (temp.getHead() == '"'){
				elements = temp.getTail().substr(1);
				strSet strset_temp(elements);
				
				// add memebers to the set
				strSet save_strset_temp = it->second;
				save_strset_temp = it->second;
				save_strset_temp = save_strset_temp + strset_temp;
				it->second = ss2extss(save_strset_temp);
				
			}else {
				cerr << "ERROR: Expected token '}' but got " << temp.getHead() << endl;
			}
			
		}
	}else if (temp.getHead() == 'x'){
		set_name = temp.getTail().substr(1);
		map<string, extStrSet>:: iterator it;
		for (it = save.begin(); it != save.end(); it++){
			if (it->first == set_name){
				break;
			}
		}
		if (it == save.end()){
			cerr << "ERROR: no such set '" << set_name 
				<< "'" << endl;
		}

		
	}

}

// term
void term(){

	// factor
	factor();
	
	if(temp.getHead() == '*'){
		// x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// factor
		factor();

		// lhs = lhs * rhs
		strSet save_strset_temp;
		save_strset_temp = save[lhs_string];
		strSet save_strset_temp_rhs = save[rhs_string];
		save_strset_temp = save_strset_temp * save_strset_temp_rhs;
		save[lhs_string] = ss2extss(save_strset_temp);
	}
}

void comparison(){

	// term
	term();

	// {x | -}
	if(temp.getHead() == '+'){
		// x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// term
		term();

		// lhs = lhs + rhs
		strSet save_strset_temp;
		save_strset_temp = save[lhs_string];
		strSet save_strset_temp_rhs = save[rhs_string];
		save_strset_temp = save_strset_temp + save_strset_temp_rhs;
		save[lhs_string] = ss2extss(save_strset_temp);

	}else if (temp.getHead() == '-'){
		// x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// term
		term();

		// lhs = lhs - rhs
		strSet save_strset_temp;
		save_strset_temp = save[lhs_string];
		strSet save_strset_temp_rhs = save[rhs_string];
		save_strset_temp = save_strset_temp - save_strset_temp_rhs;
		save[lhs_string] = ss2extss(save_strset_temp);
	}
}

void expression(){
	
	// comparison
	comparison();

	if (temp.getHead() == 'e'){
		// x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// comparison
		comparison();

		// lhs = lhs == rhs
		extStrSet save_extstrset_temp;
		save_extstrset_temp = save[lhs_string];
		extStrSet save_extstrset_temp_rhs = save[rhs_string];
		save_extstrset_temp = save_extstrset_temp == save_extstrset_temp_rhs;
		save[lhs_string] = save_extstrset_temp;

	}else if (temp.getHead() == '<'){
		// x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// comparison
		comparison();

		// lhs = lhs < rhs
		extStrSet save_extstrset_temp;
		save_extstrset_temp = save[lhs_string];
		extStrSet save_extstrset_temp_rhs = save[rhs_string];
		save_extstrset_temp = save_extstrset_temp < save_extstrset_temp_rhs;
		save[lhs_string] = save_extstrset_temp;

	}else if (temp.getHead() == '>'){
		//x
		temp = T.getToken();
		lhs_string = temp.getTail().substr(1);

		// comparison
		comparison();

		// lhs = lhs > rhs
		extStrSet save_extstrset_temp;
		save_extstrset_temp = save[lhs_string];
		extStrSet save_extstrset_temp_rhs = save[rhs_string];
		save_extstrset_temp = save_extstrset_temp > save_extstrset_temp_rhs;
		save[lhs_string] = save_extstrset_temp;

	}
}


// write
void write(){

	// x(set name)
	temp = T.getToken();
	set_name = temp.getTail().substr(1);

	// x:to
	temp = T.getToken();
	if (temp.getHead() == 'x'){
		if (temp.getTail() == ":to"){
		}else {
			expect('x');
		}
	}else {
		expect('x');
	}

	// string const;
	temp = T.getToken();
	std::string destination;
	destination = temp.getTail().substr(1);
	// and out to ofstream
	ofstream out;
	out.open(destination.c_str());
	map<string, extStrSet>::iterator it;
	for (it = save.begin(); it != save.end(); it++){
		if (it->first == set_name){
			if (it->second.isNull()){
				out << "Empty set" << endl;
				break;
			}else {
				out << it->second;
				break;
			}
		}
	}
	// if no such set
	if (it == save.end()){
		cerr << "ERROR: no such set '" << set_name
			<< "'" << endl;
	}

	// ;
	temp = T.getToken();
	expect(';');

	// back to statements since there might be more instructions
	statements();
}

// read
void read(){

	// x(set name)
	temp = T.getToken();
	set_name = temp.getTail().substr(1);
	
	// x:from
	temp = T.getToken();
	if (temp.getHead() == 'x'){
		if (temp.getTail() == ":from"){
		}else {
			expect('x');
		}
	}else {
		expect('x');
	}

	// string const
	temp = T.getToken();
	string destination;
	destination = temp.getTail().substr(1);
	// and in from ifstream
	ifstream in;
	in.open(destination.c_str());
	bool variable_in_save = false;
	map<string, extStrSet>::iterator it;
	for (it = save.begin(); it != save.end(); it++){
		if (it->first == set_name){
			variable_in_save = true;
			break;
		}
	}
	// if no such set
	if (it == save.end()){
		cerr << "ERROR: Attempt to assign to undeclared variable " 
			<< set_name << endl;
	}

	if (variable_in_save){
		string string;
		while(!in.eof()){
			in >> string;
			strSet strset_temp(string);
			strSet save_strset_temp = it->second;
			save_strset_temp = save_strset_temp + strset_temp;
			it->second = ss2extss(save_strset_temp);
		}
	}else {
		string string;

		// create a new set in save
		extStrSet empty;
		save[set_name] = empty;

		// read input to save
		while(!in.eof()){
			in >> string;
			strSet strset_temp(string);
			strSet save_strset_temp = it->second;
			save_strset_temp = save_strset_temp + strset_temp;
			it->second = ss2extss(save_strset_temp);
		}
	}

	// ;
	temp = T.getToken();
	expect(';');

	// back to statements since there might be more instructions
	statements();
}

// output
void output(){

	temp = T.getToken();

	// x
	if (temp.getHead() == 'x'){
		
		set_name = temp.getTail().substr(1);
		map<string, extStrSet>::iterator it;
		// find set inside the save
		for (it = save.begin(); it != save.end(); it++){
			if (it->first == set_name){
				// output

				if (it->second.isNull()){
					cout << "Empty set" << endl;
					break;
				}else {
					it->second.output();
					break;
				}
			}
		}
		// if no such set
		if (it == save.end()){
			cerr << "ERROR: no such set '" << set_name
				<< "'" << endl;
		}
	}

	// ;
	temp = T.getToken();
	expect(';');

	// back to statements since there might be more instructions
	statements();
}

// print
void print(){

	temp = T.getToken();
	if (temp.getHead() == '"'){
		string instance;
		instance = temp.getTail().substr(1);
		cout << instance << endl;

		temp = T.getToken();
		expect(';');

		statements();
	}
}

// assignment
void assignment(){

	// x and check if set exists
	lhs_string = temp.getTail().substr(1);
	map<string, extStrSet>::iterator it;
	for (it = save.begin(); it != save.end(); it++){
		if (it->first == set_name){
			break;
		}
	}
	if (it == save.end()) {
		cerr << "ERROR: No such rel '"
			<< lhs_string << endl;
	}

	// =
	temp = T.getToken();
	expect('=');

	// check if rhs is same as lhs
	bool string_check = true;
	if (temp.getHead() == '{'){

	}else if (temp.getHead() == 'x'){
		rhs_string = temp.getTail().substr(1);
		if (rhs_string == lhs_string){
			string_check = false;
			temp = T.getToken();
		}else {
			expression();
		}
	}

	// expression
	if (string_check){
		// delete the old set and create a new empty set
		save.erase(lhs_string);
		extStrSet empty;
		save[lhs_string] = empty;
		expression();
	}
	
	// ;
	temp = T.getToken();
	expect(';');

	// back to statements since there might be more instructions
	statements();
}

// declaration
void declaration(){

	// x
	temp = T.getToken();
	set_name = temp.getTail();
	set_name = set_name.substr(1);
	
	// check redeclare of variable
	for (map<string, extStrSet>::iterator it = save.begin(); it != save.end(); it++){
		if (it->first == set_name){
			cerr << "ERROR: Attempt to redeclare variable "
				<< set_name << endl;
			exit (-1);
		}
	}

	extStrSet empty;
	save[set_name] = empty;
	
	
	// =
	temp = T.getToken();
	expect('=');

	// expression
	expression();
	

	// ';'
	temp = T.getToken();
	expect(';');

	// back to statements since there might be more instructions
	statements();
}

// statements
void statements(){

	if (temp.getHead() == 'x'){
		// declataion
		if (temp.getTail() == ":set"){
			declaration();
		
		// print
		}else if (temp.getTail() == ":print"){
			print();

		// output
		}else if (temp.getTail() == ":output"){
			output();

		// read
		}else if (temp.getTail() == ":read"){
			read();

		// write
		}else if (temp.getTail() == ":write"){
			write();
		
		// assignment
		}else {
			assignment();
		}
	}
}

// program
void program(){
	temp = T.getToken();
	statements();
}


int main(){
	T.inputCookedTokensIntoBuffer();
	program();

	return 0;
}

