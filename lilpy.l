%{	
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include "lilpy.tab.h"
	
	extern FILE * yyin;
	
	int NL=1,NC=1;
	
	extern YYSTYPE yylval;
%}

IDF [A-Z][A-Za-z0-9]*
int [-]?[0-9]+
float [-]?[0-9]+[/.][0-9]+

alpha [a-zA-Z]
char [^0-9]

%%

" " {NC++;}
"\t"		{NC=NC+1; return(TAB);}
"\n"		{NC=1; NL++ ;}
"def"    	{NC=NC+strln(yytext);return(DEF);}
"if"    	{NC=NC+strln(yytext); return(IF);}
"elif"  	{NC=NC+strln(yytext); return(ELIF);}
"else"  	{NC=NC+strln(yytext); return(ELSE);}
"for"		{NC=NC+strln(yytext); return(FOR);}
"while" 	{NC=NC+strln(yytext); return(WHILE);}
"in"    	{NC=NC+strln(yytext); return(IN);}
"range"		{NC=NC+strln(yytext); return(RANGE);}
"print"		{NC=NC+strln(yytext); return(PRINT);}
"=="    	{NC=NC+2; return(EQ);}
"<="    	{NC=NC+2; return(LE);}
"!="    	{NC=NC+2; return(NE);}
">"			{NC=NC+1; return(GT);}
">="    	{NC=NC+2; return(GE);}
"<"     	{NC=NC+1; return(LT);}
"="			{NC++ return(affect);}
"("			{NC++; return '(';}
")"			{NC++; return ')';}
"+" {NC++; return '+';}
"-" {NC++; return '-'; }
"*" {NC++; return '*'; }
"/" {NC++; return '/'; }
{IDF} { 
    if(strlen(yytext)>8){
    	printf("Erreur! l'identifiant %s est trop long (Taille maximum 8 caractere)\n",yytext);}										
       	NC=NC+strlen(yytext); yylval.string=strdup(yytext);return IDF;
    }
{int} {NC=NC+strlen(yytext);yylval.int=atoi(yytext); return int;}
{float} {NC=NC+strlen(yytext);yylval.float=atof(yytext); return float;}

. {printf("Erreur lexicale ligne %d colonne %d ======> %s Inconnu \n",NL,NC,yytext);}
%%
	int yywrap()
	{
	return 1;
	}
