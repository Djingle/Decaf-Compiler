%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include "intermediate_code.h"
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern FILE *yyin;
int yydebug = 1;
Liste globalCode = NULL;
Quadruplet nextquad = 0;

%}

%union {
	struct {
		Liste true;
		Liste false;
		int intval;
		Quadop result;
	} exprval;
	struct {
		Liste next;
	} gt;
	Quadruplet mr;
}

%type <exprval> expr
%type <gt> g statement block
%type <mr> m

%start program

%token OBRACK CBRACK OPAR CPAR OSBRACK CSBRACK TYPE ID CLASSPRO BOOL DEC HEX CHARLIT SEMICOL COMMA
%token EGAL PEGAL MEGAL MOINS PLUS FOIS DIVISER MODULO NON
%token VOID FOR IF ELSE RETURN BREAK CONTINUE
%token INFEG SUPEG INF SUP B_EGAL B_NEGAL AND OR

%left PLUS MOINS
%left FOIS DIVISER MODULO
%nonassoc NON
%nonassoc INFEG SUPEG INF SUP B_EGAL B_NEGAL
%left AND OR


%%

program   		: CLASSPRO OBRACK t_fielDecl t_methoDecl CBRACK		{printf("program\n");}
				;

t_fielDecl		: t_fielDecl TYPE field_elem SEMICOL				{printf("t_fielDecl\n");}
				| /*empty*/											{}
				;

t_methoDecl 	: methoDecl_l										{printf("t_methoDecl\n");}
				| /*empty*/											{}
				;

methoDecl_l		: methoDecl_l method_decl							{printf("method\n");}
				| method_decl										{printf("method\n");}
				;

field_elem		: field_elem COMMA ID OSBRACK int_literal CSBRACK	{printf("tabliste\n");}
				| ID OSBRACK int_literal CSBRACK					{printf("tabfinliste\n");}
				| field_elem COMMA ID								{printf("varliste\n");}
				| ID												{printf("varfinliste\n");}
				;

method_decl		: 	VOID ID OPAR t_param CPAR block					{printf("method_decl 1\n");}
				| 	TYPE ID OPAR t_param CPAR block					{printf("method_decl 2\n");}
				|	VOID ID OPAR CPAR block							{printf("method_decl 3\n");}
				| 	TYPE ID OPAR CPAR block							{printf("method_decl 4\n");}
				;

t_param 		: TYPE ID											{printf("param\n");}
				| t_param COMMA TYPE ID								{printf("t_param\n");}
				;

block 			: OBRACK t_varDecl t_statement CBRACK				{printf("block\n");}
				;

t_varDecl		: var_decl_l										{printf("t_varDecl\n");}
				| /*empty*/ 										{}
				;

var_decl_l		: var_decl_l TYPE var_elem SEMICOL					{printf("vardecliste\n");}
				| TYPE var_elem SEMICOL								{printf("finvardecliste\n");}
				;

var_elem		: ID												{printf("finvarliste\n");}
				| var_elem COMMA ID									{printf("varliste\n");}
				;

t_statement 	: statement_l										{printf("statement\n");}
		 		| /*empty*/											{printf("fin t_statement\n");}
				;

statement_l		: statement_l statement								{printf("statliste\n");}
				| statement											{printf("finstatliste\n");}
				;


statement 		: location EGAL expr SEMICOL						{printf("statement 1a\n");}
				| location PEGAL expr SEMICOL						{printf("statement 1b\n");}
				| location MEGAL expr SEMICOL						{printf("statement 1b\n");}
				| method_call SEMICOL								{printf("statement 2\n");}

				| IF OPAR expr CPAR m block							{
																	complete($3.true, $5);
																	$$.next = concat($3.false, $6.next);
																	}
				| IF OPAR expr CPAR m block g ELSE m block			{
																	complete($3.true, $5);
																	complete($3.false, $9);
																	$$.next = concat($6.next, concat($7.next, $10.next));
																	}

				
				| FOR ID EGAL expr COMMA expr block					{printf("statement 5\n");}
				| RETURN SEMICOL									{printf("statement 6\n");}
				| RETURN expr SEMICOL								{printf("statement 7\n");}
				| BREAK SEMICOL										{printf("statement 8\n");}
				| CONTINUE SEMICOL									{printf("statement 9\n");}
				| block												{printf("statement 10\n");}
				;

method_call 	: ID OPAR t_expr CPAR 			{printf("method_call 1\n");}
				| ID OPAR CPAR					{printf("method_call 2\n");}
				;

t_expr 			: expr 							{printf("fin t_expr\n");}
				| t_expr COMMA expr				{printf("t_expr\n");}
				;

location 		: ID 							{printf("location 1\n");}
				| ID OSBRACK expr CSBRACK		{printf("location 2\n");}
				;

expr 			: location 						{printf("expr 1\n");}
				| method_call 					{printf("expr 2\n");}
				| literal 						{printf("expr 3\n");}
				| expr PLUS expr				{
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadruplet new = createQuad(Q_ADD, op1, op2, $$.result);
													gencode(new);
												}
				| expr MOINS expr				{printf("e-\n");}
				| expr FOIS expr				{printf("e*\n");}
				| expr DIVISER expr				{printf("e/\n");}
				| expr MODULO expr				{printf("modulo\n");}
				| MOINS expr					{printf("expr 5\n");}

				| expr INFEG expr				{
												// Instanciation of test quad
												$$.true = crelist(nextquad);
												Quadop gt = createQuadop(QO_GOTO, (u)NULL);
												Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
												Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
												Quadruplet new = createQuad(Q_LE, op1, op2, gt);
												gencode(new);
												// Instanciation of goto quad
												$$.false = crelist(nextquad);
												gt = createQuadop(QO_GOTO, (u)NULL);
												new = createQuad(Q_GOTO, gt, NULL, NULL);
												gencode(new);
												// À TESTER AVANT D'IMPLÉMENTER LES AUTRES (MÊME BAIL, JUSTE LE TYPE DE QUAD QUI CHANGE)
												}
				| expr SUPEG expr				{printf("SUPEG\n");}
				| expr INF expr					{printf("INF\n");}
				| expr SUP expr					{printf("SUP\n");}
				| expr B_EGAL expr				{printf("EG\n");}
				| expr B_NEGAL expr				{printf("NEG\n");}
				
				| expr AND m expr				{
												complete($1.true, $3);
												$$.false = concat($1.false, $4.false);
												$$.true = $4.true;
												}
				| expr OR m expr				{
												complete($1.false, $3);
												$$.true = concat($1.true, $4.true);
												$$.false = $4.false;
												}
				| NON expr						{
												$$.true = $2.false;
												$$.false = $2.true;
												}
				| OPAR expr CPAR				{
												$$ = $2;
												}
				;



literal 		: int_literal 					{printf("literal 1\n");}
				| BOOL							{printf("literal 3\n");}
				| CHARLIT	 					{printf("literal 2\n");}
				;


int_literal 	: DEC 							{printf("int_literal 1\n");}
				| HEX							{printf("int_literal 2\n");}
				;

g			: /*empty*/ 						{
												$$.next = crelist(nextquad);
												Quadop op1 = createQuadop(QO_GOTO, (u)NULL);
												Quadruplet new = createQuad(Q_GOTO, op1, NULL, NULL);
												gencode(new);
												}
			;

m			: /*empty*/ 						{
												$$ = nextquad;
												}
			;
%%

void yyerror (char *s) {fprintf (stderr, "error on symbol \"%s\"\n", s);}

int main (void) {
	FILE *fp;
	fp = fopen("input.txt", "r");
	yyin = fp;
	yyparse();
	printList(globalCode);
	return 0;
}
