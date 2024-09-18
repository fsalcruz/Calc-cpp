# README - Projeto Linguagens de Programação e Compiladores.


## Conteúdo


Este ficheiro contém os seguintes:

- ast_calc.png 

- project.l

- project.y

- makefile

- tests (diretoria que contém os ficheiros .txt de teste, o ficheiro utilizado foi o test0.txt)


## Descrição

JP Calc is a compiler written in C++/OCaml that performs arithmetic operations with Japanese unicode characters. It also provides some algorithms and data structures frequently used in competitive programs that popular languages don't include by default.

## Execução

Para executar a calculadora, no terminal é necessário estar na diretoria deste projeto e posteriormente, poderá fazer uso do makefile existente para executar a calculadora.

```bash
$ make
```

Este comando, irá fazer os comandos necessários para compilar e executar o programa, e após terminar a sua execução normalmente (uso do token 'end' ou 'END'), este termina a execução do programa limpando ainda a diretoria de todos os ficheiros extra que foram necessários para a execução do programa. Caso o makefile, por algum motivo, não esteja a funcionar, ou queria colocar os comandos manualmente, os comandos utilizados são os seguintes.

```bash
$ yacc -d -o y.tab.c project.y
$ flex -o lex.yy.c project.l
$ g++ -std=c++11 lex.yy.c y.tab.c -o project -lfl
$ ./project
or
$ ./project < tests/test0.txt
```