#include <iostream>
#include <iomanip>
using namespace std;

// function that prints title
void printTitle(){
	cout << setw(5) << "Month" << setw(7) << "  Charge" << setw(7) <<
		"  Interest" << setw(10) << "    Payment " << setw(8) << 
		"   Principle" << endl;
}

// function that prints stats for each month
void printLine(int m, double c, double i, double pa, double pr){
	cout << setw(5) << m << "\t" << setw(5) << c << "\t" << setw(7) << 
		i << "\t" << setw(10) << pa << setw(13) << pr << endl;
}


int main(){
	//initializing
	double principle = 1456.21;
	double interest_rate = 0.03;
	double charge = 0.76;
	double payment = 104.11;
	int month = 1;
	principle = principle - 14.54;
	cout.setf(ios::fixed);
	cout.setf(ios::showpoint);
	cout.precision(2);

	printTitle();
	// payment for the first three months & halt if payments exceed
	for (month; month <= 3; month++){
		double interest = principle * interest_rate;
		principle = principle + interest + charge;
		printLine(month, charge, interest, 0.00, principle);
	}
	charge = 0;

	// payment for the rest of the months
	while (principle > 0){
		if (principle < payment){
			break;
		}else {
			double interest = principle * interest_rate;
			principle = principle - payment + interest;
			printLine(month, charge, interest, payment, principle);
			month++;
		}
	}

	// payment for the last month payment
	double interest = principle * interest_rate;
	principle = principle + interest;
	payment = principle;
	principle = principle - payment;
	printLine(month, charge, interest, payment, principle);

	return 0;
}

