#include "symbols_table.h"
#include <string.h>
void pushctx(){
    Contexte *temp = pile;
    if(pile == NULL)
        pile = (Contexte*)malloc(sizeof(Contexte));
    pile->parent = temp;
    pile->entries = NULL;
}
void popctx(){
    Contexte *temp = pile;
    pile = pile->parent;
    free(temp);
}
Contexte *currentctx(){
    return pile;
}
Symbole *newname(char *name){
    Symbole *newEntree = (Symbole*)malloc(sizeof(Symbole));
    newEntree->next = pile->entries;
    quadop *q = (quadop *)malloc(sizeof(quadop));
    strcpy(q->u.name, name);
    q->type = QO_NAME;
    newEntree->variable = q;
    pile->entries = newEntree;
    return newEntree;
}
Symbole* lookup(char *name){
    if(pile == NULL)
        return NULL;
    Symbole *compteur = pile->entries;
    while(compteur){
        if(!strcmp(compteur->variable->u.name, name))
            return compteur;
        compteur = compteur->next;
    }
    return NULL;
}