%{	
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include "lilpy.tab.h"
	
	extern FILE * yyin;
	
	int NL=1,NC=1;
	
	extern YYSTYPE yylval;
%}
IDF [A-Z][A-Za-z]*
NUM[-]?[0-9]+
alpha [a-zA-Z]
TAB ("\t")+
SPACE(" ")+
%%
"int"		{NC += yyleng; yyval.nom = strdup(yytext); return(int);}
"if"    	{NC=NC+strln(yytext); return(IF);}
"elif"  	{NC=NC+strln(yytext); return(ELIF);}
"print"		{NC=NC+strln(yytext); return(PRINT);}
"=="    	{NC=NC+2; return(EQ);}
"<="    	{NC=NC+2; return(LE);}
"!="    	{NC=NC+2; return(NE);}
">"			{NC=NC+1; return(GT);}
">="    	{NC=NC+2; return(GE);}
"<"     	{NC=NC+1; return(LT);}
"="			{NC++; return '=';}
"("			{NC++; return '(';}
")"			{NC++; return ')';}
"+" 		{NC++; return '+';}
"-" 		{NC++; return '-'; }
"*" 		{NC++; return '*'; }
"/" 		{NC++; return '/'; }
{IDF} { 
    if(strlen(yytext)>18){printf("Erreur! l'identifiant %s est trop long (Taille maximum 8 caractere)\n",yytext);}
       	NC=NC+strlen(yytext); 
       	yylval.nom=strdup(yytext);
       	return(IDF);
    }
{NUM} {NC=NC+strlen(yytext); 
		yylval.nom = strdup(yytext); 
		return NUM;}
{jumpl}	{NC=1; NL+=yyleng ;}
{TAB} {NC+=yyleng; printf("----- tab len %i ------ \n",yyleng)}
{SPACE} {NC+=yyleng;}
. {printf("Erreur lexicale ligne %d colonne %d ======> %s Inconnu \n",NL,NC,yytext);}
%%
	int yywrap()
	{
	return 1;
	}
