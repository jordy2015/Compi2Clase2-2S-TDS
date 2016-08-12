%{
#include "scanner.h"//se importa el header del analisis sintactico
#include <iostream> //libreria para imprimir en cosola de C
#include <string.h>
#include <stdio.h>
#include <unistd.h>

extern int columna; //columna actual donde se encuentra el parser (analisis lexico) lo maneja BISON
extern char *yytext; //lexema actual donde esta el parser (analisis lexico) lo maneja BISON

int rand1=0;

int yyerror(const char* mens){
    std::cout <<"Error Sintactico en:" <<" "<<yytext<< " Linea: "<<yylineno<<" Columna: "<< columna<<", Informe: "<<std::endl;
    columna=0;
    return 0;
}

void Asignacio(std::string mitipo, std::string var1){
std::cout<<mitipo<<" "<<var1<<std::endl;

}
void TipoDato(std::string Tdato, std::string dato){
	std::cout<<Tdato<<" "<<dato<<std::endl;
}


struct Operador{
//ESTRUCTURA LA CUAL CONTENDRA LOS TIPOS DE LOS NO TERMINALES PA223RA HEREDAR VALORES
std::string Cadena;
std::string Tipo;
//int MiValor;
};


%}
//error-verbose si se especifica la opcion los errores sintacticos son especificados por BISON
%error-verbose
%union{
//se especifican los tipos de valores para los no terminales y lo terminales
char TEXT [256];
struct Operador * Concat;
}

%token<TEXT> Id
%token<TEXT> coma
%token<TEXT> pcoma


%type<Concat> S1
%type<Concat>  S2
%type<Concat>  S3



%%



S1 : S2 S3 pcoma{std::cout<<"aceptada"<<std::endl;};

S2 : Id {$$= new Operador(); $$->Tipo=$1;};

S3 : Id{TipoDato($<Concat>0->Tipo,$1);  sleep(5);} coma {$<Concat>$=$<Concat>0;} S3{$$=new Operador();}
	|Id{$$=new Operador();TipoDato($<Concat>0->Tipo,$1); }

%%
