%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "TS.h"
	#include "RS.h"
	include "quad.c"
	int yylex();
	int yyerror(char *)
	extern FILE *yyin;
	extern FILE yyout;

	struct QUAD *Q = NULL;
	int num = 1;
	int temp = 1;
	char * tempc;
	char ConstType[10];
	char currenttype[10]="";

%}
%union{
	char* nom;
	int int; 
	struct s {char * val; int type;} s;
}
%token  '(' ')' ':'  ',' '+' '*' '-' '/' 
%token IF ELIF ELSE PRINT int
%token TAB
%token <nom> IDF
%token <int> NUM

%right '='
%left '+' '-'
%left '*' '/'
%left LE GE EQ NE LT GT
%type <s> Assignment
%start start

%%

start: Declaration inst ;

Declaration: int IDF { doubleDec($2); inserer(strdup($2),1);

}
;

inst: IDF '=' Assignment { insq(&Q,"=",$3.val,"",$1.val,num);
						 num++;
						}
	;


Assignment: Assignment '+' Assignment { char* tempc = malloc(sizeof(10));
										sprintf(tempc,"T%d",temp);
										temp++;
										insq(&Q,"+",$1.val,$3.val,tempc,num);
										num++
										strcpy($$.val,tempc);
									  }
			| Assignment '-' Assignment {	char* tempc = malloc(sizeof(10));
											sprintf(tempc,"T%d",temp);
											temp++;
											insq(&Q,"-",$1.val,$3.val,tempc,num);
											num++;
											strcpy($$.val,tempc);

										}
			| Assignment '*' Assignment {	char* tempc = malloc(sizeof(10));
											sprintf(tempc,"T%d",temp);
											temp++;
											insq(&Q,"*",$1.val,$3.val,tempc,num);
											num++;
											strcpy($$.val,tempc);

										}
	    	| Assignment '/' Assignment{	char* tempc = malloc(sizeof(10));
											sprintf(tempc,"T%d",temp);
											temp++;
											insq(&Q,"/",$1.val,$3.val,tempc,num);
											num++;
											strcpy($$.val,tempc);

										}
	    	| '(' Assignment ')' {$$.type=$2.type; $$.val=$2.val;}
			| NUM {$$.type=1; $$.val=$1;}
		  	| IDF  {dec($1);$$type=typeÎdf($1); $$.val=strdup($1);}
		  	;
/*
CompoundSt: TAB StmtList
	;

StmtList: StmtList Stmt
	;

Stmt: Declaration inst
	| inst
	| IfStmt
	| PrintFunc
	;

IfStmt: IF '(' Expr ')' ':'
		TAB Stmt
	
	|	IF '('Expr ')' ':'
		TAB stmt
		ELSE:
		TAB stmt
	|	IF '('Expr')' ':'
		TAB stmt	
		ELIF '('Expr ')' ':'
		ELSE:
		TAB stmt
	;

PrintFunc: PRINT '(' IDF ')' 
	| PRINT '(' NUM ')'
	;

Expr:
	| Expr LE Expr
	| Expr GE Expr
	| Expr NE Expr
	| Expr GT Expr
	| Expr LT Expr
	| Expr EQ Expr
	;
	*/
%%
#include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{

	yyin=fopen("test.txt","r");
	init ();
	yyparse();
	
	afficherTS();
	operate(&Q,&TS);

	showq(&Q);
	
	
	return 0;
	
	/*if(yyparse()==1)
		printf("\nParsing failed\n");
	   else
		printf("\nParsing completed successfully\n");
	   fclose(yyin);
	return 0;*/

}
int yyerror(char* msg){
	printf("Erreur syntaxique a la ligne %d colonne %d\n",NL,NC);
	return 1;
}