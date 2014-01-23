#include <read.h>

/**
 * Contains the return value of readline and is used to prevent memory leaks
 * when calling readline from rl_gets().
 */
static char* rl_line;

/**
 * Read a line from stdin using GNU Readline and save it in history if not
 * blank. Taken from the GNU Readline docs.
 */
char* rl_gets(char* prompt) {
    /* if string has been allocated, free it to prevent memory leaks */
    if (rl_line) {
        free(rl_line);
        rl_line = NULL;
    }

    rl_line = readline(prompt);

    /* only add to history list if line has text in it */
    if (rl_line && *rl_line) {
        add_history(rl_line);

        /* append newline to the end so bison parses properly */
        /* int len = strlen(rl_line);
        void* memcheck = realloc(rl_line, len + 2);

        if (memcheck != NULL) {
            rl_line[len] = '\n';
            rl_line[len+1] = '\0';
        } else {
            fprintf(stderr, "! memory error\n");

            rl_line[0] = '\n';
            rl_line[1] = '\0';
        }*/
    }


    return rl_line;
}
