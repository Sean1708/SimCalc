/*
 * Contains anything which is needed globally, like global variables or certain
 * function protoytpes.
 */

#ifndef __PROTO_H__
#define __PROTO_H__

#include <stdarg.h>

extern int qflag;
extern char* inprompt;
extern char* outprompt;

void yyerror(const char* fmt, ...);

#endif /* __PROTO_H__ */
