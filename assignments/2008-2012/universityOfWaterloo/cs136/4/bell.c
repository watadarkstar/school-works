#include <stdio.h>
        
int factorial(int p) { /* to find the factorial given a number */
    int sum1 = 1;      
    if (p == 0) {   /* since 0!=1 */
       sum1 = 1;
    } else if (p == 1) {   /* and 1!=1 */
       sum1 = 1;
    } else {  /* for number that is >=2, for example 3!=2X3 */
      for (int q = 2; q<=p; q = q++) {
           sum1 = sum1 * q;
    }
    return sum1;
}

int bell(int n) {
    int sum = 0;
    if ( n == 0) {   /* since base case is 1 if k=0 */
        sum = sum + 1;
    } else {
        for (int i = 1; i<=n-1; i++) /* sum up all the combination */
          sum = sum + (factorial(n-1)/(factorial(i) * factorial(n-1-i)));
          return bell (n-1)
    }
    return sum;
}
