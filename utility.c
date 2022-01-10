#include"utility.h"
char *copystr(char *str){
    int size = strlen(str);
    char *newstr = (char*)malloc(sizeof(char)*size);
    strcpy(newstr, str);
    return newstr;
}
