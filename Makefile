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
all: sc install

install: sc
	install  bin/sc  ~/.scripts
	touch install

sc: lex.l parse.y read.c read.h base.c base.h sc.c
	$(LEX)  -t src/lex.l > lex.c
	$(YACC) --report all  src/parse.y
	$(CC) $(CFLAGS)  -c -o lex.o  lex.c
	$(CC) $(CFLAGS)  -c -o parse.o  parse.c
	$(CC) $(CFLAGS)  -c -o read.o  src/read.c
	$(CC) $(CFLAGS)  -c -o base.o  src/base.c
	$(CC) $(CFLAGS) $(LIBS)  parse.o lex.o read.o base.o src/sc.c  -o bin/sc
	rm lex.c lex.h lex.o parse.c parse.h parse.o read.o


# THE TESTS


# THE CLEANER - leave rm -rf `find . -name "*.dSYM"` at top
clean:
	rm    -rf    `find . -name "*.dSYM"`
	rm    -f     `find . -name "*.o"`
	rm    -f     tests/*_tests
	rm    -f     build/*
	rm    -rf    bin/*
	rm    -f     parse.output
