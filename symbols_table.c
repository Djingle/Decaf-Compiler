#include "symbols_table.h"
#include <string.h>
void pushctx(){
    Contexte *temp = (Contexte*)malloc(sizeof(Contexte));
    temp->parent = pile;
    temp->entries = NULL;
    pile = temp;

}
void popctx(){
    if(!pile)
        return;
    Contexte *temp = pile;
    pile = pile->parent;
    free(temp);
}
Contexte *currentctx(){
    return pile;
}
Symbole *newname(char *name){
    if(!pile)
        pushctx();
    Symbole *newEntree = (Symbole*)malloc(sizeof(Symbole));
    newEntree->next = pile->entries;
    quadop *q = (quadop *)malloc(sizeof(quadop));
    strcpy(q->value.name, name);
    q->type = QO_NAME;
    newEntree->variable = q;
    pile->entries = newEntree;
    return newEntree;
}
Symbole* lookup(char *name){
        if(pile == NULL)
        return NULL;
    Contexte *c = pile;
    while(c){
        Symbole *compteur = c->entries;
        while(compteur){
            if(!strcmp(compteur->variable->value.name, name))
                return compteur;
            compteur = compteur->next;
        }
        c = c->parent;
    }
    return NULL;
}
printVar(quadop var){
    printf("\nprinting var\n");
    printf("", var.type);
}
int main(){

    return 1;
}