/**
 * Code to facilitate loading custom libraries into sc.
 */
#ifndef __EXTEND_H__
#define __EXTEND_H__


#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include <global.h>

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


#endif /* __EXTEND_H__ */
