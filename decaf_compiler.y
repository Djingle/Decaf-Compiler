%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
//#include <c{type}.h>
// #include "set.h"
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);

%}

%union {
	int num;
	char motcle;
	}

%start program

%token print
%token exit_command
%token OBRACK CBRACK OPAR CPAR OSBRACK CSBRACK ARITHOP RELOP EQOP TYPE ASSIGNOP CONDOP ID CLASSPRO BOOL DEC HEX CHARLIT
%token VOID FOR IF ELSE RETURN BREAK CONTINUE


%%

program   	: CLASSPRO OBRACK t_fielDecl t_methoDecl CBRACK				{printf("program\n");}

t_fielDecl  : /*empty*/													{printf("fin t_fielDecl\n");}
			| t_fielDecl field_decl										{printf("t_fielDecl\n");}

t_methoDecl : /*empty*/													{printf("fin t_methoDecl\n");}
			| t_methoDecl method_decl									{printf("t_methoDecl\n");}

field_decl 	: TYPE field_elem ';'										{printf("field_decl\n");}

field_elem 	: ID 														{printf("field_elem 1\n");}
			| ID OSBRACK int_literal CSBRACK 							{printf("field_elem 2\n");}
			| ID ',' field_elem											{printf("field_elem 3\n");}
			| ID OSBRACK int_literal CSBRACK ',' field_elem				{printf("field_ellem 4\n");}

method_decl	: 	VOID ID OPAR t_id CPAR block							{printf("method_decl 1\n");}
			| 	TYPE ID OPAR t_id CPAR block							{printf("method_decl 2\n");}
			|	VOID ID OPAR CPAR block									{printf("method_decl 3\n");}
			| 	TYPE ID OPAR CPAR block									{printf("method_decl 4\n");}

t_id 		: 	TYPE ID | TYPE ID ',' t_id								{printf("t_id\n");}

block 		: OBRACK t_varDecl t_statement CBRACK						{printf("block\n");}

t_varDecl	: /*empty*/ 												{printf("fin t_varDecl\n");}
			| t_varDecl var_decl										{printf("t_varDecl\n");}

t_statement 	: /*empty*/ 											{printf("fin t_statement\n");}
			| t_statement statement										{printf("t_statement\n");}

var_decl : t_id ';'														{printf("var_decl\n");}

statement 	: location ASSIGNOP expr ';'								{printf("statement 1\n");}
			| method_call ';'											{printf("statement 2\n");}
			| IF OPAR expr CPAR block									{printf("statement 3\n");}
			| IF OPAR expr CPAR block ELSE block						{printf("statement 4\n");}
			| FOR ID '=' expr ',' expr block							{printf("statement 5\n");}
			| RETURN ';'												{printf("statement 6\n");}
			| RETURN expr ';'											{printf("statement 7\n");}
			| BREAK ';'													{printf("statement 8\n");}
			| CONTINUE ';'												{printf("statement 9\n");}
			| block														{printf("statement 10\n");}

method_call : method_name OPAR t_expr CPAR 								{printf("method_call 1\n");}
			| method_name OPAR CPAR										{printf("method_call 2\n");}
t_expr 	: expr 															{printf("fin t_expr\n");}
		| expr ',' t_expr												{printf("t_expr\n");}

method_name : ID														{printf("method_name\n");}

location 	: ID 														{printf("location 1\n");}
			| ID OBRACK expr CBRACK										{printf("location 2\n");}

expr 	: location 														{printf("expr 1\n");}
		| method_call 													{printf("expr 2\n");}
		| literal 														{printf("expr 3\n");}
		| expr bin_op expr 												{printf("expr 4\n");}
		| '-' expr														{printf("expr 5\n");}
		| '!' expr														{printf("expr 6\n");}
		| OPAR expr CPAR												{printf("expr 7\n");}

bin_op 	: ARITHOP 														{printf("bin_op 1\n");}
		| RELOP 														{printf("bin_op 2\n");}
		| EQOP 															{printf("bin_op 3\n");}
		| CONDOP														{printf("bin_op 4\n");}

literal : int_literal 													{printf("literal 1\n");}
		| char_literal 													{printf("literal 2\n");}
		| BOOL															{printf("literal 3\n");}

int_literal : DEC 														{printf("int_literal 1\n");}
			| HEX														{printf("int_literal 2\n");}

char_literal : CHARLIT

%%


int main (void) {
	yyparse();
	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
