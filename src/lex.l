%{
#include <parse.h>
%}

    /* INTEGERS */
DECIMAL [1-9][0-9]*
HEXADEC 0x[0-9a-eA-E]+
OCTAL   0[0-7]+
BINARY  0b[01]+

    /* FLOATS */
FLOAT   [0-9]+\.[0-9]*
STDFORM [0-9]+\.?[0-9]*[eE][+-]?[0-9]+

    /* INVALID NUMBERS */
BADHEX  0x[0-9a-eA-e]*[f-zF-Z]+
BADOCT  0[0-7]*[89]+
BADBIN  0b[01]*[2-9]+

    /* OPTIONS */
%option header-file="lex.h"
%option noyywrap


%%


    /* NUMBERS */
{DECIMAL}      { yylval.ival = strtoll(yytext, NULL, 10); return INT;    }

{HEXADEC}      { yylval.ival = strtoll(yytext+2, NULL, 16); return INT;  }

{OCTAL}        { yylval.ival = strtoll(yytext+1, NULL, 8); return INT;   }

{BINARY}       { yylval.ival = strtoll(yytext+2, NULL, 2); return INT;   }

{FLOAT}        { yylval.fval = strtold(yytext, NULL); return FLT;        }

{STDFORM}      { yylval.fval = strtold(yytext, NULL); return FLT;        }

 /* handle one or more zeros on their own */
0+             { yylval.fval = 0; return FLT;                            }

    /* OPERATORS */
[-+*/^%!()]     { return *yytext;                                         }

 /* python style power */
"**"           { return POW;                                             }

 /* floor division */
"//"           { return FDIV;                                            }

    /* STRUCTURE */
[ \t\n]+         /* eat whitespace */

    /* ERRORS */
{BADHEX}       { fprintf(stderr, "! invalid hexadecimal: %s\n", yytext); }

{BADOCT}       { fprintf(stderr, "! invalid octal: %s\n", yytext);       }

{BADBIN}       { fprintf(stderr, "! invalid binary: %s\n", yytext);      }

.              { fprintf(stderr, "! unknown token: %s\n", yytext);       }


%%
