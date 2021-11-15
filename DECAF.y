%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <c{type}.h>
// #include "set.h"
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);

%}

%union {int num; char motcle;}         /* Yacc definitions */
%start liste
%token print
%token exit_command

%token <motcle> boolean
%token <motcle> break
%token <motcle> class
%token <motcle> continue
%token <motcle> else
%token <motcle> false
%token <motcle> for
%token <motcle> if
%token <motcle> int
%token <motcle> return
%token <motcle> true
%token <motcle> void


%%

program   	: class Program OBRACK t_fielDecl t_methoDecl CBRACK	{;}
t_fielDecl  : EPS 														{;}
			| t_fielDecl field_decl										{;}
t_methoDecl : EPS 														{;}
			| t_methoDecl method_decl									{;}

field_decl 	: TYPE t_intLit ';'										{;}
t_intLit 	: ID 														{;}
			| ID OSBRACK int_literal CSBRACK 						{;}
			| ID ',' t_intLit											{;}
			| ID OSBRACK int_literal CSBRACK ',' t_intLit			{;}

method_decl	: 	void ID OPAR t_id CPAR block						{;}
			| 	TYPE ID OPAR t_id CPAR block					{;}
			|	void ID OPAR CPAR block							{;}
			| 	TYPE ID OPAR CPAR block							{;}
t_id 		: 	TYPE ID | TYPE ID ',' t_id						{;}

block 		: OBRACK t_varDecl t_statement CBRACK					{;}
t_varDecl	: EPS 														{;}
			| t_varDecl var_decl										{;}
t_statment 	: EPS 														{;}
			| t_statment statement										{;}

var_decl : t_id ';'														{;}

statement 	: location ASSIGN_OP expr ';'								{;}
			| method_call ';'											{;}
			| if OPAR expr CPAR block								{;}
			| if OPAR expr CPAR block else block					{;}
			| for ID '=' expr ',' expr block							{;}
			| return ';'												{;}
			| return expr ';'											{;}
			| break ';'													{;}
			| continue ';'												{;}
			| block														{;}

method_call : method_name OPAR t_expr, CPAR 						{;}
			| method_name OPAR CPAR									{;}
t_expr 	: expr 															{;}
		| t_expr expr													{;}

methode_name : ID														{;}

location 	: ID 														{;}
			| ID OBRACK expr CBRACK								{;}

expr 	: location 														{;}
		| method_call 													{;}
		| literal 														{;}
		| expr bin_op expr 												{;}
		| '-' expr														{;}
		| '!' expr														{;}
		| OPAR expr CPAR											{;}

bin_op 	: ARITHOP 													{;}
		| RELOP 														{;}
		| EQOP 														{;}
		| CONDOP														{;}

literal : int_literal 													{;}
		| char_literal 													{;}
		| BOOL														{;}

int_literal : decimal_literal 											{;}
			| hex_literal												{;}

decimal_literal : DIG 												{;}
				| decimal_literal DIG									{;}


%%                     /* C code */


int main (void) {
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
