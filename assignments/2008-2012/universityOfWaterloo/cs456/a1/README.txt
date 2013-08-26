Name: Darran Poon
Userid: dyhpoon

Name: Di Wei Su
Userid: dwsu


Note: 1. The program was built and tested on "linux028.student.cs.uwaterloo.ca"

      2. Java version "1.6.0_20"
         OpenJDK Runtime Environment (IcedTea6 1.9.10) (6b20-1.9.10-0ubuntu1~10.10.2)
 	 OpenJDK 64-Bit Server VM (build 19.0-b09, mixed mode)
		 
      3. Javac 1.6.0_20

Issue the following command to run the program:

Step1	"make"  -- use "make" to compile the program

Step2	"chmod a+u *.sh" -- modify the script permission

Step3	In host1 issue command "./emulator.sh"
        the script is equivalent to "./nEmulator-linux386 9951 localhost 9954 9953 localhost 9952 1 0.2 0"
								  
Step4	In host2 issue command "./receiver.sh"
        the script is equivalent to "java receiver localhost 9953 9954 out.txt

Step5	In host3 issue command "./sender.sh" 
	the script is equivalent to "java sender localhost 9951 9952 input.txt

