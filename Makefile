prefixe=decaf_compiler

all: y.tab.o lex.yy.o intermediate_code.o symbols_table_var.o utility.o
	gcc y.tab.o lex.yy.o intermediate_code.o symbols_table_var.o utility.o -lfl -o $(prefixe)


y.tab.o: $(prefixe).y intermediate_code.h
	yacc -v -d $(prefixe).y
	gcc -c y.tab.c

lex.yy.o: $(prefixe).l y.tab.h
	lex $(prefixe).l
	gcc -c lex.yy.c

intermediate_code.o: intermediate_code.c intermediate_code.h
	gcc -c intermediate_code.c

symbols_table_var.o: symbols_table_var.c symbols_table_var.h
	gcc -c symbols_table_var.c
utility.o: utility.c utility.h
	gcc -c utility.c

clean:
	rm -f *.o y.tab.c y.tab.h lex.yy.c a.out y.output test $(prefixe)
