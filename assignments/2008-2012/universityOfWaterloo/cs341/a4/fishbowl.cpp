#include <vector>		//vector
#include <fstream>
#include <iostream>		//IO
#include <algorithm>	//sort
#include <cmath>

using namespace std;

// build intervals: s-start_time f-finish_time
// v-value p-p(j) o-original order t-true if
// interval j is in optimal solution
struct interval{
	int s;
	int f;
	int v;
	int p;
	int o;
	bool t;
};

// for testing
void print(vector<interval> a){
	for (unsigned int i = 0; i < a.size(); i++){
		cout << (int)i << ":  ";
		cout << "S: " << a[i].s <<
			"  F: " << a[i].f <<
			"  V: " << a[i].v << 
			"  P: " << a[i].p << endl;
	}
}

// for sorting by finish time
bool my_cmp(const interval a, const  interval b){
	if (a.f < b.f){
		return true;
	}
	if (a.f > b.f){
		return false;
	}
	return false;
}

// for sorting back to the original order
bool back_to_o(const interval a, const interval b){
	if (a.o < b.o){
		return true;
	}
	if (a.o > b.o){
		return false;
	}
	return false;
}

vector<interval> save;
vector<int> optimal;

// find the best value of each subproblems
int optimal_DP(int j){
	if (j == -1){
		return 0;
	}else if (optimal[j] != -1){
		return optimal[j];
	}else {
		optimal[j] = max(save[j].v + optimal_DP(save[j].p), optimal_DP(j-1));
		return optimal[j];
	}
}

// find p(j)
int findp(int interval){
	int low = 0;
	int high = interval - 1;
	int bestp = -1;
	int mid;
	int start_time = save[interval].s;
	int finish_time;
	
	while(low <= high){
		mid = (low + high)/2;
		finish_time = save[mid].f;

		if ((start_time - finish_time) >= 20){
			low = mid + 1;
			bestp = mid;
		}else {
			high = mid - 1;
		}
	}
	return bestp;
}

// retrive the solution
void find_solution(int j){
	if (j == -1){
		return;
	}else {
		if (save[j].p == -1){
			if (save[j].v == optimal[j]){
				save[j].t = true;
			}else {
				find_solution(j-1);
			}
		}else if ((save[j].v + optimal[save[j].p]) == optimal[j]){
			save[j].t = true;
			find_solution(save[j].p);

		}else {
			find_solution(j-1);

		}
	}
}


int main(){
	// read integer n
	ifstream infile("input.txt");
	int n;
	infile >> n;

	for (int i = 0; i < n; i++){
		interval temp;
		infile >> temp.s;
		infile >> temp.f;
		infile >> temp.v;
		temp.p = -1;
		temp.o = i;
		temp.t = false;
		save.push_back(temp);
	}

	// sort by finish time
	sort(save.begin(), save.end(), my_cmp);
	
	// We define p(j), for an interval j, to be the largeset index
	// i < j such that i and j are disjoint.(from KT section 6.1)
	// Find p(j) for each 1<=j<=n in intervals
	// This takes O(nlogn) time,(binary search for each intervals).
	for (int i = n; i >= 1; i--){
		save[i-1].p = findp(i-1);
	}

	// initialize
	for (int i = 0; i < n; i++){
		optimal.push_back(-1);
	}
	
	// find best value for each interval j
	optimal_DP(n-1);

	// retrive the solution
	find_solution(n-1);

	// sort back to the original order
	sort(save.begin(), save.end(), back_to_o);

	// print answers
	ofstream outfile("output.txt");
	outfile << optimal[n-1] << " ";
	vector<int> temp;
	for (unsigned int i = 0; i < save.size(); i++){
		if (save[i].t == true){
			outfile << i + 1 << " ";
			temp.push_back(i);
		}
	}
	
}

