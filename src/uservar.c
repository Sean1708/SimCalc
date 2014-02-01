#include <uservar.h>

VarRec* var_table = NULL;

VarRec* create_var(const char* var_name) {
    VarRec* temp = malloc(sizeof(VarRec));
    temp->name = strdup(var_name);
    temp->init = 0;
    temp->value = nan(NULL);

    temp->next = var_table;
    var_table = temp;

    return temp;
}

VarRec* get_var(const char* var_name) {
    VarRec* temp = NULL;
    for (temp = var_table; temp != NULL; temp = temp->next) {
        if (strcmp(temp->name, var_name) == 0) return temp;
    }

    return NULL;
}

void clear_var_table(void) {
    VarRec* temp = var_table;
    for (; temp != NULL; temp = var_table) {
        var_table = temp->next;

        if (temp->name) free(temp->name);
        free(temp);
    }
}
