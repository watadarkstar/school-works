Name: Darran Poon
Userid: dyhpoon


Note: 1. The program was built and tested on "linux024.student.cs.uwaterloo.ca"

      2. gcc version 4.4.5 (Ubintu/Linaro 4.4.4-14ubintu5.1)

      3. GNU Make 3.81

Issue the following command to run the program:

Step1  "make"  -- use "make" to compile the program

Step2  "chmod u+x *.sh" -- to change the script permission

Step3  In Host X, run "./nse-linux386 localhost 9980"

Step4  In Host Y, run "./router 1 localhost 9980 9901"
       In Host Y, run "./router 2 localhost 9980 9902"
       In Host Y, run "./router 3 localhost 9980 9903"
       In Host Y, run "./router 4 localhost 9980 9904"
       In Host Y, run "./router 5 localhost 9980 9905"
