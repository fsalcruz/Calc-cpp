CC = g++
LEX = flex
YACC = yacc

AUXFLAG = -std=c++11

LFLAGS = -lfl

project: lex.yy.c y.tab.c
    $(CC) $(AUXFLAG) lex.yy.c y.tab.c -o project $(LFLAGS)

lex.yy.c: project.l
    $(LEX) -o lex.yy.c project.l

y.tab.c: project.y
    $(YACC) -d -o y.tab.c project.y

clean:
    rm -f lex.yy.c y.tab.c y.tab.h project

.PHONY: clean