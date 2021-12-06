#include "intermediate_code.h"
#include "symbols_table.h"
Liste globalCode = NULL;
size_t nextquad;

Quadop create_quadopInt(enum quadop_type type, int cst){
    Quadop q = (Quadop)malloc(sizeof(quadop));
    q->type = type;
    q->u.cst = cst;
    return q;
}
Quadop create_quadopString(enum quadop_type type, char *name){
    Quadop q = (Quadop)malloc(sizeof(quadop));
    q->type = type;
    q->u.name = name;
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
Liste crelist(Quadruplet adresse){
    Liste liste;
    liste = (Liste)malloc(sizeof(list));
    liste->first = adresse;
    liste->last = adresse;
    liste->size = 1;
    return liste;
}

Liste push(Liste liste,Quadruplet adresse){
    if(liste == NULL){
        liste = crelist(adresse);
    }
    else{
        liste->last->next = adresse;
        liste->last = adresse;
        liste->size++;
    }
    return liste;
}
Liste concat(Liste liste1, Liste liste2){
    Liste liste;
    liste1->last->next = liste2->first;
    liste->first = liste1->first;
    liste->last = liste2->last;
    liste->size = liste1->size + liste2->size;
    return liste;
}
void printListe(Liste liste){
    if(liste == NULL){
        printf("Liste vide\n");
    }
    else{
        printf("Liste non vide\n");
        Quadruplet q = liste->first;
        while(q != NULL){
            printQuad(q);
            q = q->next;
        }
    }
}
void printQuad(Quadruplet q){
    printf("%d %d %d %d\n",q->type,q->op1->type,q->op2->type,q->op3->type);
}
// void complete(Liste l,Quadruplet adresse){
    // while(l != NULL){
    //     switch(l->first->type){
    //         case Q_GOTO: 
    //             l->first->op1.type = QO_GOTO;
    //             l->first->op1.u = adresse;
    //             break;
    //         case Q_IFEQ: case Q_IFNE: case Q_IFGT: case Q_IFGE: case Q_IFLT: case Q_IFLE:
    //             l->first->op3.type = QO_IF;
    //             l->first->op3.u = adresse;
    //             break;
    //         default :
    //             printf("%d\n",l->first->type);
    //             break;
    //     }
    //     l = l->next;
    // }
// }

void gencode(Quadruplet instruction_3_adresses){
    push(globalCode,instruction_3_adresses);
    nextquad++;
}
quadop *newtemp(){
    return newname("name")->variable;// je sais pas quoi mettre comme nom variable temporaire
}

int main(){
    //display on the terminal a text
    printf("Hello World\n");

    Quadop op1 = create_quadopInt(QO_CST,1);
    Quadop op2 = create_quadopInt(QO_CST,2);
    Quadop op3 = create_quadopInt(QO_CST,3);
    Quadop op4 = create_quadopString(QO_NAME,"test");
    Quadop op5 = create_quadopString(QO_NAME,"test2");
    Quadop op6 = create_quadopString(QO_NAME,"test3");

    //display another text
    printf("Middle 1 World\n");
    Quadruplet q1 = createQuad(Q_ADD,op1,op2,op3);
    Quadruplet q2 = createQuad(Q_IF,op3,op4,op5);
    Quadruplet q3 = createQuad(Q_MUL,op4,op5,op6);
    printf("Middle 2 World\n");
    Liste l = crelist(q1);
    l = push(l,q2);
    l = push(l,q3);
    printf("Bye World\n");
    printListe(l);
    return EXIT_SUCCESS;
}
