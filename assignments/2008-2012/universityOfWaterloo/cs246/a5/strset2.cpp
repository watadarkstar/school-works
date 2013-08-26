#include "strset2.h"
#include <sstream>				// istringstream

using namespace std;

void sort(strNode * firsts);		// function to sort a linked list

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
		strNode * temp;
		temp = new strNode;		// allocate a node to insert a new item
		temp->string = sub;
		temp->next = first;
		first = temp;			// new first of the list
	}
	first = first->next;			// pop off the first item since it is empty
	sort(first);

}

// copy constructor
strSet::strSet(const strSet & copy){
	first = NULL;
	for(strNode * temp = copy.first; temp!=NULL; temp = temp->next){
			strNode * copy_new;
			copy_new = new strNode;
			copy_new->string = temp->string;
			copy_new->next = first;
			first = copy_new;
	}
	sort(this->first);
}

// destructor
strSet::~strSet(){
	strNode * current = first;
	while(current!=NULL){
		strNode * next = current->next;
		delete current;
		current = next;
	}
	first = NULL;
}


// delete first
void strSet::nullify (){
	strNode * temp;
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
	strNode * temp;
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
	strNode * temp;
	temp = first;
	while(temp!=NULL){
		cout << temp->string << endl;
		temp = temp->next;
	}
}


// check if the string is a member of the linked list
bool strSet::isMember (std::string s) const{
	for (strNode * temp = first; temp!=NULL; temp = temp->next){
		if(temp->string == s){
			return true;
		}
	}
	return false;
}

// sort the linked list
void sort( strNode *heads){
	// insertion sort
    strNode * firsts;			// intitialize
	strNode * seconds;
	strNode * temps;
    firsts= heads;
 
    while(firsts!=NULL){
    seconds = firsts->next;
 
        while(seconds!= NULL){
            if(firsts->string > seconds->string){
                temps = new strNode();
                temps->string=firsts->string;
                firsts->string=seconds->string;
                seconds->string=temps->string;
                delete temps;
            }
 
        seconds=seconds->next;
        }
 
    firsts=firsts->next;
    }
}

// the union operator is normally same as the previous version
// the differences are replace the strVector into linked list
strSet  strSet::operator +  (const strSet& rtSide){
	strSet result;
	result.first = NULL;
	// copy the leftside to the "result" linked list;
	for(strNode * temp = first; temp!=NULL; temp = temp->next){
		strNode * add_node;
		add_node = new strNode;
		add_node->string = temp->string;
		add_node->next = result.first;
		result.first = add_node;
	}
	

	// add string that does not in leftside but in rightside to result
	for(strNode * rt_temp = rtSide.first ; rt_temp!=NULL ; rt_temp = rt_temp->next){
		bool check = true;
		strNode * temp;
		for (temp = first; temp!=NULL; temp = temp->next){
			if (temp->string == rt_temp->string){
				check = false;
			}
		}
		
		if (check){
			strNode * new_temp;
			new_temp = new strNode;
			new_temp->string = rt_temp->string;
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
	for(strNode * rt_temp = rtSide.first ; rt_temp!=NULL ; rt_temp = rt_temp->next){
		bool check = false;
		strNode * temp;
		for (temp = first; temp!=NULL; temp = temp->next){
			if (temp->string == rt_temp->string){
				check = true;
			}
		}
		
		// put the element into the result
		if (check){
			strNode * new_temp;
			new_temp = new strNode;
			new_temp->string = rt_temp->string;
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
	strNode * temp;
	
	// find the differences that exists in leftside but not in rightside
	for (temp = first; temp!=NULL; temp = temp->next){
		bool check = true;
		for(strNode * rt_temp = rtSide.first; rt_temp!=NULL; rt_temp = rt_temp->next){
			if (temp->string == rt_temp->string){
				check = false;
				break;
			}
		}

		if (check){
			strNode * new_temp;
			new_temp = new strNode;
			new_temp->string = temp->string;
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
		strNode * rt_temp;
		strNode * lft_temp;
		rt_temp = rtSide.first;
		lft_temp = first;
		while (lft_temp!=NULL){
			if (lft_temp->string != rt_temp->string){
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

		for(strNode * temp = rtSide.first; temp!=NULL; temp = temp->next){
			strNode * copy;
			copy = new strNode;
			copy->string = temp->string;
			copy->next = first;
			first = copy;
		}
	}
	sort(this->first);

	return * this;
}


