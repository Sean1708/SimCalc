#include <stdio.h>
#include <stdlib.h>
#include <read.h>


int main(int argc, char* argv[]) {
    char* line = NULL;

    while (1) {
        line = rl_gets(">> ");
        printf("%s\n", line);

        if (line[0] == 'e') break;
    }

    if (line) free(line);
    return 0;
}
