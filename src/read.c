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
 * Instead I use a rl_lineorary pointer and allocate then copy instead of
 * reallocating. If a null pointer or empty string is returned then no newline
 * needs to be appended and so rl_line can just be set to rl_line and can be freed
 * later. Similarly, if malloc fails.
 */
char* rl_gets(char* prompt) {
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
        char* temp = realloc(rl_line, (len + 2) * sizeof(char));
        
        if (temp == NULL) {
            /* return empty line on memory error */
            yyerror("memory error");
            *rl_line = '\0';
        } else {
			rl_line = temp;
			rl_line[len] = '\n';
			rl_line[len+1] = '\0';
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
            char* memcheck = realloc(str, length * sizeof(char));

            if (memcheck == NULL) {
                yyerror("memory error");
                str[0] = '\0';

                return str;
            } else {
				str = memcheck;
			}
        }
    }

    
    return str;
}
