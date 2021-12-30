#ifndef INTERMEDIATE_CODE_H
#define INTERMEDIATE_CODE_H
#include <stdio.h>
#include <stdlib.h>

// Structures
typedef struct quad quad;
typedef quad* Quadruplet;
typedef enum quadop_type {
    QO_CST,QO_NAME,QO_ADDRESS,QO_LABEL,QO_GOTO,QO_IF,QO_RETURN,QO_PARAM,
    QO_CALL,QO_READ,QO_WRITE,QO_PLUS,QO_MINUS,QO_MUL,QO_DIV,QO_EQ,QO_NE,
    QO_LT, QO_GT,QO_LE,QO_GE,QO_AND,QO_OR,QO_NOT,QO_NOP
} quadop_type;
typedef enum quad_type {
    Q_ASSIGN,Q_ADD,Q_SUB,Q_MUL,Q_DIV,Q_MOD,Q_EQ,Q_NE,Q_LT,Q_GT,Q_LE,Q_GE,
    Q_AND,Q_OR,Q_NOT,Q_RETURN,Q_GOTO,Q_IF,Q_CALL,Q_PARAM,Q_READ,Q_WRITE
} quad_type;

//QO_GOTOI stands for goto incomplete
typedef struct quadop{
    quadop_type type;
    union u{
        int cst;
        char *name;
        Quadruplet adresse_goto;
    } value;
}quadop,*Quadop;

typedef union u u;

struct quad{
    quad_type type;
    Quadop op1,op2,op3;
    struct quad *next;
}; 
typedef quad* Quadruplet;

typedef struct list {
    Quadruplet first;
    Quadruplet last;
    int size;
} list, *Liste;


// Functions
Quadop createQuadop(enum quadop_type type, union u value);
Quadruplet createQuad(enum quad_type type, Quadop op1, Quadop op2, Quadop res);
void printQuad(Quadruplet q);

Liste crelist();
void printList(Liste l);
Liste push(Liste l, Quadruplet adresse);
Liste concat(Liste l1, Liste l2);
Liste complete(Liste l,Quadruplet adresse);

void gencode();
Quadop newtemp();

#endif  