#include "structure.h"
#include <string.h>
#include <stdio.h>

Fct* listFct = NULL; 
Scope* global = NULL; 
Scope* currentScope = NULL; 
Var* varsInScope = NULL; 


Fct newFct(char* name){
    Fct* fct = (Fct*)malloc(sizeof(Fct));
    strcpy(fct->name,name);
    fct->next=listFct;
    listFct=fct;
    fct->scope=newScope();
}

Fct newScope(){
    Scope* scope = (Scope*)malloc(sizeof(Scope));
    if (global==NULL) {
        global=scope;
        scope->parent=NULL;
    }
    else scope->parent=global;
    scope->entries=NULL;
    currentScope=scope;
}

void putVar(char* type, char* name){
    Var* var = (Var*)malloc(sizeof(Var));
    if (currentScope==NULL) {
        Scope* scope = (Scope*)malloc(sizeof(Scope));
        global=scope;
        currentScope=scope;
        scope->parent=NULL;
    }
    var->next=currentScope->entries;
    currentScope->entries=var;
    strcpy(var->type,type);
    strcpy(var->name,name);
}
void setVar(char* name, char* value){
    Var* var = currentScope->entries;
    while (var) {
        if(!strcmp(var->name, name)) 
            strcpy(var->value,value);
            return;
        var=var->next;
    }
    printf("\" %s \"variable not found\n",name);
}
void pushVar(char* name){
    Var* var = (Var*)malloc(sizeof(Var));
    if (currentScope==NULL) {
        Scope* scope = (Scope*)malloc(sizeof(Scope));
        global=scope;
        currentScope=scope;
        scope->parent=NULL;
    }
    var->next=currentScope->entries;
    currentScope->entries=var;
    var->type=NULL;
    strcpy(var->name,name);
}
void putVars(char* type){
    if (currentScope==NULL)
        return;
    Var* var = currentScope->entries;
    while (var) {
        strcpy(var->type,type);
        var=var->next;
    }
}


void incrementVar(char* name, char* value){
    Var* var = currentScope->entries;
    while (var) {
        if(!strcmp(var->name, name)) 
            strcpy(var->value,var->value+value);
            return;
        var=var->next;
    }
    printf("\" %s \"variable not found\n",name);
}
void decrementVar(char* name, char* value){
    Var* var = currentScope->entries;
    while (var) {
        if(!strcmp(var->name, name)) 
            strcpy(var->value,var->value-value);
            return;
        var=var->next;
    }
    printf("\" %s \"variable not found\n",name);
}
/*
void add(char* name1, char* name2){
    Var* var = currentScope->entries;
    while (var) {
        if(!strcmp(var->name, name1)) 
            strcpy(var->value,var->value-value);
            return;
        var=var->next;
    }
    printf("\" %s \"variable not found\n",name);
}*/


void newVariable(char *name, char *type){
    listvar(name);
    newVar(type);
}
void TwonewVariable(char *name1, char*name2 , char *type){
    listvar(name1);
    listvar(name2);
    newVar(type);
}
void printVar(variable var){
    printf("%s = ", var.name);

    switch (var.type)
    {
    case OP_INT:
        printf("%d ", var.value.ival);
        break;
    case OP_BOOL:
        printf(var.value.bool_val?"true ":"false ");
        break;
    default:
        printf("TYPE ERROR");
        break;
    }
    printf("\n");
}
void printAllVars(){
    Scope *c = pile;
    while(c){
        variable *compteur = c->entries;
        while(compteur){
            printVar(*compteur);
            compteur = compteur->next;
        }
        c = c->parent;
    }
}
int main(){
    newVariable("temp", "int");
    setVal("temp1", (operand_val)0);
    setVal("temp", (operand_val)13);
    pushctx();
    newVariable("temp10", "bool");
    setVal("temp10", (operand_val)0);
    TwonewVariable("temp2", "temp3", "int");
    setVal("temp2", (operand_val)25);
    setVal("temp3", (operand_val)13);
    newVariable("tempdff", "float");
    printAllVars();
    return 1;
}