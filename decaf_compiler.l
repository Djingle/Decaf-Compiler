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
/*BOOL "true"|"false"*/
CHAR [a-zA-Z]

%%
\/\/[^\n\r]*"\n"        {}
"class Program"         {return CLASSPRO;}
 /*"WriteInt"			    {return print;}
"WriteBool"             {return }
"ReadInt"*/
"exit"				    {return exit_command;}*/
{OBRACK}                {return OBRACK;}
{CBRACK}                {return CBRACK;}
 /*{OPAR}                  {return OPAR;}
{CPAR}                  {return CPAR;}
{OSBRACK}               {return OSBRACK;}
{CSBRACK}               {return CSBRACK;}
{ARITHOP}               {return ARITHOP;}
{RELOP}                 {return RELOP;}
{EQOP}                  {return EQOP;}*/
{TYPE}                  {return TYPE;}
{ASSIGNOP}              {return ASSIGNOP;}
 /*{CONDOP}                {return CONDOP;}*/
"true"|"false"          {return BOOL;}
"0x"{HEX_DIG}{HEX_DIG}* {return HEX;}
{DIG}{DIG}*             {return DEC;}
";"                     {return SEMICOL;}
{ID}                    {return ID;}
 /*"void"                  {return VOID;}
"for"                   {return FOR;}
"if"                    {return IF;}
"else"                  {return ELSE;}
"return"                {return RETURN;}
"break"                 {return BREAK;}
"continue"              {return CONTINUE;}*/
.                       {}

 /*\'{CHAR}\'              {;}
        int temp = yytext[1];
        if(temp >= 32 && temp<=126){
            yylval = temp;
            return CHARLIT;
        }
        else{
            sprintf(yyerr, "chararter '%c' not detected", temp);
        }
    }
\"{CHAR}*\"             {;}
        /*memcpy(str, yytext+1, strlen(yytext)-2);
        return STRLIT;
    }*/




%%

//int yywrap (void) {return 1;}
