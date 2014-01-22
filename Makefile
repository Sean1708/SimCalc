# THE VARIABLES
CFLAGS +=  -g -Iinclude -I. -Lbuild
LIBS +=  -lreadline
LEX = flex
YACC = bison

vpath sc        bin
vpath %.h       include
vpath %.c       src
vpath %.l       src
vpath %.y       src
vpath %_tests   tests
vpath %_tests.c tests


# THE BUILD
all: sc

sc: lex.l parse.y read.c read.h sc.c
	$(LEX)  -t src/lex.l > lex.c
	$(YACC) src/parse.y
	$(CC) $(CFLAGS)  -c -o lex.o  lex.c
	$(CC) $(CFLAGS)  -c -o parse.o  parse.c
	$(CC) $(CFLAGS)  -c -o read.o  src/read.c
	$(CC) $(CFLAGS) $(LIBS)  parse.o lex.o read.o src/sc.c  -o bin/sc
	rm lex.c lex.h lex.o parse.c parse.h parse.o read.o


# THE TESTS


# THE CLEANER - leave rm -rf `find . -name "*.dSYM"` at top
clean:
	rm    -rf    `find . -name "*.dSYM"`
	rm    -f     `find . -name "*.o"`
	rm    -f     tests/*_tests
	rm    -f     build/*
	rm    -rf    bin/*
