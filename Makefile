prefixe=decaf_compiler

all: y.tab.o lex.yy.o
	gcc y.tab.o lex.yy.o -lfl -o $(prefixe)

y.tab.o: $(prefixe).y
	yacc -d $(prefixe).y
	gcc -c y.tab.c

lex.yy.o: $(prefixe).l y.tab.h
	lex $(prefixe).l
	gcc -c lex.yy.c

clean:
	rm -f *.o y.tab.c y.tab.h lex.yy.c a.out $(prefixe)
