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


# THE BUILD
all: sc mathlib.so install tests

install: sc
	install  bin/sc  ~/.scripts
	install  build/mathlib.so  ~/.scripts
	touch install

mathlib.so: mathlib.c
	$(CC) $(CFLAGS)  -c -o mathlib.o  src/mathlib.c
	$(CC) $(CFLAGS)  -shared -o build/mathlib.so  mathlib.o
	rm mathlib.o

sc: lex.l parse.y read.c read.h base.c base.h symbol.c symbol.h extend.c extend.h command.h command.c logging.c sc.c
	$(LEX)  -t src/lex.l > lex.c
	$(YACC) --report all  src/parse.y
	$(CC) $(CFLAGS)  -c -o lex.o  lex.c
	$(CC) $(CFLAGS)  -c -o parse.o  parse.c
	$(CC) $(CFLAGS)  -c -o read.o  src/read.c
	$(CC) $(CFLAGS)  -c -o base.o  src/base.c
	$(CC) $(CFLAGS)  -c -o symbol.o  src/symbol.c
	$(CC) $(CFLAGS)  -c -o extend.o  src/extend.c
	$(CC) $(CFLAGS)  -c -o command.o  src/command.c
	$(CC) $(CFLAGS)  -c -o logging.o  src/logging.c
	$(CC) $(CFLAGS) $(LIBS)  parse.o lex.o read.o base.o symbol.o extend.o command.o logging.o src/sc.c  -o bin/sc
	rm lex.c lex.h lex.o parse.c parse.h parse.o read.o base.o symbol.o extend.o command.o logging.o


# THE TESTS
.PHONY: tests
tests:
	sh ./tests.sh

# THE CLEANER - leave rm -rf `find . -name "*.dSYM"` at top
clean:
	rm    -rf    `find . -name "*.dSYM"`
	rm    -f     `find . -name "*.o"`
	rm    -f     tests/*_tests
	rm    -f     build/*
	rm    -rf    bin/*
	rm    -f     parse.output
