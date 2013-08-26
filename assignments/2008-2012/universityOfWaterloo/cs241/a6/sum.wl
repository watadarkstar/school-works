int wain(int a, int b){
	int sum = 0;
	int num1 = 0;
	int num2 = 0;
	if (a > b) {
		num1 = a;
		num2 = b;
	}
	else {}
	if (b > a) {
		num1 = b;
		num2 = a;
	}
	else {}
	if (a == b) {
		sum = a;
	}
	else {}
	while (num1 >= num2) {
		sum = sum + num2;
		num2 = num2 + 1;
	}
	return sum;
}

