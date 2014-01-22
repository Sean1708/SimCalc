%{
#include "parse.h"
%}

DECIMAL [1-9][0-9]*
HEXADEC 0x[0-9a-eA-E]+
OCTAL   0[0-7]+
BINARY  0b[01]+

FLOAT   [0-9]+\.[0-9]*
STDFORM [0-9]+\.?[0-9]*[eE][+-]?[0-9]+

%option header-file="lex.h"
%option noyywrap


%%


{DECIMAL}      { yylval.ival = strtoll(yytext, NULL, 10); return INT;   }

{HEXADEC}      { yylval.ival = strtoll(yytext+2, NULL, 16); return INT; }

{OCTAL}        { yylval.ival = strtoll(yytext+1, NULL, 8); return INT;  }

{BINARY}       { yylval.ival = strtoll(yytext+2, NULL, 2); return INT;  }

{FLOAT}        { yylval.fval = strtold(yytext, NULL); return FLT;       }

{STDFORM}      { yylval.fval = strtold(yytext, NULL); return FLT;       }

[-+*/^%()\n]   { return *yytext;                                        }

[ \t]+         /* eat whitespace */

.              { fprintf(stderr, "! unknown token: %s\n", yytext);      }


%%
