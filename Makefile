# THE VARIABLES
CFLAGS = -g  -I include  -L build

vpath %.h       include
vpath %.c       src
vpath %_tests   tests
vpath %_tests.c tests


# THE TESTS


# THE CLEANER
clean:
	rm    -f     tests/*_tests
	rm    -f     `find . -name "*.o"`
	rm    -rf    build
	rm    -rf    `find . -name "*.dSYM"`
