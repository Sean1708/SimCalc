#include <read.h>

/**
 * Contains the return value of readline and is used to prevent memory leaks
 * when calling readline from rl_gets().
 */
static char* readline_line;

/**
 * Read a line from stdin using GNU Readline and save it in history if not
 * blanck. Taken from the GNU Readline docs.
 */
char* rl_gets(char* prompt) {
    // if string has been allocated, free it to prevent memory leaks
    if (readline_line) {
        free(readline_line);
        readline_line = NULL;
    }

    readline_line = readline(prompt);

    // only add to history list if line has text in it
    if (readline_line && *readline_line) add_history(readline_line);

    return readline_line;
}
