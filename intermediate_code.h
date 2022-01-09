#ifndef INTERMEDIATE_CODE_H
#define INTERMEDIATE_CODE_H
#include <stdio.h>
#include <stdlib.h>

// Structures
typedef union u u;
typedef struct quad quad;
typedef quad* Quadruplet;

// Enums
typedef enum quadop_type {
    QO_CST,QO_NAME,QO_ADDRESS,QO_LABEL,QO_GOTO,QO_IF,QO_RETURN,QO_PARAM,
    QO_CALL,QO_READ,QO_WRITE,QO_PLUS,QO_MINUS,QO_MUL,QO_DIV,QO_EQ,QO_NE,
    QO_LT, QO_GT,QO_LE,QO_GE,QO_AND,QO_OR,QO_NOT,QO_NOP
} quadop_type;
typedef enum quad_type {
    Q_ASSIGN,Q_ADD,Q_SUB,Q_MUL,Q_DIV,Q_MOD,Q_EQ,Q_NE,Q_LT,Q_GT,Q_LE,Q_GE,
    Q_AND,Q_OR,Q_NOT,Q_RETURN,Q_GOTO,Q_IF,Q_CALL,Q_PARAM,Q_READ,Q_WRITE
} quad_type;

typedef struct quadop{
    quadop_type type;
    union u {
        int cst;
        char *name;
        Quadruplet adresse_goto;
    } value;
}quadop,*Quadop;

typedef struct quad{
    quad_type type;
    Quadop op1,op2,op3;
} *Quadruplet; 

typedef struct lquad {
    Quadruplet q;
    struct lquad* next;
}lquad, *Lquad;


// Functions
Quadop createQuadop(enum quadop_type type, union u value);
Quadruplet createQuad();
void fillQuad(Quadruplet q, enum quad_type type, Quadop op1, Quadop op2, Quadop op3);


Lquad l_init();
Lquad l_create(Quadruplet adresse);
void l_print(Lquad l);
void printQuad(Quadruplet q, Lquad l);
Lquad l_push(Lquad l, Quadruplet adresse);
Lquad l_concat(Lquad l1, Lquad l2);
Lquad l_complete(Lquad l,Quadruplet adresse);

void gencode();
Quadop newtemp();

#endif  