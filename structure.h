
typedef struct fct Fct;
typedef struct scope Scope;
typedef struct entry Var;


typedef struct fct{
    char name[32];
    struct Scope *scope;
    struct fct *next;
} Fct;

typedef struct scope{
    Var *entries;
    struct scope *parent;
} Scope;

typedef struct entry{
    char* type;
    char name[32];
    union operand_val {
        int ival;
        float fval;
        int bool_val;
    } value;
    struct entry *next;  
} Var;


Fct newFct(char* name);
Fct newScope();
void putVar(char* type, char* name);
void setVar(char* name, char* value);
void pushVar(char* name);
void putVars(char* type);
void incrementVar(char* name, char* value);
void decrementVar(char* name, char* value);
void newVariable(char *name, char *type);
void TwonewVariable(char *name1, char*name2 , char *type);
void printVar(Var var);
void printAllVars();