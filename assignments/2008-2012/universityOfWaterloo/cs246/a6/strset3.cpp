#include "strset3.h"
#include <sstream>				// istringstream

using namespace std;

//void sort(myNode * firsts);		// function to sort a linked list

// empty set
strSet::strSet(){
	first = NULL;				// initialize the tail of the list is null
	
}

// singleton
strSet::strSet(std::string s){
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
	//sort(first);
	this->isSorted();

}

// copy constructor
strSet::strSet(const strSet & copy){
	first = NULL;
	for(myNode * temp = copy.first; temp!=NULL; temp = temp->next){
			myNode * copy_new;
			copy_new = new myNode;
			copy_new->str = temp->str;
			copy_new->next = first;
			first = copy_new;
	}
	//sort(this->first);
	this->isSorted();
}

// destructor
strSet::~strSet(){
	myNode * current = first;
	while(current!=NULL){
		myNode * next = current->next;
		delete current;
		current = next;
	}
	first = NULL;
}


// delete first
void strSet::nullify (){
	myNode * temp;
	if (first == NULL){
		return;
	}
	while(first!=NULL){
		temp = this->first;
		first = first->next;
		delete temp;
	}
	first = NULL;
}


// check if the linked list is empty or not
bool strSet::isNull () const{
	if(first == NULL){
		return true;
	} else{
		return false;
	}
}

// give the size of the linked list
int strSet::SIZE() const{
	int i = 0;
	myNode * temp;
	temp = first;
	while(temp!=NULL){
		i = i + 1;
		if(temp->next == NULL){
			return i;
		}
		temp = temp->next;
	}
	return i;
}


// print the elements in the linked list
void strSet::output() const{
	myNode * temp;
	temp = first;
	while(temp!=NULL){
		cout << temp->str << endl;
		temp = temp->next;
	}
}


// check if the string is a member of the linked list
bool strSet::isMember (std::string s) const{
	for (myNode * temp = first; temp!=NULL; temp = temp->next){
		if(temp->str == s){
			return true;
		}
	}
	return false;
}

// sort the linked list
bool strSet::isSorted () const{
	// insertion sort
    myNode * firsts;			// intitialize
	myNode * seconds;
	myNode * temps;
    firsts= first;
 
    while(firsts!=NULL){
    seconds = firsts->next;
 
        while(seconds!= NULL){
            if(firsts->str > seconds->str){
                temps = new myNode;
                temps->str=firsts->str;
                firsts->str=seconds->str;
                seconds->str=temps->str;
                delete temps;
            }
 
        seconds=seconds->next;
        }
 
    firsts=firsts->next;
    }
	return true;
}

// the union operator is normally same as the previous version
// the differences are replace the strVector into linked list
strSet  strSet::operator +  (const strSet& rtSide){
	strSet result;
	result.first = NULL;
	// copy the leftside to the "result" linked list;
	for(myNode * temp = first; temp!=NULL; temp = temp->next){
		myNode * add_node;
		add_node = new myNode;
		add_node->str = temp->str;
		add_node->next = result.first;
		result.first = add_node;
	}
	

	// add string that does not in leftside but in rightside to result
	for(myNode * rt_temp = rtSide.first ; rt_temp!=NULL ; rt_temp = rt_temp->next){
		bool check = true;
		myNode * temp;
		for (temp = first; temp!=NULL; temp = temp->next){
			if (temp->str == rt_temp->str){
				check = false;
			}
		}
		
		if (check){
			myNode * new_temp;
			new_temp = new myNode;
			new_temp->str = rt_temp->str;
			new_temp->next = result.first;
			result.first = new_temp;
		}
	}

	return result;
}


// intersection operator
// changed the vector into linked list
strSet  strSet::operator *  (const strSet& rtSide){
	strSet result;

	// find the same element between the rtSide and the leftside
	for(myNode * rt_temp = rtSide.first ; rt_temp!=NULL ; rt_temp = rt_temp->next){
		bool check = false;
		myNode * temp;
		for (temp = first; temp!=NULL; temp = temp->next){
			if (temp->str == rt_temp->str){
				check = true;
			}
		}
		
		// put the element into the result
		if (check){
			myNode * new_temp;
			new_temp = new myNode;
			new_temp->str = rt_temp->str;
			new_temp->next = result.first;
			result.first = new_temp;
		}
	}

	return result;
}

// subtract operator
// changed the vector into linked list
strSet  strSet::operator -  (const strSet& rtSide){
	strSet result;
	myNode * temp;
	
	// find the differences that exists in leftside but not in rightside
	for (temp = first; temp!=NULL; temp = temp->next){
		bool check = true;
		for(myNode * rt_temp = rtSide.first; rt_temp!=NULL; rt_temp = rt_temp->next){
			if (temp->str == rt_temp->str){
				check = false;
				break;
			}
		}

		if (check){
			myNode * new_temp;
			new_temp = new myNode;
			new_temp->str = temp->str;
			new_temp->next = result.first;
			result.first = new_temp;
		}
	}

	return result;
}


// assign
// changed the vector into linked list
strSet& strSet::operator =  (const strSet& rtSide){
	bool end = false;
	// check leftside and rightside whether they are the same
	if (rtSide.SIZE() == this->SIZE()){
		myNode * rt_temp;
		myNode * lft_temp;
		rt_temp = rtSide.first;
		lft_temp = first;
		while (lft_temp!=NULL){
			if (lft_temp->str != rt_temp->str){
				break;
			}else {
				rt_temp = rt_temp->next;
				lft_temp = lft_temp->next;
			}
		}
		if (lft_temp == NULL){
			end = true;
		}
	}
	if (!end){
		this->nullify();

		for(myNode * temp = rtSide.first; temp!=NULL; temp = temp->next){
			myNode * copy;
			copy = new myNode;
			copy->str = temp->str;
			copy->next = first;
			first = copy;
		}
	}
	//sort(this->first);
	this->isSorted();

	return * this;
}


