#include <stdio.h>
#include <global.h>
#include <loadlib.h>

LibRec* lib_table = NULL;

LibRec* load_lib(const char* path) {
    char* exp_path = tilde_expansion(path);
    /* don't load libraries twice */
    LibRec* search_libs = lib_table;
    for (; search_libs != NULL; search_libs = search_libs->next) {
        if (strcmp(search_libs->path, exp_path) == 0) return search_libs;
    }

    void* new_lib = dlopen(exp_path, RTLD_LAZY);
    LibRec* temp = NULL;

    if (new_lib != NULL) {
        temp = malloc(sizeof(LibRec));
        temp->path = strdup(exp_path);
        temp->lib = new_lib;

        temp->next = lib_table;
        lib_table = temp;

        fprintf(stderr, "$ library loaded: %s\n", exp_path);
    } else {
        yyerror("library not found: %s", exp_path);
    }


    free(exp_path);
    return temp;
}

char* tilde_expansion(const char* path) {
    /* tilde must be the first character */
    if (path[0] != '~') return strdup(path);

    char* home = getenv("HOME");
    int h_len = strlen(home);
    int p_len = strlen(path);

    /* allocate enough space to hold new path */
    char* new_path = calloc(h_len + p_len + 1, sizeof(char));
    
    /* construct new path */
    strcpy(new_path, home);
    /* don't concat tilde */
    strcat(new_path, path + 1);
    /* I'm a paranoid bastard */
    new_path[h_len + p_len] = '\0';

    return new_path;
}

void clear_lib_table(void) {
    LibRec* temp = lib_table;
    for (; temp != NULL; temp = lib_table) {
        lib_table = temp->next;

        if (temp->path) free(temp->path);
        if (temp->lib) dlclose(temp->lib);
        free(temp);
    }
}


FuncRec* func_table = NULL;

FuncRec* get_func(const char* func_name) {
    /* see if function has already been loaded */
    FuncRec* func_ptr = func_table;
    for (; func_ptr != NULL; func_ptr = func_ptr->next) {
        if (strcmp(func_ptr->name, func_name) == 0) return func_ptr;
    }

    /* then see if the libraries have it */
    LibRec* search_libs = lib_table;
    char* sc_func_name = prepend_sc(func_name);

    for (; search_libs != NULL; search_libs = search_libs->next) {
        func_cb temp = dlsym(search_libs->lib, sc_func_name);

        /* if it is found, add it to the function table and return it */
        if (temp != NULL) {
            func_ptr = malloc(sizeof(FuncRec));
            func_ptr->name = strdup(func_name);
            func_ptr->func = temp;

            func_ptr->next = func_table;
            func_table = func_ptr;

            break;
        }
    }


    free(sc_func_name);
    /* if it's never found func_ptr will be NULL */
    return func_ptr;
}

char* prepend_sc(const char* func_name) {
    int length = strlen(func_name) + 4;
    char* new_name = calloc(length, sizeof(char));

    strcpy(new_name, "sc_");
    strcat(new_name, func_name);
    new_name[length] = '\0';


    return new_name;
}

void clear_func_table(void) {
    FuncRec* temp = func_table;
    for (; temp != NULL; temp = func_table) {
        func_table = temp->next;

        if (temp->name) free(temp->name);
        free(temp);
    }
}
