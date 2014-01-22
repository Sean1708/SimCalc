#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <read.h>
#include <parse.h>
#include <lex.h>


int main(int argc, char* argv[]) {
    char* line = NULL;

    while (1) {
        line = rl_gets(">> ");

        if (line == NULL) {
            printf("Goodbye!\n");
            break;
        } else {
            YY_BUFFER_STATE buf = yy_scan_string(line);
            yyparse();
            yy_delete_buffer(buf);
        }
    }

    if (line) free(line);
    return 0;
}
