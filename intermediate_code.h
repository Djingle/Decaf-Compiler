#ifndef INTERMEDIATE_CODE_H
#define INTERMEDIATE_CODE_H

// Structures

typedef struct quadop{
    enum quadop_type {
        QO_CST,QO_NAME,QO_ADDRESS,QO_LABEL,QO_GOTO,QO_IF,QO_RETURN,QO_PARAM,QO_CALL,QO_READ,QO_WRITE,QO_PLUS,QO_MINUS,QO_MUL,QO_DIV,QO_EQ,QO_NE,QO_LT,QO_GT,QO_LE,QO_GE,QO_AND,QO_OR,QO_NOT,QO_NOP
    } type;
    union{
        int cst;
        char *name;
        quad *adresse_goto;
    } u;
}quadop;

typedef struct quad{
    enum quad_type {
        Q_ASSIGN,Q_ADD,Q_SUB,Q_MUL,Q_DIV,Q_MOD,Q_EQ,Q_NE,Q_LT,Q_GT,Q_LE,Q_GE,Q_AND,Q_OR,Q_NOT,Q_RETURN,Q_GOTO,Q_IF,Q_CALL,Q_PARAM,Q_READ,Q_WRITE,
    } type;
    quadop op1,op2,op3;
    quad *next;
}quad;

typedef struct List {
    quad *first;
    quad *last;
    int size;
} List;
typedef struct List* Liste;

// Functions
Liste crelist(quad* adresse);
Liste concat(Liste l1, Liste l2);
void complete(Liste l,quad* adresse);
void gencode();
void newtemp();

#endif  