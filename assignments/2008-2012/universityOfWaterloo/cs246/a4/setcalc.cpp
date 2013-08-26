#include "help.h"
#include <iostream>		//IO
#include "strset.h"
#include <cstdlib>		//exit
#include <cstring>		//string
#include <fstream>		//stream

using namespace std;

struct Aset {
	string name;
	std::vector<strSet> value;
};
vector<Aset> save;				// save sets
int not_verbose();

int verbose(){
	// Initialize
	char command;				// read commands

	for(;;){
		cout << "Command: ";
		cin >> command;

		// empty sets
		if (command == 'd'){
			Aset instance;
			string set_name;

			bool set_alrdy_defined = true;
			cout << "Declare (to be empty).  Give set: ";
			cin >> set_name;
			// check set if it is already defined
			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
				}
			}
			
			// create the set and save it if it is not yet defined
			if (set_alrdy_defined){
				strSet empty_set;
				instance.name = set_name;
				instance.value.push_back(empty_set);
				save.push_back(instance);
			}

		
		// singleton
		}else if (command == 's'){
			Aset instance;							//initialize
			string set_name;
			string value;
			bool set_alrdy_defined = true;
			cout << "Declare (to be singleton).  Give set element: ";
			cin >> set_name;						//read
			cin >> value;

			// check if it is already defined
			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
				}
			}

			// create the set and save it if it is not yet defined
			if (set_alrdy_defined){
				strSet single_set(value);
				instance.name = set_name;
				instance.value.push_back(single_set);
				save.push_back(instance);			//save
			}

		// set with members
		}else if (command == 'b'){
			Aset instance;
			string set_name;
			string value;
			bool set_alrdy_defined = true;
			cout << "Declare, build set. Give set { elem1 elem2 ... }:\n";
			cin >> set_name;
			instance.name = set_name;

			// check if it is already defined
			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
					break;
				}
			}

			if (set_alrdy_defined){
				cin >> value;				//skip "{"
				if (value != "{"){
					cerr << "ERROR: Missing '{' got '"
						<< value << "'" << endl;
					break;
				}
				getline(cin,value,'}');		//save
				strSet multi_set(value);
				instance.value.push_back(multi_set);
				save.push_back(instance);
			}
			
		
		// output the set given by the user
		}else if (command == 'o'){
			string set_name;
			cout << "Output.  Give set: ";
			cin >> set_name;
			unsigned int i;
			// check set if it is exists
			for(i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					if (save[i].value[0].isNull()){
						cout << "Empty set" << endl;
						break;
					}else {
						save[i].value[0].output();
						break;
					}
				}
			}
			if(i == save.size()){
				cerr << "ERROR: no such set '" << set_name
					<< "'" << endl;
			}

		// verbose
		}else if (command == 'v'){
			// call not_verbose which does no printing
			not_verbose();

		// print
		}else if (command == 'p'){
			string line;
			cin >> line;
			cout << line << endl;
		
		// quit
		}else if (command == 'q') {
			cout << "Quitting." << endl;
			exit (1);

		// help
		}else if (command == 'h') {
			help();
			
		// addition
		}else if (command == '+'){
			bool string_check = true;
			string str1;			//read
			string str2;
			string str3;
			cout << "Union.  Give set1 set2 set3: ";
			cin >> str1;
			cin >> str2;
			cin >> str3;
			strSet instance1, instance2, instance3;
			// find the position of the sets from the save
			unsigned int i;
			for(i = 0; i<save.size();i++){
				if(str1 == save[i].name){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size();j++){
				if(str2 == save[j].name){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size();k++){
				if(str3 == save[k].name){
					break;
				}
			}

			// check if the sets are in the save
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] + save[k].value[0];
			}

		// intersection
		}else if (command == '*'){
			bool string_check = true;
			string str1;				//read
			string str2;
		    string str3;
			cout << "Intersection.  Give set1 set2 set3: ";
	        cin >> str1;
			cin >> str2;
			cin >> str3;
			// find the sets from the save
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size(); k++){
				if(save[k].name == str3){
					break;
				}
			}
			// check if the sets are in the save
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] * save[k].value[0];
			}

		// subtract
		}else if (command == '-'){
		    bool string_check = true;
			string str1;				//read
			string str2;
			string str3;
			cout << "Subtract.  Give set1 set2 set3: ";
			cin >> str1;
			cin >> str2;
			cin >> str3;
			// find sets from the save
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size(); k++){
				if(save[k].name == str3){
					break;
				}
			}
			// check if the sets are in the save
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] - save[k].value[0];
			}

		}else if (command == '='){
			bool string_check = true;
			string str1;			//read
			string str2;
			string str3;
			cout << "Assign. Give set1 set2: ";
			cin >> str1;
			cin >> str2;
			strSet instance1, instance2;
			//find sets from the save
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			
			//check if the sets are in the save
			if((i == save.size()) || (j == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				}
			}
			if(string_check){
				save[i].value[0] = save[j].value[0];
			}
		
		}else {
			string line;
			cerr << "ERROR: Ignoring bad command: '" 
				<< command << "'" << endl;
		}
		}
		return 0;
}


// not_verbose is just the function that is same as verbose but does no printing to standard output
int not_verbose(){
	// Initialize
	char command;				// read commands

	for(;;){
		//cout << "Command: ";		//no printing
		cin >> command;

		if (command == 'd'){
			Aset instance;
			string set_name;

			bool set_alrdy_defined = true;
			//cout << "Declare (to be empty).  Give set: ";			//no printing
			cin >> set_name;
			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
				}
			}
			
			if (set_alrdy_defined){
				strSet empty_set;
				instance.name = set_name;
				instance.value.push_back(empty_set);
				save.push_back(instance);
			}

			
		}else if (command == 's'){
			Aset instance;
			string set_name;
			string value;
			bool set_alrdy_defined = true;
			//cout << "Declare (to be singleton).  Give set element: ";			//no printing
			cin >> set_name;
			cin >> value;
			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
				}
			}

			if (set_alrdy_defined){
				strSet single_set(value);
				instance.name = set_name;
				instance.value.push_back(single_set);
				save.push_back(instance);		
		
			}

		}else if (command == 'b'){
			Aset instance;
			string set_name;
			string value;
			bool set_alrdy_defined = true;
			//cout << "Declare, build set. Give set { elem1 elem2 ... }:\n";	//no printing
			cin >> set_name;
			instance.name = set_name;

			for(unsigned int i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					cerr << "ERROR: Re-declaration of set '"
						<< set_name << "'" << endl;
					set_alrdy_defined = false;
					break;
				}
			}

			if (set_alrdy_defined){
				cin >> value; //skip "{"
				if (value != "{"){
					cerr << "ERROR: Missing '{' got '"
						<< value << "'" << endl;
					break;
				}
				getline(cin,value,'}');
				strSet multi_set(value);
				instance.value.push_back(multi_set);
				save.push_back(instance);
			}
			

		}else if (command == 'o'){
			string set_name;
			//cout << "Output. Give set: ";			//no printing
			cin >> set_name;
			unsigned int i;
			for(i = 0; i < save.size(); i++){
				if (save[i].name == set_name){
					if (save[i].value[0].isNull()){
						cout << "Empty set" << endl;
						break;
					}else {
						save[i].value[0].output();
						break;
					}
				}
			}
			if(i == save.size()){
				cerr << "ERROR: no such set '" << set_name
					<< "'" << endl;
			}

		}else if (command == 'v'){
			verbose();
		}else if (command == 'p'){
			string line;
			cin >> line;
			cout << line << endl;
		
		}else if (command == 'q') {
			//cout << "quitting" << endl;			//no printing
			exit (1);
		}else if (command == 'h') {
			help();
			
		}else if (command == '+'){
			bool string_check = true;
			string str1;
			string str2;
			string str3;
			//cout << "Union. Give set1 set2 set3: ";		//no printing
			cin >> str1;
			cin >> str2;
			cin >> str3;
			strSet instance1, instance2, instance3;
			unsigned int i;
			for(i = 0; i<save.size();i++){
				if(str1 == save[i].name){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size();j++){
				if(str2 == save[j].name){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size();k++){
				if(str3 == save[k].name){
					break;
				}
			}
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] + save[k].value[0];
			}

		}else if (command == '*'){
			bool string_check = true;
			string str1;
			string str2;
		    string str3;
			//cout << "Intersection. Give set1 set2 set3: ";		//no printing
	        cin >> str1;
			cin >> str2;
			cin >> str3;
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size(); k++){
				if(save[k].name == str3){
					break;
				}
			}
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] * save[k].value[0];
			}

		}else if (command == '-'){
		    bool string_check = true;
			string str1;
			string str2;
			string str3;
			//cout << "Subtraction. Give set1 set2 set3: ";		//no printing
			cin >> str1;
			cin >> str2;
			cin >> str3;
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			unsigned int k;
			for(k = 0; k<save.size(); k++){
				if(save[k].name == str3){
					break;
				}
			}
			if((i == save.size()) || (j == save.size()) || (k == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				 }else if(k == save.size()){
					cerr << "ERROR: No such rel '"
						<< str3 << "'" << endl;
				 }
			}
			if(string_check){
				save[i].value[0] = save[j].value[0] - save[k].value[0];
			}
		}else if (command == '='){
			bool string_check = true;
			string str1;
			string str2;
			string str3;
			//cout << "Assign. Give set1 set2: ";		//no printing
			cin >> str1;
			cin >> str2;
			strSet instance1, instance2;
			unsigned int i;
			for(i = 0; i<save.size(); i++){
				if(save[i].name == str1){
					break;
				}
			}
			unsigned int j;
			for(j = 0; j<save.size(); j++){
				if(save[j].name == str2){
					break;
				}
			}
			if((i == save.size()) || (j == save.size())) {
				string_check = false;
				string clear_line;
				if(i == save.size()){
					cerr << "ERROR: No such rel '"
						<< str1 << "'" << endl;
				 }else if(j == save.size()){
					cerr << "ERROR: No such rel '"
						<< str2 << "'" << endl;
				}
			}
			if(string_check){
				save[i].value[0] = save[j].value[0];
			}
		
		}else {
			string line;
			cerr << "ERROR: Ignoring bad command: '" 
				<< command << "'" << endl;
		}
		}
		return 0;
}


int main(int argc, char *argv[]){
	// print Welcome if "-v" is given and call verbose
	if(argc == 2 && !strcmp(argv[1], "-v")){
		cout << "Welcome to string set calculator.  Type 'h' for help." << endl;
			verbose();

	// otherwise just call not_verbose
	}else {
			not_verbose();
	
	}
	return 0;
}

