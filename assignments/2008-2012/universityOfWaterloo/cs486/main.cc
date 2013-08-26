#include <stdio.h>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <algorithm>

using namespace std;

double num_attribute = 16;


struct horse{
	vector<double> attrib;
	string status;
};

vector<horse> horses;

void print(vector<horse> n){
	for(unsigned int i=0; i<n.size(); i++){
		cout << i << ": " << n[i].attrib[0] << " " << n[i].attrib[1] << " " << n[i].attrib[2] << " " << n[i].attrib[3] << " " << n[i].attrib[4] << " " << n[i].attrib[5] << " " << n[i].attrib[6];
		cout << " " <<  n[i].attrib[7] << " " << n[i].attrib[8] << " " << n[i].attrib[9] << " " << n[i].attrib[10] << " " << n[i].attrib[11] << " " << n[i].attrib[12];
		cout << n[i].attrib[13] << " " << n[i].attrib[14] << " " << n[i].attrib[15] << " " << n[i].status << endl;
	}
}

int count_healthy(vector<horse> n){
	int sum = 0;
	for(unsigned int i=0; i<n.size(); i++){
		if(n[i].status == "healthy."){
			sum++;
		}
	}
	return sum;
}

int count_colic(vector<horse> n){
	int sum = 0;
	for(unsigned int i=0; i<n.size(); i++){
		if(n[i].status == "colic."){
			sum++;
		}
	}
	return sum;
}

double entropy(double total, double positive, double negative){
	double result = -positive/total*((log(positive/total)) / log((double)2)) - (negative/total*((log(negative/total))/log((double)2)));
	return result;
}

double remainder(vector<horse> n, int attribute, double threshold){
	vector<double> list;
	for(unsigned int i=0; i<n.size(); i++){
		list.push_back(n[i].attrib[attribute]);
	}
	
	vector<horse> left, right;
	for(unsigned int i=0; i<list.size(); i++){
		if(list[i] <= threshold){
			left.push_back(n[i]);
		}else {
			right.push_back(n[i]);
		}
	}
	int healthy_left = count_healthy(left);
	int colic_left = count_colic(left);
	int healthy_right = count_healthy(right);
	int colic_right = count_colic(right);
	cout << (0 * entropy(left.size(), healthy_left, colic_left))<< endl;
	double pb = (left.size()/n.size() * entropy(left.size(), healthy_left, colic_left)) + (right.size()/n.size() * entropy(right.size(), healthy_right, colic_right));
	return pb;
}

double best_IG(vector<horse> n, int attribute){
	vector<double> list;
	for(unsigned int i=0; i<n.size(); i++){
		list.push_back(n[i].attrib[attribute]);
	}
	double max = *max_element(list.begin(), list.end());
	double min = *min_element(list.begin(), list.end());
	int healthy, colic;
	healthy = count_healthy(n);
	colic = count_colic(n);
	double I = entropy(n.size(), healthy, colic);
	double current_val = min;
	double index = current_val;
	double MAX_I = I - remainder(n, attribute, current_val);
	while(current_val <= max){
		double TEMP_I;
		TEMP_I = I - remainder(n, attribute, current_val);
		current_val = current_val + 0.1;
		if(TEMP_I > MAX_I){
			MAX_I = TEMP_I;
			index = current_val;
		}
	}
	return MAX_I;
}
void read(){
	std::ifstream infile("train.txt");
	for(;;){
		if(infile.eof()){
			break;
		}
		horse temp;
		for(int i=0; i<16; i++){
			int stat;
			infile >> stat;
			temp.attrib.push_back((double)stat);
			infile >> temp.status;
		}
		infile >> temp.status;
		horses.push_back(temp);
	}
	return;
}
int main(){
	read();
//	cout << find_val(horses, 1) << endl;
//	cout << (entropy(3,1,2)) << endl;
//	cout << remainder(horses, 2, 86) << endl;
	print(horses);
//	cout << "darren poon" << endl;
	return 0;
}
