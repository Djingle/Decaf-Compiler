#include "intermediate_code.h"
#include "symbols_table.h"

Quadop createQuadop(enum quadop_type type,u value){
    Quadop q = (Quadop)malloc(sizeof(quadop));
    q->type = type;
    q->value = value;
    return q;
}
Quadruplet createQuad(enum quad_type type, Quadop op1, Quadop op2, Quadop res){
    Quadruplet q = (Quadruplet)malloc(sizeof(quad));
    q->type = type;
    q->op1 = op1;
    q->op2 = op2;
    q->op3 = res;
    q->next = NULL;
    return q;
}
 
Liste initList()
{
    Liste l = (Liste)malloc(sizeof(list));
    if (l == NULL) {printf("malloc failed\n"); exit(EXIT_FAILURE);}
    l->first = NULL;
    l->last = NULL;
    l->size = 0;
    return l;
}

Liste crelist(Quadruplet adresse){
    Liste liste = (Liste)malloc(sizeof(list));
    if (liste == NULL) {printf("malloc failed\n"); exit(EXIT_FAILURE);}
    liste->first = adresse;
    liste->last = adresse;
    liste->size = 1;
    return liste;
}

Liste push(Liste liste,Quadruplet adresse){
    if(liste->first == NULL) {
        liste->first = adresse;
        liste->last = adresse;
        liste->size++;
    }
    else{
        liste->last->next = adresse;
        liste->last = adresse;
        liste->size++;
    }
    return liste;
}
Liste concat(Liste liste1, Liste liste2){
    if (liste1 == NULL) return liste2;
    if (liste2 == NULL) return liste1;
    Liste liste;
    liste1->last->next = liste2->first;
    liste->first = liste1->first;
    liste->last = liste2->last;
    liste->size = liste1->size + liste2->size;
    return liste;
}
void printList(Liste liste){
    if(liste == NULL){
        printf("Liste vide\n");
    }
    else{
        printf("Liste: \n");
        Quadruplet q = liste->first;
        int c=0;
        while(q != NULL){
            printf("%d: ", c);
            printQuad(q);
            q = q->next;
            c++;
        }
    }
    printf("\n");
}
void printQuad(Quadruplet q)
{
    quad_type type = q->type;
    switch(type) {
        case Q_GOTO:
            printf("Q_GOTO: ");
            if (q->op1->value.adresse_goto==NULL) printf("NULL\n");
            else printf("%d\n", q->op1->type);
            break;
        case Q_LT:
            printf("Q_LT: %d, %d ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", q->op3->type);
            break;
        case Q_ADD: printf("Q_ADD: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->type); break;
        case Q_SUB: printf("Q_SUB: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->type); break;
        case Q_MUL: printf("Q_MUL: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->type); break;
        case Q_DIV: printf("Q_DIV: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->type); break;
        case Q_MOD: printf("Q_MOD: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->type); break;
    }
}
Liste complete(Liste l,Quadruplet adresse){
    printf("ouioui\n");
    int compteur;
    printList(l);
    if (l==NULL) return l;
    Quadruplet save = l->first;
    int c = 0;
    while(save != NULL){
        quad_type type = save->type;
        printf("::%d:: %d\n", c, type);
        switch(type){
            case Q_GOTO:
                if (save->op1->value.adresse_goto==NULL) {
                    save->op1->value.adresse_goto = adresse;
                }
                break;
            case Q_EQ: case Q_NE: case Q_LT: case Q_GT: case Q_LE: case Q_GE:
                if (save->op3->value.adresse_goto==NULL) {
                    save->op3->value.adresse_goto = adresse;
                }
                break;
            default :
                printf("%d : cannot complete\n",save->type);
                break;
        }
        save = save->next;
        c++;
    }
    return l;
}

// int main(){
//     //LIST OPERATIONS TESTS
//     printf("I: Quadop, Quad and List Instanciations tests\n");
//     Quadop op1 = createQuadop(QO_CST, (u)3);
//     Quadop op2 = createQuadop(QO_CST, (u)5);
//     Quadop op3 = createQuadop(QO_CST, (u)(Quadruplet)NULL);
//     Quadop op4 = createQuadop(QO_CST, (u)3);
//     Quadop op5 = createQuadop(QO_CST, (u)3);
//     Quadop op6 = createQuadop(QO_CST, (u)3);

//     Quadruplet q1 = createQuad(Q_ADD,op1,op2,op3);
//     Quadruplet q2 = createQuad(Q_SUB,op3,op4,op5);
//     Quadruplet q3 = createQuad(Q_MUL,op4,op5,op6);
//     Liste l = crelist(q1);
//     l = push(l,q2);
//     l = push(l,q3);
//     printList(l);

//     //Complete function tests
//     printf("\n\nII: Complete tests\n");
//     Quadop gt1 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
//     Quadop gt2 = createQuadop(QO_GOTO, (u)(Quadruplet)NULL);
//     // Warning: quadops are pointers, so if you want 2 quads to have 2 different gotos, define 2 quadops.

//     Quadruplet q4 = createQuad(Q_LT, op1, op2, gt1);
//     Quadruplet q5 = createQuad(Q_GOTO, gt2, NULL, NULL);
//     Liste l2 = crelist(q5);
//     l2 = push(l2, q4);
//     printf("before complete :\n");
//     printList(l2);
//     l2 = complete(l2, q3);
//     printf("after complete :\n");
//     printList(l2);
//     return EXIT_SUCCESS;
// }
