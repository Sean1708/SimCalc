#include <stdio.h>
#include <extend.h>

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

        if (!qflag) cmd_print("library loaded: %s", exp_path);
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
