%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <stdbool.h>
#include "symbols_table_var.h"
#include "intermediate_code.h"
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern FILE *yyin;
int yydebug = 1;
Quadruplet nextquad = NULL;
Lquad globalCode = NULL;
%}
%union {
	struct {
		Lquad vrai;
		Lquad faux;
		int intval;
		Quadop result;
	} exprval;
	struct {
		Lquad next;
	} gt;
	Quadruplet mr;
	struct {
		int intval;
		int boolval;
		char* stringval;
	} constLiteral;
	int constInt;
	char* constString;
}

%type <exprval> expr
%type <gt> g statement statement_l block
%type <mr> m
%type <constLiteral> literal
%type <constString> int_literal
%type <constString> location
//%type <constString> var_decl_l

%start program

%token OBRACK CBRACK OPAR CPAR OSBRACK CSBRACK CLASSPRO BOOL DEC HEX CHARLIT SEMICOL COMMA
%token <constString> TYPE ID
%token EGAL PEGAL MEGAL MOINS PLUS FOIS DIVISER MODULO NON
%token VOID FOR IF ELSE RETURN BREAK CONTINUE
%token INFEG SUPEG INF SUP B_EGAL B_NEGAL AND OR

%left PLUS MOINS
%left FOIS DIVISER MODULO
%nonassoc NON
%nonassoc INFEG SUPEG INF SUP B_EGAL B_NEGAL
%left AND OR

%%
program   		: CLASSPRO OBRACK t_fielDecl t_methoDecl CBRACK		{
																		printf("program\n");
																	}
				;
t_fielDecl		: t_fielDecl TYPE field_elem SEMICOL				{
																		newVar($2);
																		//putVars($2);
																	}
				| /*empty*/											{}
				;
t_methoDecl 	: methoDecl_l										{
																		printf("t_methoDecl\n");
																	}
				| /*empty*/											{}
				;
methoDecl_l		: methoDecl_l method_decl							{
																		printf("method\n");
																	}
				| method_decl										{
																		printf("method\n");
																	}
				;
field_elem		: field_elem COMMA ID OSBRACK int_literal CSBRACK	{} 								//TODO
				| ID OSBRACK int_literal CSBRACK					{} 								//TODO
				| field_elem COMMA ID								{
																		listvar($3);
																	}
				| ID												{
																		listvar($1);
																		//pushVar($3);
																	}
				| ID												{
																		//pushVar($1);
																	}
				;
method_decl		: 	VOID ID OPAR t_param CPAR block					{	
																		//newFct($2);	
																	}
				| 	TYPE ID OPAR t_param CPAR block					{	
																		//newFct($2);	
																	}
				|	VOID ID OPAR CPAR block							{	
																		//newFct($2);	
																	}
				| 	TYPE ID OPAR CPAR block							{	
																		//newFct($2);	
																	}
				;
t_param 		: TYPE ID											{
																		//putVar($1,$2);
																	}
				| t_param COMMA TYPE ID								{ 
																		//putVar($3,$4);
																	}
				;
block 			: OBRACK t_varDecl t_statement CBRACK				{
																		printf("la\n");
																	}
				;
t_varDecl		: var_decl_l										{
																		printf("t_varDecl\n");
																	}
				| /*empty*/ 										{}
				;
var_decl_l		: var_decl_l TYPE var_elem SEMICOL					{
																		newVar($2);	

																	}
				| TYPE var_elem SEMICOL								{	
																		newVar($1);	
																	}
				;
var_elem		: ID												{	
																		listvar($1);
																		//pushVar($1.constString);
																	}
				| var_elem COMMA ID									{	
																		listvar($3);
																		//pushVar($3.constString);
																	}

				;

t_statement 	: statement_l										{}
		 		| /*empty*/											{}
				;
statement_l		: statement_l m statement							{
																		$1.next = l_complete($1.next, $2);
																		$$.next = $3.next;
																	}
				| statement											{
																		$$.next = $1.next;
																	}
				;
statement 		: location EGAL expr SEMICOL						{
																		// J'AI MIS DES FAUX TRUCS POUR TESTER, JE LES LAISSE COMME ÇA TU PEUX TEST ET VOIR SI LES GOTO VONT AU BON ENDROIT
																		printf("now\n");
																		Quadop op1 = createQuadop(QO_CST, (u)1000);
																		Quadop op2 = createQuadop(QO_CST, (u)1000);
																		fillQuad(nextquad, Q_ADD, op1, op2, op1);
																		gencode();
																		setVal($1,convertIntegerToChar($3.intval)); 	// FROM AYOUB
																		//setVar($1,$3.val); 	// FROM AYOUB
																	}
				| location PEGAL expr SEMICOL						{
																		Quadop op1 = createQuadop(QO_CST, (u)2000);
																		Quadop op2 = createQuadop(QO_CST, (u)2000);
																		fillQuad(nextquad, Q_ADD, op1, op2, op1);
																		gencode();
																		//setVal($1);
																		printf("statement 1a\n");
																		//incrementVar($1,atoi($3.stringval)); /// FROM AYOUB
																	}
				| location MEGAL expr SEMICOL						{
																		printf("statement 1b\n");
																		//decrementVar($1,atoi($3.stringval));
																	}
					| method_call SEMICOL							{
																		printf("statement 2\n");
																		//execFct($1);				//TODO
																	}
				| IF OPAR expr CPAR m block							{
																		printf("Test :\n");
																		l_print(globalCode);
																		l_print($3.vrai);
																		$3.vrai = l_complete($3.vrai, $5);
																		printf("AVANT :\n");
																		l_print(globalCode);
																		$6.next = l_init();
																		$$.next = l_concat($3.faux, $6.next);
																		printf("APRES :\n");
																		l_print(globalCode);
																	}
				| IF OPAR expr CPAR m block g ELSE m block			{
																		l_complete($3.vrai, $5);
																		l_complete($3.faux, $9);
																		$6.next = l_init();
																		$7.next = l_init();
																		$10.next = l_init();
																		$$.next = l_concat($6.next, l_concat($7.next, $10.next));
																	}
				| FOR ID EGAL expr COMMA expr block					{
																	    // l_complete($7.next,nextquad);
																		// Quadop gt1 = createQuadop(QO_ADD, (u)(Quadruplet)NULL);
																		// Quadop op1 = createQuadop(QO_CST, (u)$2.intval);
																		// Quadop op2 = createQuadop(QO_CST, (u)1);
																		// fillQuad(nextquad, Q_ADD, op1, op2, gt1);
																		// gencode();
																		// Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
																		// fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
																		// gencode();
																		// $$.next = l_create($TODO);
																	}
				| RETURN SEMICOL									{
																		printf("statement 6\n");
																	}
				| RETURN expr SEMICOL								{
																		printf("statement 7\n");
																	}
				| BREAK SEMICOL										{
																		printf("statement 8\n");
																	}
				| CONTINUE SEMICOL									{
																		printf("statement 9\n");
																	}
				| block												{
																		printf("statement 10\n");
																	}
				;
method_call 	: ID OPAR t_expr CPAR 			{
													/*setParamsFct($1);*/				//TODO
												} 								
				| ID OPAR CPAR					{}
				;
t_expr 			: expr 							{
													printf("fin t_expr\n");
												}
				| t_expr COMMA expr				{
													printf("t_expr\n");
												}
				;
location 		: ID 							{
													$$ = $1;
													printf("location 1\n");
												}
				| ID OSBRACK expr CSBRACK		{
													printf("location 2\n");
												}
				;
expr 			: location 						{	
													$$.intval=atoi($1);			
												}
				| method_call 					{	
													/*$$.val=execFct($1);*/		  //TODO
												}           
				| literal 						{ 	
													$$.intval = atoi($1.stringval); 
												}
				| expr PLUS expr				{
													printf("On est là\n");
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop res = createQuadop(QO_CST, (u)(op1->value.cst+op2->value.cst));
													printf("op1->val : %d\n", op1->value.cst);
													printf("op2->val : %d\n", op2->value.cst);
													printf("res->val : %d\n", res->value.cst);
													fillQuad(nextquad, Q_ADD, op1, op2, res);
													$$.intval = op1->value.cst + op2->value.cst;
													gencode();
												}
				| expr MOINS expr				{	Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_SUB, op1, op2, $$.result);
													$$.intval = op1->value.cst - op2->value.cst;
													gencode();
												}
				| expr FOIS expr				{
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_MUL, op1, op2, $$.result);
													$$.intval = op1->value.cst * op2->value.cst;
													gencode();
												}
				| expr DIVISER expr				{
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_DIV, op1, op2, $$.result);
													$$.intval = op1->value.cst / op2->value.cst;
													gencode();
												}
				| expr MODULO expr				{
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_MOD, op1, op2, $$.result);
													$$.intval = op1->value.cst % op2->value.cst;
													gencode();
												}
				| MOINS expr					{
													printf("expr 5\n");
												}
				| expr INFEG expr				{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_LE, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
													// À TESTER AVANT D'IMPLÉMENTER LES AUTRES (MÊME BAIL, JUSTE LE TYPE DE QUAD QUI CHANGE)
												}
				| expr SUPEG expr				{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_GE, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
												}
				| expr INF expr					{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_LT, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
												}
				| expr SUP expr					{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_GT, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
												}
				| expr B_EGAL expr				{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_EQ, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
												}
				| expr B_NEGAL expr				{
													// Instanciation of test quad
													$$.vrai = l_create(nextquad);
													Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													fillQuad(nextquad, Q_NE, op1, op2, gt1);
													gencode();
													// Instanciation of goto quad
													$$.faux = l_create(nextquad);
													Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, gt2, NULL, NULL);
													gencode();
												}
				| expr AND m expr				{
													l_complete($1.vrai, $3);
													$$.faux = l_concat($1.faux, $4.faux);
													$$.vrai = $4.vrai;
												}
				| expr OR m expr				{
													l_complete($1.faux, $3);
													$$.vrai = l_concat($1.vrai, $4.vrai);
													$$.faux = $4.faux;
												}
				| NON expr						{
													$$.vrai = $2.faux;
													$$.faux = $2.vrai;
												}
				| OPAR expr CPAR				{
													$$ = $2;
												}
				;
literal 		: int_literal 					{
													$$.stringval = $1;
												} 
				| BOOL							{
													printf("literal 3\n");
												}
				| CHARLIT	 					{
													printf("literal 2\n");
												}
				;
int_literal 	: DEC 							{
													$$ = yylval.constString;
												}
				| HEX							{
													//$$ = (int)strtol(yylval.constString,NULL,0);
												}
				;
g			: /*empty*/ 						{
													$$.next = l_create(nextquad);
													Quadop op1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_GOTO, op1, NULL, NULL);
													gencode();
												}
			;
m			: /*empty*/ 						{
													$$ = nextquad;
												}
			;
%%
void yyerror (char *s) {fprintf (stderr, "error on symbol \"%s\"\n", s);}
void gencode()
{
	globalCode = l_push(globalCode, nextquad);
	nextquad = createQuad();
}
int main (int argc, char *argv[]) {
	globalCode = l_init();
	nextquad = createQuad();
	FILE *fp;
	if (argc == 1) fp = fopen("test2.txt", "r");
	else fp = fopen(argv[1], "r");
	yyin = fp;
	yyparse();
	printf("\n\nFINAL l_print\n");
	l_print(globalCode);
	return 0;
}