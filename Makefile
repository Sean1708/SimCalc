# THE VARIABLES
CFLAGS += -g  -I include  -L build  -l readline

vpath %.h       include
vpath %.c       src
vpath %_tests   tests
vpath %_tests.c tests


# THE BUILD
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
	rm    -f     bin/*
