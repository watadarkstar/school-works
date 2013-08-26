#include<stdio.h>
#include<stdlib.h>

/*
Darren Poon
CS 136 F09 Assignment 9 Question 1
(counter)
*/

void countchars(){
	int characters[25];
	int i = 0;
	int ch;
	while(i < 26){ // to create an array with 26 elements
		characters[i]=0;
		i++;
	}
	for (ch = getchar(); ch != EOF; ch = getchar()){ // counting the characters
		if ((ch == 'a') || (ch == 'A')){
			characters[0] = characters[0] + 1;
		}
		if ((ch == 'b') || (ch == 'B')){
			characters[1] = characters[1] + 1;
		}
		if ((ch == 'c') || (ch == 'C')){
			characters[2] = characters[2] + 1;
		}
		if ((ch == 'd') || (ch == 'D')){
			characters[3] = characters[3] + 1;
		}
		if ((ch == 'e') || (ch == 'E')){
			characters[4] = characters[4] + 1;
		}
		if ((ch == 'f') || (ch == 'F')){
			characters[5] = characters[5] + 1;
		}
		if ((ch == 'g') || (ch == 'G')){
			characters[6] = characters[6] + 1;
		}
		if ((ch == 'h') || (ch == 'H')){
			characters[7] = characters[7] + 1;
		}
		if ((ch == 'i') || (ch == 'I')){
			characters[8] = characters[8] + 1;
		}
		if ((ch == 'j') || (ch == 'J')){
			characters[9] = characters[9] + 1;
		}	
		if ((ch == 'k') || (ch == 'K')){
			characters[10] = characters[10] + 1;
		}	
		if ((ch == 'l') || (ch == 'L')){
			characters[11] = characters[11] + 1;
		}	
		if ((ch == 'm') || (ch == 'M')){
			characters[12] = characters[12] + 1;
		}	
		if ((ch == 'n') || (ch == 'N')){
			characters[13] = characters[13] + 1;
		}	
		if ((ch == 'o') || (ch == 'O')){
			characters[14] = characters[14] + 1;
		}	
		if ((ch == 'p') || (ch == 'P')){
			characters[15] = characters[15] + 1;
		}	
		if ((ch == 'q') || (ch == 'Q')){
			characters[16] = characters[16] + 1;
		}	
		if ((ch == 'r') || (ch == 'R')){
			characters[17] = characters[17] + 1;
		}	
		if ((ch == 's') || (ch == 'S')){
			characters[18] = characters[18] + 1;
		}	
		if ((ch == 't') || (ch == 'T')){
			characters[19] = characters[19] + 1;
		}	
		if ((ch == 'u') || (ch == 'U')){
			characters[20] = characters[20] + 1;
		}	
		if ((ch == 'v') || (ch == 'V')){
			characters[21] = characters[21] + 1;
		}	
		if ((ch == 'w') || (ch == 'W')){
			characters[22] = characters[22] + 1;
		}	
		if ((ch == 'x') || (ch == 'X')){
			characters[23] = characters[23] + 1;
		}	
		if ((ch == 'y') || (ch == 'Y')){
			characters[24] = characters[24] + 1;
		}	
		if ((ch == 'z') || (ch == 'Z')){
			characters[25] = characters[25] + 1;
		}
	}
	for (int i = 0; i<26; i++){ // print the array
		printf("%d ", characters[i]);
	}
	return;
}
