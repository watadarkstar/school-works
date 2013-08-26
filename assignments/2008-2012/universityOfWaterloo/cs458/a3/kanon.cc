#include <iostream>
#include <stdlib.h>
#include <fstream>
#include <vector>
#include <string>
#include <string.h>
#include <sstream>

using namespace std;

struct patient{
    string name;	// name of the patient
    string gender;	// gender of the patinet
    string phone;	// telephone of the patient
    string pCode;	// postal code of the patient
    string DoB;		// date of birth of the patient
    string disease;	// disease of the patient
};

// here is where the original data that we store
vector<patient> save;

// printDB(), to print out the data that we store in vector s
void printDB(vector<patient> s){
    cout << "Name,Gender,Telephone,Postal code,Date of birth,Disease" << endl;
    for(unsigned int i = 0; i<s.size(); i++){
	cout << s[i].name << ",";
	cout << s[i].gender << ",";
	cout << s[i].phone << ",";
	cout << s[i].pCode << ",";
	cout << s[i].DoB << ",";
	cout << s[i].disease << endl;
    }
}

// asteriskPostalCode(), to filter the postal code (replace second part with *)
string asteriskPostalCode(string s){
    string temp;
    temp = s.substr(0, 4);
    string star;
    star = "*";
    temp = temp + star;
    return temp;
}

// asteriskDoB_Day(), to filter the date of birth (replace the day with *)
string asteriskDoB_Day(string s){
    string temp;
    size_t pos;

    pos = s.find("-");
    temp = s.substr(pos);
    temp = "*" + temp;

    return temp;
}

// asteriskDoB_Month(), to filter the date of birth (replace the month with *)
string asteriskDoB_Month(string s){
    string temp;
    size_t pos;

    pos = s.find("-");
    pos = s.find("-", pos+1);

    temp = s.substr(pos);
    temp = "*" + temp;
    temp = "-" + temp;
    temp = "*" + temp;

    return temp;
}

// asteriskDoB_Year(), to filter the date of birth (round down the year by multiple of 10)
string asteriskDoB_Year(string s){
    string temp;
    size_t pos;

    pos = s.length() - 4;
    int year = atoi(s.substr(pos).c_str());
    int remainder = year % 10;
    year = year - remainder;

    temp = s.substr(0, pos);
    stringstream ss;
    ss << year;

    temp = temp + ss.str();

    return temp;
}

// compare(), to check whether the records have same quasi indentifier
bool compare(patient a, patient b){
    if(a.gender == b.gender &&
       a.DoB == b.DoB &&
       a.pCode == b.pCode){
	return true;
    }else {
	return false;
    }
}

// nonKAnonmyous(), to find out the record that does not satisfy the k-anonymous
vector<patient> nonKAnonymous(vector<patient> v, int k){
    vector<patient> temp;
    for(unsigned int i = 0; i<v.size(); i++){
	int count = 0;
	for(unsigned int j = 0; j<v.size(); j++){
	    if(i != j){
		if(compare(v[i], v[j])){
		    count++;
		}
	    }
	}
	if(!(count >= (k-1))){
	    temp.push_back(save[i]);
	}
    }
    return temp;
}
	    
// firstStage(), to perform first stage of filtering (replace name, phone, day in date of birth with *)
vector<patient> firstStage(vector<patient> v){
    vector<patient> temp;
    for(unsigned int i = 0; i<v.size(); i++){
	patient p;
	p.name = "*";
	p.gender = v[i].gender;
	p.phone = "*";
	p.pCode = v[i].pCode;
	p.DoB = asteriskDoB_Day(v[i].DoB);
	p.disease = v[i].disease;
	temp.push_back(p);
    }
    return temp;
}

// secondStage(), to perform second stage of filtering (replace the second part of postal code with *)
vector<patient> secondStage(vector<patient> v, int k){
    vector<patient> temp;
    for(unsigned int i = 0; i<v.size(); i++){
	int count = 0;
	for(unsigned int j = 0; j<v.size(); j++){
	    if(i != j){
		if(compare(v[i], v[j])){
		    count++;
		}
	    }
	}
	if(count >= (k - 1)){
	    temp.push_back(v[i]);
	}else{
	    patient p;
	    p.name = v[i].name;
	    p.gender = v[i].gender;
	    p.phone = v[i].phone;
	    p.pCode = asteriskPostalCode(v[i].pCode);
	    p.DoB = v[i].DoB;
	    p.disease = v[i].disease;
	    temp.push_back(p);
	}
    }
    return temp;
}

// thirdStage(), to perfrom third stage of filtering (replace the month in date of birth with *)
vector<patient> thirdStage(vector<patient> v, int k){
    vector<patient> temp;
    for(unsigned int i = 0; i<v.size(); i++){
        int count = 0;
        for(unsigned int j = 0; j<v.size(); j++){
            if(i != j){
                if(compare(v[i], v[j])){
                    count++;
                }
            }
        }
        if(count >= (k - 1)){
            temp.push_back(v[i]);
        }else{
            patient p;
            p.name = v[i].name;
            p.gender = v[i].gender;
            p.phone = v[i].phone;
            p.pCode = v[i].pCode;
            p.DoB = asteriskDoB_Month(v[i].DoB);
            p.disease = v[i].disease;
            temp.push_back(p);
        }
    }
    return temp;
}

// fourthStage(), to perfrom fourth stage of filtering (round down the year in data of birth)
vector<patient> fourthStage(vector<patient> v, int k){
    vector<patient> temp;
    for(unsigned int i = 0; i<v.size(); i++){
        int count = 0;
        for(unsigned int j = 0; j<v.size(); j++){
            if(i != j){
                if(compare(v[i], v[j])){
                    count++;
                }
            }
        }
        if(count >= (k - 1)){
            temp.push_back(v[i]);
        }else{
            patient p;
            p.name = v[i].name;
            p.gender = v[i].gender;
            p.phone = v[i].phone;
            p.pCode = v[i].pCode;
            p.DoB = asteriskDoB_Year(v[i].DoB);
            p.disease = v[i].disease;
            temp.push_back(p);
        }
    }
    return temp;
}

// main
int main(){

    // read input
    ifstream myfile ("Infectious_Disease_Record.csv");
    if(myfile.is_open()){
	while(myfile.good()){
	    patient p;
	    string temp;
	    getline(myfile, temp, ',');
	    p.name = temp;
	    getline(myfile, temp, ',');
	    p.gender = temp;
	    getline(myfile, temp, ',');
	    p.phone = temp;
	    getline(myfile, temp, ',');
	    p.pCode = temp;
	    getline(myfile, temp, ',');
	    p.DoB = temp;
	    getline(myfile, temp, '\n');
	    p.disease = temp;
	    save.push_back(p);
	}
	myfile.close();
    }
    save.erase(save.begin());
    save.erase(save.end());

    // first stage
    vector<patient> new_save1;
    new_save1 = firstStage(save);

    // second stage
    vector<patient> new_save2;
    new_save2 = secondStage(new_save1, 10);

    // third stage
    vector<patient> new_save3;
    new_save3 = thirdStage(new_save2, 10);

    // fourth stage
    vector<patient> new_save4;
    new_save4 = fourthStage(new_save3, 10);

    // print anonymous.csv
    printDB(new_save4);

    // non-K-anonymous
    vector<patient> nonk;
    nonk = nonKAnonymous(new_save4, 10);
    
    // print non-K-anonymous
    ofstream outfile;
    outfile.open("non-kanonymized.csv");
    outfile << "Name,Gender,Telephone,Postal code,Date of birth,Disease" << endl;
    for(unsigned int i = 0; i<nonk.size(); i++){
        outfile << nonk[i].name << ",";
        outfile << nonk[i].gender << ",";
        outfile << nonk[i].phone << ",";
        outfile << nonk[i].pCode << ",";
        outfile << nonk[i].DoB << ",";
        outfile << nonk[i].disease << endl;
    }

//    printDB(new_save4);
//    cout << asteriskPostalCode(save[2].pCode) << endl;
//    cout << asteriskDoB(save[2].DoB) << endl;
//    cout << asteriskDoB_Month(save[2].DoB) << endl;
//    cout << asteriskDoB_Year(save[2].DoB) << endl;

    return 0;
}
