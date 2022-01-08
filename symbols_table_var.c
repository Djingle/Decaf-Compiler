#include "symbols_table_var.h"
#include <string.h>
void pushctx(){
    Scope *temp = (Scope*)malloc(sizeof(Scope));
    temp->parent = pile;
    temp->entries = NULL;
    pile = temp;
}
void popctx(){
    if(!pile)
        return;
    Scope *temp = pile;
    pile = pile->parent;
    free(temp);
}
Scope *currentctx(){
    return pile;
}

void listvar(char* name){
    tempvar* newname = (tempvar*)malloc(sizeof(tempvar));
    newname->name = name;
    newname->next = templist;
    templist = newname;
}

void clearListVar(){
    while(templist){
        tempvar *v = templist;
        templist = templist->next;
        free(v);
    }
}

void newVar(char* type){
    if(!pile)
        pushctx();
    tempvar *temp = templist;
    while(temp){
        if(lookup(temp->name)){
            printf("attempting to redefine the variable \"%s\"\n", temp->name);
            return;    
        }
        operand_type temp_type;
        if(!strcmp(type, "int"))
            temp_type = OP_INT;
        else if(!strcmp(type, "bool"))
            temp_type = OP_BOOL;
        else{
            printf("\"%s\" is not a type\n", type);
            return;
        }
        variable *newEntree = (variable*)malloc(sizeof(variable));
        newEntree->next = pile->entries;
        strcpy(newEntree->name, temp->name);
        newEntree->type = temp_type;
        pile->entries = newEntree;
        temp = temp->next;
    }
    clearListVar();
}

void setValUtil(variable *s, operand_val val){
    switch(s->type){
        case OP_INT:
            s->value.ival = val.ival;
            break;
        case OP_BOOL:
            s->value.bool_val = val.bool_val;
            break;
    }
}
int myatoi(char *val){
    int len = strlen(val);
    /*for(int i=0;i<len;i++){
        if()
    }*/
}
variable *setVal(char *name, char* val){
    if(pile == NULL)
        return NULL;
    Scope *c = pile;
    while(c){
        variable *compteur = c->entries;
        while(compteur){
        if(!strcmp(compteur->name, name)){
            switch(compteur->type){
                case OP_INT:
                    compteur->value.ival = atoi(val);///A CHANGER -----------------------
                    break;
                case OP_BOOL:
                    if(!strcmp(val, "false"))
                        compteur->value.bool_val = 0;
                    else if(!strcmp(val, "true"))
                        compteur->value.bool_val = 1;
                    else
                        printf("%s is not boolean\n", val);
                    break;
            }
            return compteur;
            }
            compteur = compteur->next;
        }
        c = c->parent;
    }
    printf("%s is not declared\n", name);
    return NULL;
}

variable* lookup(char *name){
    if(pile == NULL)
        return NULL;
    Scope *c = pile;
    while(c){
        variable *compteur = c->entries;
        while(compteur){
            if(!strcmp(compteur->name, name))
                return compteur;
            compteur = compteur->next;
        }
        c = c->parent;
    }
    return NULL;
}


// FONCTIONS DE TEST

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