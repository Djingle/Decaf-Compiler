#ifndef SYMBOLS_TABLE_H
#define SYMBOLS_TABLE_H

typedef struct entry{
    char *name;
    int type;
    int value;
    struct entry *next;
} Symbole;

typedef struct context{
    Entree *entries;
    struct context *parent;
} Contexte;

Contexte *pile = NULL; 

pushctx();
popctx();
Contexte *currentctx();
Entree *newname(char *name);//faut peut etre ajouter type et valeur en param?
Entree* lookup(char *name);

#endif