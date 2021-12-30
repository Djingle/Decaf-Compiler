prefixe=decaf_compiler

all: y.tab.o lex.yy.o intermediate_code.o
	gcc y.tab.o lex.yy.o intermediate_code.o -lfl -o $(prefixe)


y.tab.o: $(prefixe).y intermediate_code.h
	yacc -v -d $(prefixe).y
	gcc -c y.tab.c

lex.yy.o: $(prefixe).l y.tab.h
	lex $(prefixe).l
	gcc -c lex.yy.c

test: intermediate_code.h
	gcc intermediate_code.c -o test 

clean:
	rm -f *.o y.tab.c y.tab.h lex.yy.c a.out y.output test $(prefixe)
