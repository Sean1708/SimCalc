%{
#include "parse.h"
%}

INTEGER [1-9][0-9]*
HEX     0x[0-9]+
OCTAL   0[0-9]+
BINARY  0b[0-9]+

FLOAT   [0-9]+\.[0-9]*
STDFORM [0-9]+\.?[0-9]*[eE][+-][0-9]+

%option noyywrap


%%


{INTEGER}      { yylval.ival = strtoll(yytext, NULL, 10); return INT; }

{FLOAT}        { yylval.fval = strtold(yytext, NULL); return FLT;     }

{STDFORM}      { printf("Std: %s\n", yytext);                         }

[-+()*/^\n]    { return *yytext;                                      }

[ \t]+         /* eat whitespace */

.              { fprintf(stderr, "Unknown token: %s\n", yytext);      }


%%
