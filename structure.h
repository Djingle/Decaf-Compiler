typedef struct fct Fct;
typedef struct scope Scope;
typedef struct entry Var;

Fct* listFct = NULL; 
Scope* global = NULL; 
Scope* currentScope = global; 
Var* varsInScope = NULL; 

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
