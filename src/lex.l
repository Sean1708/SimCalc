%{
#include <symbol.h>
#include <extend.h>
#include <parse.h>
#include <base.h>
#include <global.h>
%}

    /* NUMBERS */
DECIMAL (0\.|[1-9]+[0-9]*\.?)[0-9]*
HEXADEC 0x[0-9a-fA-F]+
OCTAL   0[0-7]+
BINARY  0b[01]+
STDFORM [0-9]+\.?[0-9]*[eE][-+]?[0-9]+

    /* INVALID NUMBERS */
BADHEX  0x[0-9a-fA-F]*[g-zG-Z]+
BADOCT  0[0-7]*[89]+
BADBIN  0b[01]*[2-9]+

    /* VARIABLES */
NAME    [a-zA-Z_][a-zA-Z0-9_]*
COMMAND \$[a-zA-Z]+

    /* CONDITIONS */
%x cmdarg

    /* OPTIONS */
%option header-file="lex.h"
%option noyywrap


%%


        /* NUMBERS */
{DECIMAL}          { yylval.fval = strtold(yytext, NULL); return NUM;         }

{HEXADEC}          { yylval.fval = hextold(yytext + 2); return NUM;           }

{OCTAL}            { yylval.fval = octtold(yytext + 1); return NUM;           }

{BINARY}           { yylval.fval = bintold(yytext + 2); return NUM;           }
 
{STDFORM}          { yylval.fval = strtold(yytext, NULL); return NUM;         }

 /* handle one or more zeros on their own */
0+                 { yylval.fval = 0; return NUM;                             }

        /* VARIABLES */
{NAME}             {
    /* look for a symbol either function or variable */
    if ((yylval.sym = get_sym(yytext)) == NULL) {
        /* if it doesn't exist, create a variable */
        yylval.sym = create_var(yytext);
    }
    
    return yylval.sym->type;
}

{COMMAND}          { yylval.sval = strdup(yytext); BEGIN(cmdarg); return CMD; }

 /* allow command arguments to be any characters not used for parsing */
<cmdarg>[^; \t\n]+ { yylval.sval = strdup(yytext); return CMDARG;             }

<cmdarg>[;\n]      { BEGIN(INITIAL); return *yytext;                          }

        /* OPERATORS */
[-+*/%!()|=;\n]    { return *yytext;                                          }

 /* power operators */
"**"|"^"           { return POW;                                              }

 /* floor division */
"//"               { return FDIV;                                             }

        /* STRUCTURE */
<*>[ \t]+             /* eat whitespace */

        /* ERRORS */
{BADHEX}           { yyerror("invalid hexadecimal: %s", yytext);              }

{BADOCT}           { yyerror("invalid octal: %s", yytext);                    }

{BADBIN}           { yyerror("invalid binary: %s", yytext);                   }

.                  { yyerror("unknown token: %s", yytext);                    }


%%
