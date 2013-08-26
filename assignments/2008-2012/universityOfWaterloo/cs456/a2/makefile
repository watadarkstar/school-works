#  CS 456 A2

CC = g++
CCFLAGS = -g -O0 -Wall

OBJECTS1 = router.o
EXEC1 = router


OBJECTS = ${OBJECTS1}
EXECS = ${EXEC1} 

##################################################################

.PHONY : all clean

all : ${EXECS}

${EXEC1} : ${OBJECTS1}
	${CC} ${CCFLAGS} ${OBJECTS1} -o $@

${EXEC2} : ${OBJECTS2}
	${CC} ${CCFLAGS} ${OBJECTS2} -o $@

#################################################################


