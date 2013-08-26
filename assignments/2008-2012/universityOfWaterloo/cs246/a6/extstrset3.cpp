#include "extstrset3.h"
#include <sstream>				// istringstream

using namespace std;

extStrSet extStrSet::operator == (const extStrSet& rtSide){
	extStrSet result;
	myNode * ltfirst, * rtfirst;
	rtfirst = rtSide.first;
	ltfirst = this->first;
	if (this->SIZE() == rtSide.SIZE()){
		for(ltfirst; ltfirst!=NULL; ltfirst = ltfirst->next){
			if (ltfirst->str != rtfirst->str){
				result = extStrSet("false");
			}else{
				rtfirst = rtfirst->next;
			}
		}
		if(ltfirst == NULL){
			result = extStrSet("true");
		}
	}else {
		result = extStrSet("false");
	}
	return result;
}

extStrSet extStrSet::operator <  (const extStrSet& rtSide){
	extStrSet result;
	// check whether left and right are coincide
	myNode * left, * right;
	left = this->first;
	right = rtSide.first;
	if (this->SIZE() == rtSide.SIZE()){
		for (left; left!=NULL; left = left->next){
			if (left->str == right->str){
				right = right->next;
			}else{
				break;				// break if not the same
			}
		}
		if (left == NULL){
			result = extStrSet("false");
			return result;
		}
	}
	
	// otherwise check rhs = rhs + lhs (if lhs is subsets of rhs, then rhs should
	// not have new members.
	strSet tmp, rhs;
	rhs = rtSide;
	tmp = *this + rtSide;

	// downcasting
	extStrSet a = ss2extss(tmp);
	extStrSet b = ss2extss(rhs);

	if ((a == b).first->str == "true"){
		result = extStrSet("true");
	}else {
		result = extStrSet("false");
	}
	
	return result;
}

extStrSet extStrSet::operator >  (const extStrSet& rtSide){
	extStrSet result;
	// check whether left and right are coincide
	myNode * left, * right;
	left = this->first;
	right = rtSide.first;
	if (this->SIZE() == rtSide.SIZE()){
		for (left; left!=NULL; left = left->next){
			if (left->str == right->str){
				right = right->next;
			}else{
				break;				// break if not the same
			}
		}
		if (left == NULL){
			result = extStrSet("false");
			return result;
		}
	}

	// otherwise check rhs = rhs + lhs (if lhs is supersets of rhs, then rhs should
	// have new members.
	strSet tmp, rhs;
	rhs = rtSide;
	tmp = *this + rtSide;

	// downcasting
	extStrSet a = ss2extss(tmp);
	extStrSet b = ss2extss(rhs);
	
	if ((a == b).first->str == "false"){
		result = extStrSet("true");
	}else {
		result = extStrSet("false");
	}
	
	return result;
}


extStrSet::extStrSet ( ){
	first = NULL;
}

// essentially just same as strSet
extStrSet::extStrSet (std::string s){
	first = NULL;				// initialize the linked list
	istringstream iss(s);
	while(iss){					// add members into the list
		string sub;
		iss >> sub;
		myNode * temp;
		temp = new myNode;		// allocate a node to insert a new item
		temp->str = sub;
		temp->next = first;
		first = temp;			// new first of the list
	}
	first = first->next;			// pop off the first item since it is empty
	
	this->isSorted();			// sort
}

std::ostream& operator << (std::ostream & os, const extStrSet & ess){
	extStrSet::myNode * temp;
	temp = ess.first;
	for(temp; temp!=NULL; temp = temp->next){
		os << temp->str << endl;
	}
	return os;
}


