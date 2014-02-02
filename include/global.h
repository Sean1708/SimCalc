/*
 * Contains anything which is needed globally, like global variables or certain
 * function protoytpes.
 */

#ifndef __GLOBAL_H__
#define __GLOBAL_H__

#include <stdio.h>
#include <stdarg.h>

extern int program_running;
extern int had_error;
extern int qflag;
extern char* inprompt;
extern char* outprompt;

void yyerror(const char* fmt, ...);
void cmd_print(const char* fmt, ...);

#endif /* __GLOBAL_H__ */
