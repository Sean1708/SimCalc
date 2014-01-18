#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <read.h>


int main(int argc, char* argv[]) {
    char* line = NULL;

    while (1) {
        line = rl_gets(">> ");

        if (line == NULL) {
            printf("Goodbye!\n");
            break;
        } else if (line[0] == '$') {
            printf("$ %s\n", line+1);
            if (line[1] == 'e') break;
        } else if (isdigit(line[0])) {
            printf("= %s\n", line);
        } else {
            printf("! I got none of that.\n");
        }
    }

    if (line) free(line);
    return 0;
}
