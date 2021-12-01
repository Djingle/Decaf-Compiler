%{
extern int yylval;
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
TYPE "int"|"boolean"
ID [a-zA-Z][a-zA-Z0-9_]*
HEX_DIG [0-9a-fA-F]
DIG [0-9]
CHAR [a-zA-Z]|" "|"\n"

%%
"-"                     {return MOINS;}
"\n"                    {}
" "                     {}
\/\/[^\n\r]*"\n"        {}
"class Program"         {return CLASSPRO;}
"WriteInt(".*");"	    {}
"WriteString(".*")"     {}
"WriteBool(".*");"      {}
"ReadInt(".*");"        {}
"exit"				    {}
","                     {return COMMA;}
{OBRACK}                {return OBRACK;}
{CBRACK}                {return CBRACK;}
{OPAR}                  {return OPAR;}
{CPAR}                  {return CPAR;}
{OSBRACK}               {return OSBRACK;}
{CSBRACK}               {return CSBRACK;}
{ARITHOP}               {return yytext[0];}
"="                     {return EGAL;}
"+="                    {return PEGAL;}
"-="                    {return MEGAL;}
"<="                    {return INFEG;}
">="                    {return SUPEG;}
"<"                     {return INF;}
">"                     {return SUP;}
"=="                    {return EG;}
"!="                    {return NEG;}
"!"                     {return yytext[0];}
"&&"                    {return AND;}
"||"                    {return OR;}
{TYPE}                  {return TYPE;}
"true"|"false"          {return BOOL;}
"0x"{HEX_DIG}{HEX_DIG}* {return HEX;}
{DIG}{DIG}*             {return DEC;}
";"                     {return SEMICOL;}
"void"                  {return VOID;}
"for"                   {return FOR;}
"if"                    {return IF;}
"else"                  {return ELSE;}
"return"                {return RETURN;}
"break"                 {return BREAK;}
"continue"              {return CONTINUE;}
{ID}                    {return ID;}

\'{CHAR}\'              {
        int temp = yytext[0];
        if (temp >= 32 && temp<=126) {
            yylval = temp;
            return CHARLIT;
        }
        else {
            printf("caractère non reconnu\n");
        }
    }
 \"{CHAR}*\"             {
        //memcpy(str, yytext+1, strlen(yytext)-2);
        //return STRLIT;
    }
.                       {/*fprintf(stderr, yytext);*/}




%%

int yywrap() {return 1;}
