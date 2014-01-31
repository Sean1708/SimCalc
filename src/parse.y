%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <global.h>

int yylex(void);
%}

%union {
    long double fval;
}

%token <fval> NUM
%type  <fval> expr

%left     '-' '+'
%left     '*' '/' '%' FDIV
%nonassoc NEG
%right    POW 
%nonassoc FAC

%output "parse.c"
%defines

%error-verbose


/*
 * input section is not needed at the moment since EOF is handled before yyparse
 * is even called but may be useful once sc can handle files
 */
%%


input:
  /* empty */
| input line
;

line:
  endchar
| expr endchar  { printf("%s%.15Lg\n", outprompt, $1); }
| error endchar { yyerrok;                             }
;

endchar:
  ';'
| '\n'
;

expr:
  NUM                { $$ = $1;                        }
| expr '+' expr      { $$ = $1 + $3;                   }
| expr '-' expr      { $$ = $1 - $3;                   }
| expr '*' expr      { $$ = $1 * $3;                   }
| expr '/' expr      { $$ = $1 / $3;                   }
| expr FDIV expr     { $$ = floorl($1 / $3);           }
| expr '%' expr      { $$ = fmodl($1, $3);             }
| '-' expr %prec NEG { $$ = -$2;                       }
| expr POW expr      { $$ = powl($1, $3);              }
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
| '|' expr '|'       { $$ = fabsl($2);                 }
| '(' expr ')'       { $$ = $2;                        }
;


%%


void yyerror(const char* fmt, ...) {
    if (qflag) return;

    va_list argp;
    va_start(argp, fmt);

    fprintf(stderr, "! ");
    vfprintf(stderr, fmt, argp);
    fprintf(stderr, "\n");

    va_end(argp);
}
