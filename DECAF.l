%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}

OBRACK "{"
CBRACK "}"
OPAR "("
CPAR ")"
OSBRACK "["
CSBRACK "]"
ARITHOP "+"|"-"|"*"|"/"|"%"
RELOP "<="|">="|"<"|">"
EQOP "=="|"!="
TYPE "int" | "boolean"
ASSIGN_OP "="|"+="|"-="
CONDOP "&&"|"||"
ID [a-zA-Z][a-zA-Z0-9]*
HEX_DIG [0-9][a-fA-F]
DIG [0-9]
BOOL "true"|"false"
CHAR .{1}

%%
"print"				   {return print;}
"exit"				   {return exit_command;}
{OBRACK}                {} 
{CBRACK}                {}
{OPAR}                  {}
{CPAR}                  {}
{OSBRACK}               {}
{CSBRACK}               {}
{ARITHOP}               {}
{RELOP}                 {}
{EQOP}                  {}
{TYPE}                  {}
{ASSIGN_OP}             {}
{CONDOP}                {}
{ID}                    {}
0x{HEX}{HEX}*           {}
{DIG}{DIG}*             {}
{BOOL}                  {}
\'{CHAR}\'              {
        int temp = yytext[1];
        if(temp >= 32 && temp<=126){
            yylval = temp;
        }
        else{
            sprintf(yyerr, "chararter '%c' not detected", temp);
        }
    }
\"{CHAR}*\"             {
        memcpy(str, yytext+1, strlen(yytext)-2);
    }
.                      {ECHO; yyerror ("unexpected character");}




%%
int yywrap (void) {return 1;}