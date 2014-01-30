#include <stdio.h>
#include <unistd.h>
#include <global.h>
#include <read.h>
#include <parse.h>
#include <lex.h>


void usage(void);


int qflag = 0;

/* INPROMPT SHOULD ONLY BE NULL IN QUIET MODE */
char* inprompt = ">> ";
char* outprompt = "= ";


int main(int argc, char* argv[]) {
    char ch = '\0';
    while ((ch = getopt(argc, argv, "hq")) != -1) {
        switch (ch) {
            /* quiet mode */
            case 'q':
                /* suppress input and output prompts and error messages */
                qflag = 1;
                inprompt = NULL;
                outprompt = "\0";
                break;
            /* help message */
            case 'h':
                usage();
                exit(0);
                break;
            /* unknown option */
            case '?':
            default:
                /* show usage but do not exit */
                usage();
        }
    }

    char* line = NULL;
    YY_BUFFER_STATE buf = NULL;

    while (1) {
        line = rl_gets(inprompt);

        if (line == NULL) {
            if (!qflag) printf("Goodbye!\n");
            break;
        } else {
            buf = yy_scan_string(line);
            yyparse();
            yy_delete_buffer(buf);
        }
    }

    free(line);
    return 0;
}


void usage(void) {
    fprintf(stderr, "usage: sc [options]\n");
    fprintf(stderr, "  -h      print this help message\n");
    fprintf(stderr, "  -q      suppress prompts and error messages\n");
}
