%{
    #include <stdio.h>
    int yylex();
    void yyerror(char*);
%}

%start program
%%
program:
    ;

field_decl:
    ;

method_decl:
    ;

block:
    ;

var_decl: //rajouté id_list pour la liste d'id séparés
    | type id id_list ';'
    ;

id_list:
    | id
    | id ',' id_list
    ;

type:
    | 'int'
    | 'boolean'
    ;

statement:
    | location assign_op expr ';'
    | method_call ';'
    | 'if(' expr ')' block
    | 'if(' expr ')' block 'else' block
    | 'for' id '=' expr ',' expr block
    | 'return' ';'
    | 'return' expr ';'
    | 'break' ';'
    | 'continue' ';'
    | block
    ;

assign_op:
    | '='
    | '+='
    | '-='
    ;

method_call:
    ;

method_name:
    | id
    ;

location:
    | id
    | id '[' expr ']'
    ;

expr:
    | location
    | method_call
    | literal
    | expr bin_op expr
    | '-' expr
    | '!' expr
    | '(' expr ')'
    ;

bin_op:
    | arith_op
    | rel_op
    | eq_op
    | cond_op
    ;


%%
