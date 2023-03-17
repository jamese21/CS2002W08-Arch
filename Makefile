CC = clang
CFLAGS = -c -Wall -Wextra -O0
X86FLAGS = -target x86_64
ARMFLAGS = -target arm64
AFLAGS = -c -S -Wall -Wextra -fno-verbose-asm
LFLAGS = -Wall -Wextra
DEPS = badrandom.h

all: main badrandom0.s badrandom2.s badrandom0-x86.s badrandom2-x86.s badrandom1-arm.s
clean:
	rm -f *.o main badrandom0.s badrandom1.s badrandom2.s badrandom3.s badrandom0-x86.s badrandom1-x86.s badrandom2-x86.s badrandom3-x86.s badrandom0-arm.s badrandom1-arm.s badrandom2-arm.s badrandom3-arm.s

main: main.o badrandom.o $(DEPS)
	${CC} ${LFLAGS} main.o badrandom.o -o main

main.o: main.c $(DEPS)
	${CC} ${CFLAGS} main.c -o main.o

badrandom.o: badrandom.c $(DEPS)
	${CC} ${CFLAGS} badrandom.c -o badrandom.o

badrandom0.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS}   -O0 badrandom.c -o badrandom0.s

badrandom1.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS}   -O1 badrandom.c -o badrandom1.s

badrandom2.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS}   -O2 badrandom.c -o badrandom2.s

badrandom3.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS}   -O3 badrandom.c -o badrandom3.s

badrandom0-x86.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} ${X86FLAGS}  -O0 badrandom.c -o badrandom0-x86.s

badrandom1-x86.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} ${X86FLAGS}  -O1 badrandom.c -o badrandom1-x86.s

badrandom2-x86.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} ${X86FLAGS}  -O2 badrandom.c -o badrandom2-x86.s

badrandom3-x86.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} ${X86FLAGS}  -O3 badrandom.c -o badrandom3-x86.s

badrandom0-arm.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} -O0 ${ARMFLAGS} badrandom.c -o badrandom0-arm.s

badrandom1-arm.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} -O1 ${ARMFLAGS} badrandom.c -o badrandom1-arm.s

badrandom2-arm.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} -O2 ${ARMFLAGS} badrandom.c -o badrandom2-arm.s

badrandom3-arm.s: badrandom.c $(DEPS)
	${CC} ${AFLAGS} -O3 ${ARMFLAGS} badrandom.c -o badrandom3-arm.s

