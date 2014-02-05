#include <symbol.h>
#include <parse.h>

SymRec* sym_table = NULL;

SymRec* create_var(const char* sym_name) {
    SymRec* temp = malloc(sizeof(SymRec));
    temp->name = strdup(sym_name);
    temp->init = 0;
    temp->type = 'v';
    temp->value.var = nan(NULL);

    temp->next = sym_table;
    sym_table = temp;

    return temp;
}

SymRec* get_sym(const char* sym_name) {
    /* see if symbol has already been loaded */
    SymRec* sym_ptr = sym_table;
    for (; sym_ptr != NULL; sym_ptr = sym_ptr->next) {
        if (strcmp(sym_ptr->name, sym_name) == 0) return sym_ptr;
    }

    /* then see if the libraries have it */
    LibRec* search_libs = lib_table;
    char* sc_sym_name = prepend_sc(sym_name);

    for (; search_libs != NULL; search_libs = search_libs->next) {
        sym_constructor temp = dlsym(search_libs->lib, sc_sym_name);

        /* if it is found, add it to the function table and return it */
        if (temp != NULL) {
            sym_ptr = (*temp)();

            sym_ptr->next = sym_table;
            sym_table = sym_ptr;

            break;
        }
    }


    free(sc_sym_name);
    /* if it's never found sym_ptr will be NULL */
    return sym_ptr;
}

char* prepend_sc(const char* sym_name) {
    int length = strlen(sym_name) + 4;
    char* new_name = calloc(length, sizeof(char));

    strcpy(new_name, "sc_");
    strcat(new_name, sym_name);
    new_name[length - 1] = '\0';


    return new_name;
}

void clear_sym_table(void) {
    SymRec* temp = sym_table;
    for (; temp != NULL; temp = sym_table) {
        sym_table = temp->next;

        if (temp->name) free(temp->name);
        free(temp);
    }
}
