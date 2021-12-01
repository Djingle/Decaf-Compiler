%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern FILE *yyin;
//int yydebug = 1;

%}

%start program

%token OBRACK CBRACK OPAR CPAR OSBRACK CSBRACK ASSIGNOP TYPE ID CLASSPRO BOOL DEC HEX CHARLIT SEMICOL COMMA EGAL PEGAL MEGAL MOINS
%token VOID FOR IF ELSE RETURN BREAK CONTINUE
%token INFEG SUPEG INF SUP EG NEG AND OR

%left '+' '-'
%left '*' '/' '%'
%nonassoc '!'
%nonassoc INFEG SUPEG INF SUP EG NEG
%left AND OR


%%

program   		: CLASSPRO OBRACK t_fielDecl t_methoDecl CBRACK				{printf("program\n");}
				;

t_fielDecl  	: /*empty*/													{printf("fin t_fielDecl\n");}
				| t_fielDecl TYPE field_elem SEMICOL						{printf("t_fielDecl\n");}
				;

t_methoDecl 	: /*empty*/													{printf("fin t_methoDecl\n");}
				| methoDecl_l												{printf("t_methoDecl\n");}
				;

methoDecl_l		: methoDecl_l method_decl									{printf("1\n");}
				| method_decl												{printf("2\n");}
				;

field_elem		: field_elem COMMA ID OSBRACK int_literal CSBRACK			{printf("tabliste\n");}
				| ID OSBRACK int_literal CSBRACK							{printf("tabfinliste\n");}
				| field_elem COMMA ID										{printf("varliste\n");}
				| ID														{printf("varfinliste\n");}
				;

method_decl		: 	VOID ID OPAR t_param CPAR block							{printf("method_decl 1\n");}
				| 	TYPE ID OPAR t_param CPAR block							{printf("method_decl 2\n");}
				|	VOID ID OPAR CPAR block									{printf("method_decl 3\n");}
				| 	TYPE ID OPAR CPAR block									{printf("method_decl 4\n");}
				;

t_param 		: TYPE ID
				| t_param TYPE COMMA ID										{printf("t_param\n");}
				;

block 			: OBRACK t_varDecl t_statement CBRACK						{printf("block\n");}
				;

t_varDecl		: /*empty*/ 												{printf("fin t_varDecl\n");}
				| t_varDecl var_decl										{printf("t_varDecl\n");}
				;

t_statement 	: statement_l												{printf("statement\n");}
		 		| /*empty*/													{printf("fin t_statement\n");}
				;

statement_l		: statement_l statement										{printf("statliste\n");}
				| statement													{printf("finstatliste\n");}
				;

var_decl 		: t_param SEMICOL											{printf("var_decl\n");}
				;

statement 		: location ASSIGNOP expr SEMICOL							{printf("statement 1\n");}
				| method_call SEMICOL										{printf("statement 2\n");}
				| IF OPAR expr CPAR block									{printf("statement 3\n");}
				| IF OPAR expr CPAR block ELSE block						{printf("statement 4\n");}
				| FOR ID EGAL expr COMMA expr block							{printf("statement 5\n");}
				| RETURN SEMICOL											{printf("statement 6\n");}
				| RETURN expr SEMICOL										{printf("statement 7\n");}
				| BREAK SEMICOL												{printf("statement 8\n");}
				| CONTINUE SEMICOL											{printf("statement 9\n");}
				| block														{printf("statement 10\n");}
				;

method_call 	: ID OPAR t_expr CPAR 								{printf("method_call 1\n");}
				| ID OPAR CPAR										{printf("method_call 2\n");}
				;

t_expr 			: expr 															{printf("fin t_expr\n");}
				| t_expr COMMA expr												{printf("t_expr\n");}
				;

location 		: ID 															{printf("location 1\n");}
				| ID OSBRACK expr CSBRACK										{printf("location 2\n");}
				;

expr 			: location 														{printf("expr 1\n");}
				| method_call 													{printf("expr 2\n");}
				| literal 														{printf("expr 3\n");}
				| expr '+' expr													{printf("e+\n");}
				| expr MOINS expr													{printf("e-\n");}
				| expr '*' expr													{printf("e*\n");}
				| expr '/' expr													{printf("e/\n");}
				| expr '%' expr													{printf("modulo\n");}
				| expr INFEG expr												{printf("INFEG\n");}
				| expr SUPEG expr												{printf("SUPEG\n");}
				| expr INF expr													{printf("INF\n");}
				| expr SUP expr													{printf("SUP\n");}
				| expr EG expr													{printf("EG\n");}
				| expr NEG expr													{printf("NEG\n");}
				| expr AND expr													{printf("AND\n");}
				| expr OR expr													{printf("OR\n");}
				| '-' expr														{printf("expr 5\n");}
				| '!' expr														{printf("expr 6\n");}
				| OPAR expr CPAR												{printf("expr 7\n");}
				;

literal 		: int_literal 													{printf("literal 1\n");}
				| BOOL															{printf("literal 3\n");}
				| CHARLIT	 													{printf("literal 2\n");}
				;

int_literal 	: DEC 															{printf("int_literal 1\n");}
				| HEX															{printf("int_literal 2\n");}
				;
%%

void yyerror (char *s) {fprintf (stderr, "error on symbol \"%s\"\n", s);}

int main (void) {
	FILE *fp;
	fp = fopen("input.txt", "r");
	yyin = fp;
	yyparse();
	return 0;
}
