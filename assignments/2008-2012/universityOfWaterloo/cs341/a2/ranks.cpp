#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace std;

// set up a struct for restaurants
struct restaurant{
	int price;
	int quality;
	int rank;
	int order;
};

// find the dominating restaurant
bool dominate(restaurant r1, restaurant r2){
	if ((r1.quality > r2.quality) && (r1.price < r2.price)){
		return true;
	}else {
		return false;
	}
}

// print the quality and price for testing purpose
void print(vector<restaurant> inst){
	for (unsigned int i = 0; i < inst.size(); i++){
		cout << "the quality is " << inst[i].quality 
			<< " and the price is " << inst[i].price
			<< " rank is " << inst[i].rank << endl;
	}
}

// use for sorting the vector back into the original order
bool my_cmp(const restaurant &r1, const restaurant &r2){
	if (r1.order < r2.order){
		return true;
	}else {
		return false;
	}
}

vector<restaurant> save;				// read the input
vector<restaurant> rest_rank;			// implement save and put into rest_rank


vector<restaurant> restaurant_rank(vector<restaurant> r, int n){
	// base case
	if (n == 1){
		r[0].rank = 0;
		return r;
	}
	
	// ******** DIVIDE PART ***********
	// calculate the length of the vector in divide part
	vector<restaurant> temp1;
	for (unsigned int b = 0; b < floor((double)(r.size()/2)); b++){
		temp1.push_back(r[b]);
	}
	vector<restaurant> temp2;
	for (unsigned int b = (unsigned int)(floor((double)r.size()/2)); b < r.size(); b++){
		temp2.push_back(r[b]);
	}
	
	vector<restaurant> left = restaurant_rank(temp1, (int)temp1.size());
	vector<restaurant> right = restaurant_rank(temp2, (int)temp2.size());
	

	// ******* COMBINE PART ************
	vector<restaurant> combine;				// to store all the restaurants in the order of from most decent to least decent
	vector<restaurant> temp;				// to store the restaurants that cant be compare for instance
	unsigned int i = 0, j = 0;				// iterator
	int rank_num = 0;						// rank
	
	while (true){
		// case1 : left is empty & no restaurant is non-comparable
		if (i == left.size() && temp.empty()){
			for (j; j < right.size(); j++){
				if (dominate(combine[combine.size()-1],right[j])){
					right[j].rank = rank_num;
					combine.push_back(right[j]);
					rank_num++;
				}else {
					right[j].rank = rank_num - 1;
					combine.push_back(right[j]);
				}
			}
			return combine;
		
			// case2: right is empty & no restaurant is non-comparable
		}else if (j == right.size() && temp.empty()){
			for(i; i < left.size(); i++){
				if (dominate(combine[combine.size()-1],left[i])){
					left[i].rank = rank_num;
					combine.push_back(left[j]);
					rank_num++;
				}else {
					left[i].rank = rank_num - 1;
					combine.push_back(left[i]);
				}
			}

			return combine;
		
			// case3: either left or right is empty and some restaurants is non-comparable
		}else if (!temp.empty() && (i == left.size() || j == right.size())){
			for (unsigned int k = 0; k < temp.size(); k++){
				temp[k].rank = rank_num;
				combine.push_back(temp[k]);
			}
			rank_num++;
			temp.clear();

			if (i == left.size()){
				while(j < right.size()){
					if (dominate(combine[combine.size()-1],right[j])){
						right[j].rank = rank_num;
						combine.push_back(right[j]);
						j++;
						rank_num;
					}else {
						right[j].rank = rank_num - 1;
						combine.push_back(right[j]);
					}
				}
			
			}else if (j == left.size()){
				while(i < left.size()){
					if (dominate(combine[combine.size()-1],left[i])){
						left[i].rank = rank_num;
						combine.push_back(left[i]);
						i++;
						rank_num;
					}else{
						left[i].rank = rank_num - 1;
						combine.push_back(left[i]);
					}
				}
			}
			return combine;
		
		// compare left[i] and right[j], then put the dominating restaurant to combine
		}else if (dominate(left[i],right[j]) && temp.empty()){
			if(combine.empty()){
				left[i].rank = rank_num;
				combine.push_back(left[i]);
				i++;
				rank_num++;
			}else {
				if (!dominate(combine[combine.size()-1],left[i])){
					left[i].rank = rank_num - 1;
					combine.push_back(left[i]);
					i++;
				}else {
					left[i].rank = rank_num;
					combine.push_back(left[i]);
					i++;
					rank_num++;
				}
			}
		
		// same
		}else if (dominate(right[j], left[i]) && temp.empty()){
			if(combine.empty()){
				right[j].rank = rank_num;
				combine.push_back(right[j]);
				j++;
				rank_num++;
			}else {
				if (!dominate(combine[combine.size()-1],right[j])){
					right[j].rank = rank_num - 1;
					combine.push_back(right[j]);
					j++;
				}else {
					right[j].rank = rank_num;
					combine.push_back(right[j]);
					j++;
					rank_num++;
				}
			}

		// compare left[i] and right[j] and the restaurants which is non-comparable before
		}else if (dominate(left[i],right[j]) && !temp.empty()){
			unsigned int k;
			for (k = 0; k < temp.size(); k++){
				if (dominate(temp[k], left[i])){
					for (unsigned int c = 0; c < temp.size(); c++){
						temp[c].rank = rank_num;
						combine.push_back(temp[c]);
					}
					rank_num++;
					temp.clear();
					break;
				}
			}
			if (k == temp.size()){
				left[i].rank = rank_num;
				temp.push_back(left[i]);
				i++;
				rank_num++;
			}

		// same
		}else if (dominate(right[j],left[i]) && !temp.empty()){
			unsigned int k;
			for (k = 0; k < temp.size(); k++){
				if (dominate(temp[k], right[j])){
					for (unsigned int c = 0; c < temp.size(); c++){
						temp[c].rank = rank_num;
						combine.push_back(temp[c]);
					}
					rank_num++;
					temp.clear();
					break;
				}
			}
			if (k == temp.size()){
				right[j].rank = rank_num;
				temp.push_back(right[j]);
				j++;
				rank_num++;
			}
		
		// for left[i] and right[j] put it into combine or temp depends on the situations
		}else {
			if (!combine.empty()){
				bool check = true;
				
				// if last restaurant in combine is dominating to left[i]
				if (dominate(combine[combine.size()-1],left[i])){
					temp.push_back(left[i]);
					i++;

					// if last restaurants in combine and left[i] is non-comparable
				}else if (!dominate(combine[combine.size()-1],left[i]) && !dominate(left[i],combine[combine.size()-1])){
					bool check_previous = true;

					// check the possible restaurant in combine that have the same rank
					for (unsigned int index = 0; index < combine.size(); index++){
						if (dominate(combine[index],left[i]) && combine[index].rank == rank_num-1){
							left[i].rank = rank_num;
							combine.push_back(left[i]);
							rank_num++;
							check_previous = false;
							break;
						}
					}
					if (check_previous){
						left[i].rank = rank_num - 1;
						combine.push_back(left[i]);
					}
					i++;
					
				}

				// if last restaurant in combine is dominating to right[j]
				if (dominate(combine[combine.size()-1],right[j])){
					temp.push_back(right[j]);
					j++;

					// if last restaurants in combine and right[j] is non-comparable
				}else if (!dominate(combine[combine.size()-1],right[j]) && !dominate(right[j],combine[combine.size()-1])){
					bool check_previous = true;
					for (unsigned int index = 0; index < combine.size(); index++){
						if (dominate(combine[index],right[j]) && combine[index].rank == rank_num-1){
							right[j].rank = rank_num;
							combine.push_back(right[j]);
							rank_num++;
							check_previous = false;
							break;
						}
					}
					if (check_previous){
						right[j].rank = rank_num - 1;
						combine.push_back(right[j]);
					}
					j++;
				}

				// put both left[i] and right[j] into temp
			}else {
				temp.push_back(left[i]);
				temp.push_back(right[j]);
				i++;
				j++;
			}
		}
	}
}

int main(){
	// read integer n
	ifstream infile("input.txt");
	int n;
	infile >> n;

	// read the second line
	for (int i = 0; i < n; i++){
		restaurant temp;
		infile >> temp.quality;
		infile >> temp.price;
		temp.order = i;
		temp.rank = -1;
		save.push_back(temp);
	}

	rest_rank = restaurant_rank(save, n);

	// sort it back into the original order
	sort(rest_rank.begin(), rest_rank.end(), my_cmp);
	
	// output
	ofstream outfile("output.txt");
	for (unsigned int i = 0; i < rest_rank.size(); i++){
		outfile << rest_rank[i].rank << " ";
	}

	return 0;
}

