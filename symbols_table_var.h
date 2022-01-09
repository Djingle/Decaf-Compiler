#ifndef SYMBOLS_TABLE_VAR_H
#define SYMBOLS_TABLE_VAR_H

#include <stdio.h>
#include <stdlib.h>

typedef struct tempvar{
    char* name;
    struct tempvar* next;
}tempvar;

typedef union operand_val operand_val;
typedef enum operand_type {
    OP_INT, OP_BOOL
} operand_type;
typedef struct entry{
    operand_type type;
    char name[32];
    union operand_val {
        int ival;
        float fval;
        int bool_val;
    } value;
    struct entry *next;
} variable;

typedef struct scope{
    variable *entries;
    struct scope *parent;
} Scope;

 
void listvar(char* name);
void clearListVar();
void pushctx();
void popctx();
Scope *currentctx();
void newVar(char *);
variable *setVal(char *, char *);
void setValUtil(variable *, operand_val);
variable* lookup(char *);
char* convertIntegerToChar(int n);

#endif