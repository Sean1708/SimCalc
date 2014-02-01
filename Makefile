# THE VARIABLES
CFLAGS +=  -g -Iinclude -I. -Lbuild
LIBS +=  -lreadline
LEX = flex
YACC = bison

vpath sc        bin
vpath %.so      build
vpath %.h       include
vpath %.c       src
vpath %.l       src
vpath %.y       src
vpath %_tests   tests
vpath %_tests.c tests


# THE BUILD
all: sc mathlib.so install

install: sc
	install  bin/sc  ~/.scripts
	install  build/mathlib.so  ~/.scripts
	touch install

mathlib.so: mathlib.c
	$(CC) $(CFLAGS)  -c -o mathlib.o  src/mathlib.c
	$(CC) $(CFLAGS)  -shared -o build/mathlib.so  mathlib.o
	rm mathlib.o

sc: lex.l parse.y read.c read.h base.c base.h uservar.c uservar.h loadlib.c loadlib.h sc.c
	$(LEX)  -t src/lex.l > lex.c
	$(YACC) --report all  src/parse.y
	$(CC) $(CFLAGS)  -c -o lex.o  lex.c
	$(CC) $(CFLAGS)  -c -o parse.o  parse.c
	$(CC) $(CFLAGS)  -c -o read.o  src/read.c
	$(CC) $(CFLAGS)  -c -o base.o  src/base.c
	$(CC) $(CFLAGS)  -c -o uservar.o  src/uservar.c
	$(CC) $(CFLAGS)  -c -o loadlib.o  src/loadlib.c
	$(CC) $(CFLAGS) $(LIBS)  parse.o lex.o read.o base.o uservar.o loadlib.o src/sc.c  -o bin/sc
	rm lex.c lex.h lex.o parse.c parse.h parse.o read.o base.o uservar.o loadlib.o


# THE TESTS


# THE CLEANER - leave rm -rf `find . -name "*.dSYM"` at top
clean:
	rm    -rf    `find . -name "*.dSYM"`
	rm    -f     `find . -name "*.o"`
	rm    -f     tests/*_tests
	rm    -f     build/*
	rm    -rf    bin/*
	rm    -f     parse.output
