#include "intermediate_code.h"
Liste globalCode = NULL;
size_t nextquad;

Liste crelist(quad* adresse){
    Liste liste;
    liste = (Liste)malloc(sizeof(Liste));
    liste->first = adresse;
    liste->last = adresse;
    liste->size = 1;
    return liste;
}

Liste push(Liste liste, quad adresse){
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
    l1->last->next = l2->first;
    liste->first = l1->first;
    liste->last = l2->last;
    liste->size = l1->size + l2->size;
    return liste;
}

void complete(Liste l,quad* adresse){
    while(l != NULL){
        switch(l->first->type){
            case Q_GOTO: 
                l->first->op1.type = QO_GOTO;
                l->first->op1.u = adresse;
                break;
            case Q_IFEQ: case Q_IFNE: case Q_IFGT: case Q_IFGE: case Q_IFLT: case Q_IFLE:
                l->first->op3.type = QO_IF;
                l->first->op3.u = adresse;
                break;
            default :
                printf("%d\n",l->first->type);
                break;
        }
        l = l->next;
    }
}

void gencode(quad* instruction_3_adresses){
    push(globalCode,instruction_3_adresses);
    nextquad++;
}
quadop newtemp(){
    
}
