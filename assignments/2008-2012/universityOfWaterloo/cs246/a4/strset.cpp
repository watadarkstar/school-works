#include "strset.h"
#include <sstream>				// istringstream
#include <algorithm>			// sorting for vector

using namespace std;

// empty set
strSet::strSet(){				
}


// singleton or build with members
strSet::strSet(std::string s){
	istringstream iss(s);

	// tokenize the strings and pushback into the strVector
    while (iss)
    {
        string sub;
        iss >> sub;
        strVector.push_back(sub);
    }
	strVector.pop_back();
	// sort
	sort(strVector.begin(), strVector.end());
}


// check if strVector is already sorted or not
bool strSet::isSorted () const{
	// create a copy of strVector and sort it
	std::vector<std::string> temp;
	for(unsigned int i = 0; i<strVector.size(); i++){
		temp.push_back(strVector[i]);
	}

	// compare both vector to see if it is sorted
	sort(temp.begin(), temp.end());
	for(unsigned int i = 0; i<strVector.size(); i++){
		if(strVector[i] != temp[i]){
			return false;
		}
	}
	return true;
}

// to nullify the strVector
void strSet::nullify(){
	strVector.clear();
}

// check if strVector is null or not
bool strSet::isNull () const{
	if(strVector.empty()){
		return true;
	} else{
		return false;
	}
}

// retrun size
int strSet::SIZE() const{
	return strVector.size();
}

// print out the strVector
void strSet::output() const{
	for (unsigned int i = 0; i < strVector.size(); i++) {
		cout << strVector[i] << endl;
	}
}

// check if s is the member of strVector
bool strSet::isMember (std::string s) const{
	for (unsigned int i = 0; i < strVector.size(); i++) {
		if ( s == strVector[i] ) {
			return true;
		}
	}
	return false;
}


// Union
strSet strSet::operator +  (const strSet& rtSide){
        strSet result;
        // make a copy of vector from leftside
        for (unsigned int i = 0; i<strVector.size();i++){
                result.strVector.push_back(strVector[i]);
        }

        //add strings that does not in leftside
        for (unsigned int i = 0; i<rtSide.strVector.size();i++){
                bool check = true;
                for (unsigned int j = 0; j<result.strVector.size();j++){
                        if(rtSide.strVector[i] == result.strVector[j]){
                                check = false;
                        }
                }
                if(check){
                        result.strVector.push_back(rtSide.strVector[i]);
                }
        }

		// sort
        sort(result.strVector.begin(), result.strVector.end());
        return result;
}


// Intersection
strSet strSet::operator *  (const strSet& rtSide){
        strSet result;
		// compare leftside and rightside to see if there are strings that exist on both sides
        for (unsigned int i = 0; i<strVector.size(); i++){
                for (unsigned int j = 0; j<rtSide.strVector.size(); j++){
                        if (strVector[i] == rtSide.strVector[j]){
                                result.strVector.push_back(strVector[i]);
                                break;
                        }
                }
        }
        return result;
}

// Subtract
strSet strSet::operator -  (const strSet& rtSide){
        strSet result;
		// check strings that only exist on leftside but not rightside
        for (unsigned int i = 0; i<strVector.size(); i++){
                unsigned int j;
                for (j = 0; j<rtSide.strVector.size(); j++){
                        if(strVector[i] == rtSide.strVector[j]){
                                break;
                        }
                }
                if(j == rtSide.strVector.size()){
                        result.strVector.push_back(strVector[i]);
                }
        }
        return result;
}

// Assign
strSet& strSet::operator =  (const strSet& rtSide){
        bool end = false;
		// check leftside and rightside whether they are the same
        if (rtSide.strVector.size() == this->strVector.size()){
                unsigned int i = 0;
                for (i = 0; i<strVector.size(); i++){
                        if(this->strVector[i]!=rtSide.strVector[i]){
                                break;
                        }
                }
                if (i == this->strVector.size()){
                        end = true; // LHS = RHS no change
                }
        }
        if (!end){
			// delete leftside
			this->nullify();
			// copying rightside to the leftside
			for(unsigned int j = 0; j<rtSide.strVector.size(); j++){
				strVector.push_back(rtSide.strVector[j]);
			}
		}
		return *this;
}

