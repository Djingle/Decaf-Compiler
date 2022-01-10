%{
//extern int yylval;
#include "intermediate_code.h"
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
TYPE "int"|"boolean"
ID [a-zA-Z][a-zA-Z0-9_]*
HEX_DIG [0-9a-fA-F]
DIG [0-9]
CHAR [a-zA-Z]|" "|"\n"

%%
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
"-"                     {return MOINS;}
"+"                     {return PLUS;}
"*"                     {return FOIS;}
"/"                     {return DIVISER;}
"%"                     {return MODULO;}
"="                     {return EGAL;}
"+="                    {return PEGAL;}
"-="                    {return MEGAL;}
"<="                    {return INFEG;}
">="                    {return SUPEG;}
"<"                     {return INF;}
">"                     {return SUP;}
"=="                    {return B_EGAL;}
"!="                    {return B_NEGAL;}
"!"                     {return NON;}
"&&"                    {return AND;}
"||"                    {return OR;}
{TYPE}                  {yylval.constString = yytext;return TYPE;}
"true"|"false"          {yylval.constString = yytext;return BOOL;}
"0x"{HEX_DIG}{HEX_DIG}* { yylval.constString = yytext; return HEX;}
{DIG}{DIG}*             { yylval.constString =yytext; return DEC;}
";"                     {return SEMICOL;}
"void"                  {return VOID;}
"for"                   {return FOR;}
"if"                    {return IF;}
"else"                  {return ELSE;}
"return"                {return RETURN;}
"break"                 {return BREAK;}
"continue"              {return CONTINUE;}
{ID}                    {
    printf("ID detected: %s\n", yytext);
    yylval.constString = yytext;return ID;}

\'{CHAR}\'              {
        // int temp = yytext[0];
        // if (temp >= 32 && temp<=126) {
        //     yylval.intval = temp;
        //     return CHARLIT;
        // }
        // else {
        //     printf("caractère non reconnu\n");
        // }
    }
 \"{CHAR}*\"             {
        //memcpy(str, yytext+1, strlen(yytext)-2);
        //return STRLIT;
    }
.                       {/*fprintf(stderr, yytext);*/}




%%

int yywrap() {return 1;}
