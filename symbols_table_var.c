#include "symbols_table_var.h"
#include <string.h>
tempvar *templist = NULL; 
Scope *pile = NULL;
int current = 0; // current est la derniere adresse utilisee
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
    printf("attempting newVar with %s\n",type);
    if(!pile)
        pushctx();
    tempvar *temp = templist;
   
    while(temp){    
        variable *v = pile->entries;
        while(v){
            if(!strcmp(v->name, temp->name)){
                printf("%s is already declared\n",v->name);
                return;
            }
            v = v->next;
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
        newEntree->adresse = current;  // current est la derniere adresse utilisee
        current += 4;   
        newEntree->type = temp_type;
        pile->entries = newEntree;
        temp = temp->next;
    }
    
    clearListVar();
}


/*
variable *setVal(char *name, char* val){
    printf("attempting setVal with name = \"%s\" and val = \"%s\" ", name, val);
    if(pile == NULL)
        return NULL;
    Scope *c = pile;
    while(c){
        variable *compteur = c->entries;
        while(compteur){
        if(!strcmp(compteur->name, name)){
            compteur->adresse = current;  // current est la derniere adresse utilisee (a definir en glbal)
            current += 4;         
            return compteur;
            }
            compteur = compteur->next;
        }
        c = c->parent;
    }
    printf("%s is not declared\n", name);
    return NULL;
}*/

int getAdrr(char *name){
    printf("attempting to get adresse of name = \"%s\" ", name);
    if(pile == NULL)
        return -1;
    Scope *c = pile;
    while(c){
        variable *compteur = c->entries;
        while(compteur){
        if(!strcmp(compteur->name, name))
            return compteur->adresse;  
        compteur = compteur->next;
        }
        c = c->parent;
    }
    printf("getVal(): %s is not declared\n", name);
    return -1;
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
    printf("%s a l'adresse %d\n", var.name, var.adresse);
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
//UTILITY

char* convertIntegerToChar(int n)
{
 
    printf("\nconverting %d to char *\n", n);
    int m = n;
    int digit = 0;
    while (m) {
        digit++;
        m /= 10;
    }
    char* arr; 
    char arr1[digit];
    arr = (char*)malloc(digit);
    int index = 0;
    while (n) {
        arr1[++index] = n % 10 + '0'; 
        n /= 10;
    }
    int i;
    for (i = 0; i < index; i++) {
        arr[i] = arr1[index - i];
    }
    arr[i] = '\0';
    return (char*)arr;
}


int main(){
    newVariable("temp", "int");
    newVariable("temp10", "int");

    //setVal("temp1", "0");
    //setVal("temp", "13");
    pushctx();
    printf("\ntemp10 getAdrr() %d\n", getAdrr("temp10"));
    newVariable("temp10", "bool");
    //setAdrgetAdrr("temp10", "false");
    TwonewVariable("temp2", "temp3", "int");
    //setAdrgetAdrr("temp2", "25");
    //setAdrgetAdrr("temp3", "13");
    newVariable("tempdff", "float");
    printf("\ntemp111 getAdrr() %d\n", getAdrr("temp111"));
    printAllVars();
    return 1;
}
