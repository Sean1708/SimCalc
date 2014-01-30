#include <read.h>
#include <global.h>


static char* rl_line = NULL;

/**
 * Read a line from stdin using GNU Readline and save it in history if not
 * blank. Taken from the GNU Readline docs.
 *
 * Honestly the method seems like a bit of a hack but realloc was causing memory
 * leaks/errors galore.
 *
 * Basically, readline doesn't return a trailing newline (for ease of use with
 * add_history) but bison requires the newline to work properly. Originally this
 * was done by assigning rl_line to [non_readline_]readline then reallocating
 * the result so it had room to append a newline. Apparently this was vile sin.
 *
 * Instead I use a temporary pointer and allocate then copy instead of
 * reallocating. If a null pointer or empty string is returned then no newline
 * needs to be appended and so rl_line can just be set to temp and can be freed
 * later. Similarly, if malloc fails.
 */
char* rl_gets(char* prompt) {
    if (rl_line) {
        free(rl_line);
        rl_line = NULL;
    }

    char* temp = NULL;

    if (prompt == NULL) {
        temp = non_readline_readline();
    } else {
        temp = readline(prompt);
    }

    /* only add to history list if line has text in it */
    if (temp && *temp) {
        add_history(temp);

        /* append newline to the end so bison parses properly */
        int len = strlen(temp);
        rl_line = calloc(len + 2, sizeof(char));
        
        if (rl_line == NULL) {
            /* return empty line on memory error */
            yyerror("memory error");

            rl_line = temp;
            *rl_line = '\0';
        } else {
            char* nul_term_ptr = stpcpy(rl_line, temp);
            free(temp);

            *nul_term_ptr++ = '\n';
            *nul_term_ptr = '\0';
        }

    } else {
        rl_line = temp;
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
