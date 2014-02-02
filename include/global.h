/*
 * Contains anything which is needed globally, like global variables or certain
 * function protoytpes.
 */

#ifndef __GLOBAL_H__
#define __GLOBAL_H__

#include <stdarg.h>

extern int program_running;
extern int qflag;
extern char* inprompt;
extern char* outprompt;

void yyerror(const char* fmt, ...);

#endif /* __GLOBAL_H__ */
