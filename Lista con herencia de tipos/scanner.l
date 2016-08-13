%option noyywrap
%{
#include "parser.h"//analisis sintactico
#include <iostream>
int columna=0;
int ids=0;
%}

letra [a-zñA-ZÑ_]
escaper ("@n"|"@t"|"@r"|"@\\")
digito [0-9]
iden {letra}+({letra}|{digito}|"_")*    

%%
[,]             { columna=columna+strlen(yylval.TEXT); strcpy(yylval.TEXT, yytext); return coma; }
[;]             { columna=columna+strlen(yylval.TEXT); strcpy(yylval.TEXT, yytext); return pcoma; }
{iden}          { columna=columna+strlen(yylval.TEXT); strcpy(yylval.TEXT, yytext); return Id; }

["\f"|"\r"|"\t"|"\v"] {columna++;}
["\n"] {ids+=columna; columna=1;yylineno++;}
[[:blank:]]     {/*ingo*/}

.  {std::cout <<yytext<<" Error Lexico,"<< " Linea   "<< yylineno<<std::endl;}
%%
