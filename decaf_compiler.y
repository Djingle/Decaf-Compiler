%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <stdbool.h>
#include<string.h>
#include "symbols_table_var.h"
#include "intermediate_code.h"
#include "utility.h"
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern FILE *yyin;
FILE* out;
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
		int type;		// 0: int   1: bool
        int isId;		// 0: valeur 1:ID
	} exprval;
	struct {
		Lquad next;
	} gt;
	Quadruplet mr;
	struct {
		int intval;
		int boolval;
		char* stringval;
		int type;		// 0: int   1: bool
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
%token READ WRITEINT WRITESTRING WRITEBOOL
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
t_fielDecl		: t_fielDecl TYPE field_elem SEMICOL				{	// SEUL LE CAS OÛ 	field_elem -> ID
																		adresselist *adresses;
																		adresses = newVar($2);
																		while(adresses){
																			Quadop op1 = createQuadop(QO_CST, (u)adresses->adresse);
																			Quadop op2 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
																			fillQuad(nextquad, Q_ALLOC, op1, op2, op2);
																			gencode();
																			adresses = adresses->next;
																		}
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
field_elem		: field_elem COMMA ID OSBRACK int_literal CSBRACK	{} 							
				| ID OSBRACK int_literal CSBRACK					{} 						
				| field_elem COMMA ID								{listvar($3);}
				| ID												{listvar($1);} 
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
																		adresselist *adresses;
																		adresses = newVar($2);
																		while(adresses){
																			Quadop op1 = createQuadop(QO_CST, (u)adresses->adresse);
																			Quadop op2 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
																			fillQuad(nextquad, Q_ALLOC, op1, op2, op2);
																			gencode();
																			adresses = adresses->next;
																		}
																	}
				| TYPE var_elem SEMICOL								{	
																		adresselist *adresses;
																		adresses = newVar($1);
																		while(adresses){
																			Quadop op1 = createQuadop(QO_CST, (u)adresses->adresse);
																			Quadop op2 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
																			fillQuad(nextquad, Q_ALLOC, op1, op2, op2);
																			gencode();
																			adresses = adresses->next;
																		}
																	}
				;
var_elem		: ID												{
																		listvar($1);
																	}
				| var_elem COMMA ID									{															//TODO & MÀJ ligne 124
																		listvar($3);
																		//pushVar($3.constString);
																	}

				;

t_statement 	: statement_l										{}
		 		| /*empty*/											{}
				;
statement_l		: statement_l m statement							{	$1.next = l_complete($1.next, $2);
																		$$.next = $3.next;
																	}
				| statement											{	$$.next = $1.next;	}
				;
statement 		: location EGAL expr SEMICOL						{	
																		//ADRESSE de location dans tab1
																		//ADRESSE de expr dans tab2
																		// J'AI MIS DES FAUX TRUCS POUR TESTER, JE LES LAISSE COMME ÇA TU PEUX TEST ET VOIR SI LES GOTO VONT AU BON ENDROIT
																		// Je suis pas tres sur de ce que j'ai ecrit avant le gencode, please check before use
																		printf("now\n");
																		//setVal($1,convertIntegerToChar($3.intval)); 	// FROM AYOUB
																		//setVar($1,$3.val); 	// FROM AYOUB
																		Quadop op1 = createQuadop(QO_CST, (u)getVal($1));
																		Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
																		fillQuad(nextquad, Q_ASSIGN, op1, op2, op1);
																		gencode();
																		$$.next = l_create(nextquad);
																	}
				| location PEGAL expr SEMICOL						{
																		Quadop op1 = createQuadop(QO_CST, (u)getVal($1));
																		Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
																		fillQuad(nextquad, Q_ADD, op1, op2, op1);
																		gencode();
																		printf("statement 1a\n");
																		//incrementVar($1,atoi($3.stringval)); /// FROM AYOUB
																		$$.next = l_create(nextquad);
																	}
				| location MEGAL expr SEMICOL						{	
																		Quadop op1 = createQuadop(QO_CST, (u)getVal($1));
																		Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
																		fillQuad(nextquad, Q_SUB, op1, op2, op1);
																		gencode();
																		printf("statement 1b\n");
																		//decrementVar($1,atoi($3.stringval));
																		$$.next = l_create(nextquad);
																	}
				| method_call SEMICOL								{
																		printf("statement 2\n");
																		//execFct($1);				//TODO
																	}
				| READ OPAR location CPAR SEMICOL 						{
																		
																		Quadop op1 = createQuadop(QO_CST, (u)getVal($3));
																		Quadop op2 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
																		fillQuad(nextquad, Q_SUB, op1, op2, op2);
																		gencode();
																	}
				| WRITEINT OPAR expr CPAR SEMICOL 					{

																	}
				| WRITEBOOL OPAR expr CPAR SEMICOL 					{

																	}
				| WRITESTRING OPAR expr CPAR SEMICOL 					{

																	}
				| IF OPAR expr CPAR m block							{
																		printf("Test :\n");
																		l_print(globalCode);
																		l_print($3.vrai);
																		$3.vrai = l_complete($3.vrai, $5);
																		printf("AVANT :\n");
																		l_print(globalCode);
																		int type;
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
													$$ = copystr($1); //$$.constString = $1;
													printf("location 1\n");
												}
				| ID OSBRACK expr CSBRACK		{
													printf("location 2\n");
												}
				;
expr 			: location 						{	  
													$$.intval = newtempvar();
													
													Quadop op1 = createQuadop(QO_CST, (u)$$.intval);
													Quadop op2 = createQuadop(QO_CST, (u)getVal($1));
													Quadop op3 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_ASSIGN_TEMP_ID, op1, op2, op3);
													gencode();
												}
				| method_call 					{	// $$.type = 0; 
													//$$.val=execFct($1);	  //TODO
												}           
				| literal 						{ 		
													$$.intval = newtempvar();
													
													Quadop op1 = createQuadop(QO_CST, (u)$$.intval);
													Quadop op2 = createQuadop(QO_CST, (u)atoi($1.stringval));
													Quadop op3 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
													fillQuad(nextquad, Q_ASSIGN_TEMP_VAL, op1, op2, op3);
													gencode();
												}
				| expr PLUS expr				{	
													if($1.type != 0 || $3.type != 0){
														//error and exit
													}
													$$.type = 0;
													printf("On est là\n");
													$$.intval = $1.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop resAdd = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_ADD, op1, op2, resAdd);
													gencode();
												}
				| expr MOINS expr				{	
													if($1.type != 0 || $3.type != 0){
														//error and exit
													}
													$$.type = 0;
													$$.intval = $1.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop resSub = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_SUB, op1, op2, resSub);
													gencode();
												}
				| expr FOIS expr				{	
													if($1.type != 0 || $3.type != 0){
														//error and exit
													}
													$$.type = 0;
													$$.intval = $1.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop resMult = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_MUL, op1, op2, resMult);
													gencode();
												}
				| expr DIVISER expr				{	
													if($1.type != 0 || $3.type != 0){
														//error and exit
													}
													$$.type = 0;
													$$.intval = $1.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop resDiv = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_DIV, op1, op2, resDiv);
													gencode();
												}
				| expr MODULO expr				{	
													if($1.type != 0 || $3.type != 0){
														//error and exit
													}
													$$.type = 0;
													$$.intval = $1.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$1.intval);
													Quadop op2 = createQuadop(QO_CST, (u)$3.intval);
													Quadop resMod = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_MOD, op1, op2, resMod);
													gencode();
												}
				| MOINS expr					{
													if($2.type != 0){
														//error and exit
													}
													$$.type = $2.type;
													$$.intval = $2.intval;
													Quadop op1 = createQuadop(QO_CST, (u)$2.intval);
													Quadop op2 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
													Quadop resMoins = createQuadop(QO_CST, (u)$$.intval);
													fillQuad(nextquad, Q_SUB, resMoins, op1, op2);
													gencode();
												}
				| expr INFEG expr				{	
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type !=  $3.type){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.type = $1.type;
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
													if($1.type != 1 || $4.type != 1){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													l_complete($1.vrai, $3);
													$$.faux = l_concat($1.faux, $4.faux);
													$$.vrai = $4.vrai;
													$$.type = 1;
												}
				| expr OR m expr				{
													if($1.type != 1 || $4.type != 1){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													l_complete($1.faux, $3);
													$$.vrai = l_concat($1.vrai, $4.vrai);
													$$.faux = $4.faux;
													$$.type = 1;
												}
				| NON expr						{
													if($2.type != 1){
														//error et exit
printf("cannot perform operation with current type(s)\n");

													}
													$$.vrai = $2.faux;
													$$.faux = $2.vrai;
													$$.type = 1;
												}
				| OPAR expr CPAR				{
													$$ = $2;
												}
				;
literal 		: int_literal 					{
													$$.stringval = $1;
													$$.type = 0;
												} 
				| BOOL							{
													$$.type = 1;
													if(!strcmp(yylval.constString, "false"))
														$$.stringval = "0";		
													else {
														$$.stringval = "1";
												}
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
	char* outputFile = "output.mips";
	if (argc == 1) fp = fopen("test2.txt", "r");
	else{
		fp = fopen(argv[1], "r");
		if (fp == NULL) {
			printf("File not found\n");
			return 0;
		}
		if(argc >= 3){
			for(int i=2; i<argc; i++){
				if(!strcmp(argv[i], "-o")){
					i++;
					outputFile = argv[i];
				} else if (!strcmp(argv[i],"-version"))
					printf("Version 1.0\n");
				else if (!strcmp(argv[i], "-tos"))
					printTos();
				else
					printf("Unknow option %s\n", argv[i]);
			}
		}
	} 

	yyin = fp;
	yyparse();
	printf("\n\nFINAL l_print\n");
	//l_print(globalCode);
	FILE *out = fopen(outputFile, "w");
	l_translate(globalCode, out);
	return 0;
}
