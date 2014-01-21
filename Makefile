# THE VARIABLES
CFLAGS +=  -g  -I include  -L build
LIBS +=  -l readline
LEX = flex
YACC = bison

vpath %.h       include
vpath %.c       src
vpath %.l       src
vpath %.y       src
vpath %_tests   tests
vpath %_tests.c tests


# THE BUILD
calc: lex.l parse.y
	flex  -t src/lex.l > lex.c
	bison src/parse.y
	$(CC) $(CFLAGS)  -c -o lex.o  lex.c
	$(CC) $(CFLAGS)  -c -o parse.o  parse.c
	$(CC) $(CFLAGS)  parse.o lex.o  -o bin/calc
	rm lex.c lex.o parse.c parse.h parse.o

sc: read.o sc.c
	$(CC) $(CFLAGS) $(^) -o bin/sc

.INTERMEDIATE: read.o


# THE TESTS


# THE CLEANER - leave rm -rf `find . -name "*.dSYM"` at top
clean:
	rm    -rf    `find . -name "*.dSYM"`
	rm    -f     `find . -name "*.o"`
	rm    -f     tests/*_tests
	rm    -f     build/*
	rm    -rf    bin/*
