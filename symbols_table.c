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
Entree *newname(char *name){
    Entree *newEntree = (Entree*)malloc(sizeof(Entree));
    newEntree->next = pile->entries;
    strcpy(newEntree->name, name);
    pile->entries = newEntree;
    return newEntree;
}
Entree* lookup(char *name){
    if(pile == NULL)
        return NULL;
    Entree *compteur = pile->entries;
    while(compteur){
        if(!strcmp(compteur->name, name))
            return compteur;
        compteur = compteur->next;
    }
    return NULL;
}