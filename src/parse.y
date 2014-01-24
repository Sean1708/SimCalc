%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <proto.h>

int yylex(void);
%}

%union {
    long long ival;
    long double fval;
}

%token <ival> INT
%token <fval> FLT
%type  <ival> ixpr
%type  <fval> fxpr

%left     '-' '+'
%left     '*' '/' '%' FDIV
%nonassoc NEG
%right    POW 
%nonassoc FAC

%output "parse.c"
%defines

%error-verbose


/*
 * the following, which is common in many interpreters, is not needed at the
 * moment since EOF is handled before yyparse() is called. it may be useful at a
 * later date though especially if file reading is implemented

input:
  /* empty
| input line
;
 */


%%


line:
  '\n'
| fxpr '\n'  { printf("= %.10Lg\n", $1); }
| ixpr '\n'  { printf("= %lld\n", $1);   }
| error '\n' { yyerrok;                  }
;

fxpr:
  FLT                { $$ = $1;                         }
| fxpr '+' fxpr      { $$ = $1 + $3;                    }
| fxpr '+' ixpr      { $$ = $1 + $3;                    }
| ixpr '+' fxpr      { $$ = $1 + $3;                    }
| fxpr '-' fxpr      { $$ = $1 - $3;                    }
| fxpr '-' ixpr      { $$ = $1 - $3;                    }
| ixpr '-' fxpr      { $$ = $1 - $3;                    }
| fxpr '*' fxpr      { $$ = $1 * $3;                    }
| fxpr '*' ixpr      { $$ = $1 * $3;                    }
| ixpr '*' fxpr      { $$ = $1 * $3;                    }
| fxpr '/' fxpr      { $$ = $1 / $3;                    }
| fxpr '/' ixpr      { $$ = $1 / $3;                    }
| ixpr '/' fxpr      { $$ = $1 / $3;                    }
| ixpr '/' ixpr      { long double x = $1; $$ = x / $3; }
| fxpr '%' fxpr      { $$ = fmodl($1, $3);              }
| fxpr '%' ixpr      { $$ = fmodl($1, $3);              }
| ixpr '%' fxpr      { $$ = fmodl($1, $3);              }
| '-' fxpr %prec NEG { $$ = -$2;                        }
| fxpr POW fxpr      { $$ = powl($1, $3);               }
| fxpr POW ixpr      { $$ = powl($1, $3);               }
| ixpr POW fxpr      { $$ = powl($1, $3);               }
| fxpr '!'           {
    if ($1 < 0) {
        yyerror("factorial undefined for negative numbers");
    } else if (fmodl($1, 1) != 0) {
        yyerror("factorial undefined for floating-point numbers");
    } else {
        $$ = 1;
        for (long double i = $1; i > 0; i--) $$ *= i;
    }
}
| '|' fxpr '|'       { $$ = fabsl($2);                  }
| '(' fxpr ')'       { $$ = $2;                         }
;

ixpr:
  INT                { $$ = $1;                                    }
| ixpr '+' ixpr      { $$ = $1 + $3;                               }
| ixpr '-' ixpr      { $$ = $1 - $3;                               }
| ixpr '*' ixpr      { $$ = $1 * $3;                               }
| ixpr FDIV ixpr     {
    /* if the result is negative this will be truncated not floored */
    long long x = $1 / $3;
    if (x < 0) {
        $$ = x - 1;
    } else {
        $$ = x;
    }
}
| ixpr FDIV fxpr     { $$ = floorl($1 / $3);                       }
| fxpr FDIV ixpr     { $$ = floorl($1 / $3);                       }
| fxpr FDIV fxpr     { $$ = floorl($1 / $3);                       }
| ixpr '%' ixpr      { $$ = $1 % $3;                               }
| '-' ixpr %prec NEG { $$ = -$2;                                   }
| ixpr POW ixpr      { $$ = powl($1, $3);                          }
| ixpr '!' %prec FAC {
    if ($1 < 0) {
        yyerror("factorial undefined for negative numbers");
    } else {
        $$ = 1;
        for (long long i = $1; i > 0; i--) $$ *= i;
    }
}
| '|' ixpr '|'       { $$ = llabs($2);                             }
| '(' ixpr ')'       { $$ = $2;                                    }
;


%%


void yyerror(const char* fmt, ...) {
    va_list argp;
    va_start(argp, fmt);

    fprintf(stderr, "! ");
    vfprintf(stderr, fmt, argp);
    fprintf(stderr, "\n");

    va_end(argp);
}
