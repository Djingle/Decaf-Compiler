#include "intermediate_code.h"

Liste crelist(quad adresse){
    Liste liste;
    liste.first = adresse;
    liste.last = adresse;
    liste.size = 1;
    return liste;
}

Liste concat(Liste l1, Liste l2){
    Liste liste;
    liste.first = l1.first;
    liste.last = l1.last;
    liste.last->next = l2.first;
    liste.last = l2.last;
    liste.size = l1.size + l2.size;
    return liste;
}
void complete(Liste l,quad adresse){

}
void gencode(){

}
void newtemp(){
    
}
