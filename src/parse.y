%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <uservar.h>
#include <loadlib.h>
#include <command.h>
#include <global.h>

int yylex(void);

int had_error = 0;
%}

%union {
    long double fval;
    char* sval;
    VarRec* var;
    FuncRec* func;
}

%token <sval> CMD CMDARG
%token <func> FUNC
%token <var>  VAR
%token <fval> NUM
%type  <fval> expr

%left     '-' '+'
%left     '*' '/' '%' FDIV
%nonassoc NEG
%right    POW 

%output "parse.c"
%defines

%error-verbose


%%


input:
  /* empty */
| input line { had_error = 0; }
;

line:
  endchar
| command endchar
| assign endchar
| expr endchar    { if (!had_error) printf("%s%.15Lg\n", outprompt, $1); }
| error endchar   { yyerrok;                                             }
;

endchar:
  ';'
| '\n'
;

command:
  CMD        { run_command($1, NULL); free($1);         }
| CMD CMDARG { run_command($1, $2); free($1); free($2); }
;

assign:
  VAR '=' expr { $1->value = $3; $1->init = 1; }
;

expr:
  NUM                { $$ = $1;                }
| VAR                {
    if ($1->init == 1){
        $$ = $1->value;
    } else {
        yyerror("variable %s has not been initialised", $1->name);
    }
}
| FUNC '(' expr ')'  { $$ = (*($1->func))($3); }
| expr '+' expr      { $$ = $1 + $3;           }
| expr '-' expr      { $$ = $1 - $3;           }
| expr '*' expr      { $$ = $1 * $3;           }
| expr '/' expr      { $$ = $1 / $3;           }
| expr FDIV expr     { $$ = floorl($1 / $3);   }
| expr '%' expr      { $$ = fmodl($1, $3);     }
| '-' expr %prec NEG { $$ = -$2;               }
| expr POW expr      { $$ = powl($1, $3);      }
| expr '!'           {
    if ($1 < 0) {
        yyerror("factorial undefined for negative numbers");
    } else if (fmodl($1, 1) != 0) {
        yyerror("factorial undefined for non-integer numbers");
    } else {
        $$ = 1;
        for (long double i = $1; i > 0; i--) $$ *= i;
    }
}
| '|' expr '|'       { $$ = fabsl($2);         }
| '(' expr ')'       { $$ = $2;                }
;


%%


void yyerror(const char* fmt, ...) {
    had_error = 1;

    if (qflag) return;

    va_list argp;
    va_start(argp, fmt);

    fprintf(stderr, "! ");
    vfprintf(stderr, fmt, argp);
    fprintf(stderr, "\n");

    va_end(argp);
}
