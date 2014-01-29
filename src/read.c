#include <read.h>
#include <global.h>

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

    if (prompt == NULL) {
        rl_line = non_readline_readline();
    } else {
        rl_line = readline(prompt);
    }

    /* only add to history list if line has text in it */
    if (rl_line && *rl_line) {
        add_history(rl_line);

        /* append newline to the end so bison parses properly */
        int len = strlen(rl_line);
        void* memcheck = realloc(rl_line, (len + 2) * sizeof(char));

        if (memcheck != NULL) {
            rl_line[len] = '\n';
            rl_line[len+1] = '\0';
        } else {
            yyerror("memory error");
            rl_line[0] = '\0';
        }
    }


    return rl_line;
}


/**
 * Read a line from stdin without using readline since it causes problems in
 * quiet mode.
 */
char* non_readline_readline(void) {
    int length = 256;
    /* seems large enough to hold most equations */
    char* str = calloc(length, sizeof(char));

    int i = 0;
    int reading = 1;
    while (reading) {
        for (; i < length - 1; i++) {
            char c = getc(stdin);
            
            if (c == EOF && i == 0) {
                /* to behave like readline */
                return NULL;
            } else if (c == '\n' || c == EOF) {
                str[i] = '\0';
                reading = 0;
                break;
            } else {
                str[i] = c;
            }
        }

        /* only realloc if we haven't reached the end of line */
        if (reading) {
            length += 256;
            void* memcheck = realloc(str, length * sizeof(char));

            if (memcheck == NULL) {
                yyerror("memory error");
                str[0] = '\0';

                return str;
            }
        }
    }

    
    return str;
}
