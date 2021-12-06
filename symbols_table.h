#ifndef SYMBOLS_TABLE_H
#define SYMBOLS_TABLE_H

#include <stdio.h>
#include"intermediate_code.h"
typedef struct entry{
    quadop *variable;
    struct entry *next;
} Symbole;

typedef struct context{
    Symbole *entries;
    struct context *parent;
} Contexte;

Contexte *pile = NULL; 

void pushctx();
void popctx();
Contexte *currentctx();
Symbole *newname(char *name);//faut peut etre ajouter type et valeur en param?
Symbole* lookup(char *name);

#endif