/**
 * Functions and structures for loading dynamic libraries and using the
 * functions contained within.
 */
#ifndef __LOADLIB_H__
#define __LOADLIB_H__

#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>

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


/* this desperately needs renaming */
typedef long double (* func_cb)(long double arg);

struct FuncRec;
typedef struct FuncRec {
    char* name;
    func_cb func;
    struct FuncRec* next;
} FuncRec;

extern FuncRec* func_table;

FuncRec* get_func(const char* func_name);
void clear_func_table(void);

#endif /* __LOADLIB_H__ */
