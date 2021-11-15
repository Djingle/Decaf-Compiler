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
TYPE "int"|"boolean"
ASSIGNOP "="|"+="|"-="
CONDOP "&&"|"||"
ID [a-zA-Z][a-zA-Z0-9]*
HEX_DIG [0-9a-fA-F]
DIG [0-9]
BOOL "true"|"false"

%%
"print"				   {return print;}
"exit"				   {return exit_command;}
{OBRACK}               {return OBRACK;}
{CBRACK}               {return CBRACK;}
{OPAR}                 {return OPAR;}
{CPAR}                 {return CPAR;}
{OSBRACK}              {return OSBRACK;}
{CSBRACK}              {return CSBRACK;}
{ARITHOP}              {return ARITHOP;}
{RELOP}                {return RELOP;}
{EQOP}                 {return EQOP;}
{TYPE}                 {return TYPE;}
{ASSIGNOP}             {return ASSIGNOP;}
{CONDOP}               {return CONDOP;}
{ID}                   {return ID;}
"0x"{HEX}{HEX}*        {return }
{DIG}{DIG}*            {return }
{BOOL}                 {return BOOL}
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
