#include <stdio.h>

int sum_divisor = 0; /* global variable that prints factors of the num */

void sum(int n) {
    if ( n == 1 ) { /* if n = 1 */
       printf ("1");
    } else {
       printf ("1");
       sum_divisor = sum_divisor + 1;
       for (int i = 2; i < n; i++) { /* to find all possible factors of n */
           if ( n % i == 0) {
               printf ("+%d",i);
               sum_divisor = sum_divisor + i; /* the total value of factors */
           }
      }
    printf ("=%d",sum_divisor);
    return;
   }
}

extern int sum_divisor;
