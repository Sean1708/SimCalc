#include <global.h>

void yyerror(const char* fmt, ...) {
    had_error = 1;

    if (qflag) return;

    va_list argp;
    va_start(argp, fmt);

    fprintf(stderr, "! ");
    vfprintf(stderr, fmt, argp);
    fprintf(stderr, "\n");

    va_end(argp);
}

void cmd_print(const char* fmt, ...) {
    if (qflag) return;

    va_list argp;
    va_start(argp, fmt);

    printf("$ ");
    vprintf(fmt, argp);
    printf("\n");

    va_end(argp);
}
