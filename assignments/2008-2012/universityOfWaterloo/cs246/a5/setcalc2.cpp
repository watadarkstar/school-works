#include "help.h"
#include <iostream>		//IO
#include "strset2.h"
#include <cstdlib>		//exit
#include <cstring>		//string
#include <fstream>		//stream
#include <vector>

using namespace std;

bool verbose = false;

struct Aset {
	string name;
	std::vector<strSet> value;
};
vector<Aset> save;				// save sets


// strset_calc is the function that calculate the string
int strset_calc(){
	// Initialize
	char command;				// read commands

	for(;;){
		if (verbose){
			cout << "Command: ";
		}//no printing
		cin >> command;

		if (command == 'd'){
			Aset instance;
			string set_name;

			bool set_alrdy_defined = true;
			if (verbose){
				cout << "Declare (to be empty).  Give set: ";
			}
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
			if (verbose){
				cout << "Declare (to be singleton).  Give set element: ";
			}
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
			if (verbose){
				cout << "Declare, build set. Give set { elem1 elem2 ... }:\n";
			}
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
			if (verbose){
				cout << "Output.  Give set: ";
			}
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
			if (verbose){
				verbose = false;
			}else
				verbose = true;

		}else if (command == 'p'){
			string line;
			cin >> line;
			cout << line << endl;
		
		}else if (command == 'q') {
			if (verbose){
				cout << "Quitting." << endl;
			}
			for (unsigned int i = 0; i < save.size(); i++){
				save[i].value[0].nullify();
			}
			exit (1);
		}else if (command == 'h') {
			help();
			
		}else if (command == '+'){
			bool string_check = true;
			string str1;
			string str2;
			string str3;
			if (verbose){
				cout << "Union.  Give set1 set2 set3: ";
			}
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
			if (verbose){
				cout << "Intersection.  Give set1 set2 set3: ";
			}
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
			if (verbose){
				cout << "Subtract.  Give set1 set2 set3: ";
			}
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
			if (verbose){
				cout << "Assign.  Give set1 set2: ";
			}
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
		verbose = true;
		strset_calc();

	// otherwise just execute strset_calc
	}else {
		strset_calc();
	
	}

	return 0;
}

