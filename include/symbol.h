/**
 * Code for dealing with user defined variables and functions.
 */
#ifndef __SYMBOL_H__
#define __SYMBOL_H__


#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <extend.h>

/* this desperately needs renaming */
typedef long double (* func_cb)(long double arg);

struct SymRec;
typedef struct SymRec {
    char* name;
    int init;  /* set to one once the variable has been initialised */
    char type;  /* 'v' - variable; 'f' - function */
    union {
        func_cb func;
        long double var;
    } value;
    struct SymRec* next;
} SymRec;

typedef SymRec* (* sym_constructor)(void);
extern SymRec* sym_table;

SymRec* create_var(const char* sym_name);
SymRec* get_sym(const char* sym_name);
char* prepend_sc(const char* sym_name);
void clear_sym_table(void);


#endif /* __SYMBOL_H__ */
