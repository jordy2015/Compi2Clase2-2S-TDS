%{
#include "scanner.h"//se importa el header del analisis sintactico
#include <iostream> //libreria para imprimir en cosola de C
#include <string.h>
#include <stdio.h>
#include <unistd.h>

extern int columna; //columna actual donde se encuentra el parser (analisis lexico) lo maneja BISON
extern char *yytext; //lexema actual donde esta el parser (analisis lexico) lo maneja BISON

int yyerror(const char* mens){
    std::cout <<"Error Sintactico en:" <<" "<<yytext<< " Linea: "<<yylineno<<" Columna: "<< columna<<", Informe: "<<std::endl;
    columna=0;
    return 0;
}

struct Operador{
//ESTRUCTURA LA CUAL CONTENDRA LOS TIPOS DE LOS NO TERMINALES 
int heredada;
int MiValor;
};


%}
//error-verbose si se especifica la opcion los errores sintacticos son especificados por BISON
%error-verbose

%union{
//se especifican los tipos de valores para los no terminales y lo terminales
char TEXT [256];
struct Operador * Concat;
}



//TERMINALES DE TIPO TEXT, SON STRINGS
%token<TEXT> mas
%token<TEXT> menos
%token<TEXT> por
%token<TEXT> numero
%token<TEXT> divi
%token<TEXT> Id


//NO TERMINALES 
%type<Concat> S
%type<Concat> E
%type<Concat>  T
%type<Concat> E_p
%type<Concat>  T_p
%type<Concat> F

//Asociatividad Sin ella causa que el algoritmo LALR lance conflictos de reduccion y desplazamiento
%left mas menos 
%left por

%%

S : E { std::cout<<$1->MiValor<<std::endl;};

E : T {$<Concat>0=new Operador(); $<Concat>0->heredada=$1->MiValor;} 
		E_p {$$=new Operador(); $$->MiValor=$<Concat>3->MiValor;}

E_p : mas T {$<Concat>1=new Operador(); $<Concat>1->heredada=$<Concat>-2->heredada+$2->MiValor;} 
		E_p {$$=new Operador(); $$->MiValor=$<Concat>4->MiValor;}
	|{$$=new Operador(); $$->MiValor=$<Concat>-2->heredada;};

T : F {$<Concat>0=new Operador(); $<Concat>0->heredada=$1->MiValor;} 
		T_p {$$=new Operador(); $$->MiValor=$<Concat>3->MiValor;};

T_p : por F {$<Concat>1=new Operador(); $<Concat>1->heredada=$<Concat>-2->heredada*$2->MiValor;} 
		T_p {$$=new Operador(); $$->MiValor=$<Concat>4->MiValor;}
	|{$$=new Operador(); $$->MiValor=$<Concat>-2->heredada;};

F : numero {$$=new Operador(); $$->MiValor=atoi($1); };
%%
