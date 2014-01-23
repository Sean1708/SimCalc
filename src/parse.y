%{
#include <stdio.h>
#include <math.h>

int yylex(void);
void yyerror(const char* msg);
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
%right    '^' POW 
%nonassoc FAC

%output "parse.c"
%defines


%%


input:
  /* empty */
| fxpr   { printf("= %.10Lg\n", $1); }
| ixpr   { printf("= %lld\n", $1);   }
| error  { yyerrok;                  }
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
| fxpr '^' fxpr      { $$ = powl($1, $3);               }
| fxpr POW fxpr      { $$ = powl($1, $3);               }
| fxpr '^' ixpr      { $$ = powl($1, $3);               }
| fxpr POW ixpr      { $$ = powl($1, $3);               }
| ixpr '^' fxpr      { $$ = powl($1, $3);               }
| ixpr POW fxpr      { $$ = powl($1, $3);               }
| '(' fxpr ')'       { $$ = $2;                         }
;

ixpr:
  INT                { $$ = $1;                                    }
| ixpr '+' ixpr      { $$ = $1 + $3;                               }
| ixpr '-' ixpr      { $$ = $1 - $3;                               }
| ixpr '*' ixpr      { $$ = $1 * $3;                               }
| ixpr FDIV ixpr     { long double a=$1, b=$3; $$ = floorl(a / b); }
| ixpr FDIV fxpr     { $$ = floorl($1 / $3);                       }
| fxpr FDIV ixpr     { $$ = floorl($1 / $3);                       }
| fxpr FDIV fxpr     { $$ = floorl($1 / $3);                       }
| ixpr '%' ixpr      { $$ = $1 % $3;                               }
| '-' ixpr %prec NEG { $$ = -$2;                                   }
| ixpr '^' ixpr      { $$ = powl($1, $3);                          }
| ixpr POW ixpr      { $$ = powl($1, $3);                          }
| ixpr '!' %prec FAC {
    if ($1 < 0) {
        yyerror("factorial undefined for negative numbers");
    } else if ($1 == 0) {
        $$ = 1;
    } else {
        $$ = 1;
        for (long long i = $1; i > 0; i--) $$ *= i;
    }
}
| '(' ixpr ')'       { $$ = $2;                                    }
;


%%


void yyerror(const char* msg) {
    fprintf(stderr, "! %s\n", msg);
}
