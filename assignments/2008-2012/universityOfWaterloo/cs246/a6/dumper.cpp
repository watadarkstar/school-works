#include <iostream>		//IO
#include <fstream>		//stream
#include <string>		//string
#include <string.h>		//C string routines
#include <cstdlib>		//exit

using namespace std;

int dumper(){
	string token;
	cin >> token;
	for(;;){
		if (token == "E"){
			exit (1);
		}else if (token == ";"){
			cout << ";" << endl;
			cin >> token;
		}else if (token == "e"){
			cout << "== ";
			cin >> token;
		}else if (token == "{"){
			cout << token;
			cin >> token;
			if (token == "}"){
				cout << token;
				cin >> token;
			}else {
				cout << " ";
			}
		}else if (token.substr(0,2) == "x:"){
			token = token.substr(2);
			cout << token << " ";
			cin >> token;
		}else if (token.substr(0,2) == "\":"){
			token = token.substr(2);
			cout << '"' << token << '"' << " ";
			cin >> token;
		}else {
			cout << token << " ";
			cin >> token;
			}
	}
	return 0;
}

int main(int argc, char *argv[]){
	if (argc == 2 && !strcmp(argv[1], "-cooked")){
		for(;;){
			string token;
			getline(cin,token);
			if (token == "E"){
				cout << "E" << endl;
				break;
			}else {
				cout << token << endl;
			}
		}
	}else {
		dumper();
	}
	return 0;
}

