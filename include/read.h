#ifndef __READ_H__
#define __READ_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <readline/readline.h>
#include <readline/history.h>

char* rl_gets(char* prompt);
char* non_readline_readline();

#endif  // __READ_H__
