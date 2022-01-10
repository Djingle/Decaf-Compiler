#include "intermediate_code.h"
#include "symbols_table_var.h"

Quadop createQuadop(enum quadop_type type,u value){
    Quadop q = (Quadop)malloc(sizeof(quadop));
    q->type = type;
    q->value = value;
    return q;
}
Quadruplet createQuad(){
    Quadruplet q = (Quadruplet)malloc(sizeof(quad));
    q->type = 0;
    q->op1 = NULL;
    q->op2 = NULL;
    q->op3 = NULL;
    return q;
}

void fillQuad(Quadruplet q, quad_type type, Quadop op1, Quadop op2, Quadop op3)
{
    q->type = type;
    q->op1 = op1;
    q->op2 = op2;
    q->op3 = op3;
}

Lquad l_init() {return NULL;}

Lquad l_create(Quadruplet adresse){
    Lquad new = (Lquad)malloc(sizeof(lquad));
    if (new == NULL) {printf("malloc failed\n"); exit(EXIT_FAILURE);}
    new->q = adresse;
    new->next = NULL;
    return new;
}

int l_size(Lquad l)
{
    if (l==NULL) return 0;
    int size = 0;
    Lquad save = l;
    while (save!= NULL) {
        size++;
        save = save->next;
    }
    return size;
}

Lquad l_push(Lquad liste,Quadruplet adresse){
    Lquad new = (Lquad)malloc(sizeof(lquad));
    new->q = adresse;
    if(liste == NULL) new->next = NULL;
    else new->next = liste;
    return new;
}

Lquad l_concat(Lquad liste1, Lquad liste2){
    if (liste1 == NULL) return liste2;
    if (liste2 == NULL) return liste1;
    Lquad save = liste1;
    for (int i=0; i<l_size(liste1); i++) {
        save = save->next;
    }
    save->next = liste2;
    return liste1;
}

int l_place(Lquad liste, Quadruplet q)
{
    int place = l_size(liste)-1;
    Lquad save = liste;
    for (int i = 0; i<l_size(liste); i++) {
        if (q == save->q) return place;
        place --;
        save = save->next;
    }
    return -1;
}

void l_print(Lquad liste){
    if(liste == NULL){printf("Liste vide\n");}
    else {
        Lquad save = liste;
        int c=l_size(liste)-1;
        for (int i=0; i<l_size(liste); i++) {
            printf("%d: ", c);
            printQuad(save->q, liste);
            save = save->next;
            c--;
        }
    }
    printf("\n");
}

void printQuad(Quadruplet q, Lquad l)
{
    quad_type type = q->type;
    switch(type) {
        case Q_GOTO:
            printf("Q_GOTO: ");
            if (q->op1->value.adresse_goto==NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op1->value.adresse_goto));
            break;
        case Q_LE:
            printf("Q_LE: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_LT:
            printf("Q_LT: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_EQ:
            printf("Q_EQ: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_NE:
            printf("Q_NE: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_GE:
            printf("Q_GE: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_GT:
            printf("Q_GT: %d, %d, ", q->op1->value.cst, q->op2->value.cst);
            if (q->op3->value.adresse_goto == NULL) printf("NULL\n");
            else printf("%d\n", l_place(l, q->op3->value.adresse_goto));
            break;
        case Q_ADD: printf("Q_ADD: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->value.cst);break;
        case Q_SUB: printf("Q_SUB: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->value.cst); break;
        case Q_MUL: printf("Q_MUL: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->value.cst); break;
        case Q_DIV: printf("Q_DIV: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->value.cst); break;
        case Q_MOD: printf("Q_MOD: %d %d %d\n", q->op1->value.cst, q->op2->value.cst, q->op3->value.cst); break;
        case Q_ASSIGN: printf("Q_ASSIGN: %d %d \n", q->op1->value.cst, q->op2->value.cst); break;
        case Q_ALLOC: printf("Q_ALLOC: %d NULL NULL\n", q->op1->value.cst); break;
        case Q_ASSIGN_TEMP_ID: printf("Q_ASSIGN_TEMP_ID: %d %d NULL\n", q->op1->value.cst, q->op2->value.cst); break;
        case Q_ASSIGN_TEMP_VAL: printf("Q_ASSIGN_TEMP_VAL: %d %d NULL\n", q->op1->value.cst, q->op2->value.cst); break;
    }
}
Lquad l_complete(Lquad l,Quadruplet adresse){
    if (adresse == NULL) printf("NULL l_complete\n");
    // printf("lgr liste: ");
    // printf("%d\n",l->size);
    int compteur;
    Lquad save = l;
    int c = 0;
    for (int i=0; i<l_size(l); i++){
        quad_type type = save->q->type;
        // printf("::%d:: %d\n", c, type);
        switch(type){
            case Q_GOTO:
                if (save->q->op1->value.adresse_goto==NULL) {
                    save->q->op1->value.adresse_goto = adresse;
                }
                break;
            case Q_EQ: case Q_NE: case Q_LT: case Q_GT: case Q_LE: case Q_GE:
                if (save->q->op3->value.adresse_goto==NULL) {
                    save->q->op3->value.adresse_goto = adresse;
                }
                break;
            default :
                printf("%d : cannot l_complete\n",save->q->type);
                break;
        }
        save = save->next;
        c++;
    }
    return l;
}

Lquad reverse(Lquad l){
    Lquad rev = NULL;
    while(l){
        Lquad temp = (Lquad)malloc(sizeof(Lquad));
        temp->next = rev;
        temp->q = l->q;
        rev = temp;
        temp = l;
        l = l->next;
        free(temp);
    }
    return rev;
}

void l_translate(Lquad l, FILE* out)
{
    l = reverse(l);
    Lquad save = l;
    quad_type type = save->q->type;
    int tempsize = 0, varsize = 0;
    int nblock = 0;
   
    while (save != NULL)
    {   
        switch(save->q->type){
            case Q_ASSIGN_TEMP_ID:
            case Q_ASSIGN_TEMP_VAL:
                tempsize += 4;
                break;
            case Q_ALLOC:
                varsize += 4;
                break;
        }
        save = save->next;
    }
    fprintf(out, ".data\n");
    fprintf(out, "var: .space %d\n", varsize);
    fprintf(out, "temp: .space %d\n", tempsize);

    fprintf(out, ".text\n");
    save = l;
    while (save != NULL)
    {
        fprintf(out, "block%d:\n", nblock);
        switch(save->q->type){
            case Q_ASSIGN_TEMP_ID:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  lw $t1, var($t1)\n");
                fprintf(out, "  sw $t1, temp($t0)\n");
                break;
            case Q_ASSIGN_TEMP_VAL:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  sw $t1, temp($t0)\n");                
                break;
            case Q_ASSIGN:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  lw $t1, temp($t1)\n");
                fprintf(out, "  sw $t1, var($t0)\n");
                break;
            case Q_ADD:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  li $t3, %d\n", save->q->op3->value.cst);
                fprintf(out, "  lw $t0, temp($t0)\n");
                fprintf(out, "  lw $t1, temp($t1)\n");
                fprintf(out, "  add $t2, $t0, $t1\n");
                fprintf(out, " sw $t2, temp($t3)\n");
                break;
            case Q_SUB:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  li $t3, %d\n", save->q->op3->value.cst);
                fprintf(out, "  lw $t0, temp($t0)\n");
                fprintf(out, "  lw $t1, temp($t1)\n");
                fprintf(out, "  sub $t2, $t0, $t1\n");
                fprintf(out, "  sw $t2, temp($t3)\n");
                break;
            case Q_MUL:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  li $t3, %d\n", save->q->op3->value.cst);
                fprintf(out, "  lw $t0, temp($t0)\n");
                fprintf(out, "  lw $t1, temp($t1)\n");
                fprintf(out, "  mul $t2, $t0, $t1\n");
                fprintf(out, "  sw $t2, temp($t3)\n");
                break;
            case Q_DIV:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  li $t3, %d\n", save->q->op3->value.cst);
                fprintf(out, "  lw $t0, temp($t0)\n");
                fprintf(out, "  lw $t1, temp($t1)\n");
                fprintf(out, "  div $t2, $t0, $t1\n");
                fprintf(out, "  sw $t2, temp($t3)\n");
                break;
            case Q_EQ:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  beq, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_GE:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  bge, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_GT:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  bgt, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_LE:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  ble, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_LT:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  blt, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_NE:
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  li $t1, %d\n", save->q->op2->value.cst);
                fprintf(out, "  bne, $t1, $t0, block%d\n", l_place(l,save->q->op3->value.adresse_goto)); 
                break;
            case Q_READ:
                fprintf(out, "  li $v0, 5\n");
                fprintf(out, "  syscall\n");
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  sw $v0, var($t0)\n");
                break;
            case Q_WRITEINT:
                fprintf(out, "  li $v0, 1\n");
                fprintf(out, "  li $t0, %d\n", save->q->op1->value.cst);
                fprintf(out, "  lw $a0, temp($t0)\n");
                fprintf(out, "  syscall\n");
                break;
            // case Q_WRITESTRING:
            //     fprintf(out, "li $v0, 4\n");
            //     fprintf(out, "la $a0, %s\n", save->q->op1->value.string);
            //     fprintf(out, "syscall\n");
            //     break;
            // case Q_WRITEBOOL:
            //     fprintf(out, "  li $v0, 4\n");
            //     if(save->q->op1->value.cst == 1)
            //         fprintf(out, "  la $a0, true\n");
            //     else
            //         fprintf(out, "  la $a0, false\n");
            //     fprintf(out, "  syscall\n");
            //     break;
        }
        nblock++;
        save = save->next;
    }
    /*
    exit:
        li  $v0, 10
        syscall
    */
    fprintf(out, "exit:\n  li  $v0, 10\n  syscall\n");
}
// temp: 40  
// variable: 80
