/**
 * Linked list to store user made variables and functions for interacting with
 * it.
 */
#ifndef __USERVAR_H__
#define __USERVAR_H__

#include <stdlib.h>
#include <string.h>
#include <math.h>

struct VarRec;
typedef struct VarRec {
    char* name;
    int init; /* set to one once the variable has been initialised */
    long double value;
    struct VarRec* next;
} VarRec;

extern VarRec* var_table;

VarRec* create_var(const char* var_name);
VarRec* get_var(const char* var_name);
void clear_var_table(void);

#endif /* __USERVAR_H__ */
