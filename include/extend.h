/**
 * Code to facilitate loading custom libraries into sc.
 */
#ifndef __EXTEND_H__
#define __EXTEND_H__


#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include <global.h>
#include <symbol.h>

/* typedefs etc. for loading libraries */
struct LibRec;
typedef struct LibRec {
    char* path;
    void* lib;
    struct LibRec* next;
} LibRec;

extern LibRec* lib_table;

LibRec* load_lib(const char* path);
char* tilde_expansion(const char* path);
void clear_lib_table(void);


/* macros which expand to a constructor function for a SymRec* */
#define SC_FUNC(NAME, ARG) long double tag_##NAME(long double ARG); \
    SymRec* sc_##NAME(void) {                                       \
        SymRec* temp = malloc(sizeof(SymRec));                      \
        temp->name = strdup(#NAME);                                 \
        temp->init = 1;                                             \
        temp->type = 'f';                                           \
        temp->value.func = &tag_##NAME;                             \
        return temp;                                                \
    }                                                               \
    long double tag_##NAME(long double ARG)

#define SC_VAR(NAME, VALUE) long double tag_##NAME = VALUE; \
    SymRec* sc_##NAME(void) {                               \
        SymRec* temp = malloc(sizeof(SymRec));              \
        temp->name = strdup(#NAME);                         \
        temp->init = 1;                                     \
        temp->type = 'v';                                   \
        temp->value.var = tag_##NAME;                       \
        return temp;                                        \
    }


#endif /* __EXTEND_H__ */
