%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "hashtable.h"
	#include "RS.h"
	include "quad.c"
	include "pile.c"
	int yylex();
	int yyerror(char *)
	extern FILE *yyin;
	extern FILE yyout;
	struct QUAD *Q = NULL;
	struct STACK *stack;
	struct Entite *TS;
	int num = 1 ;
	int tcond =0;
	int tifq = 0;
	int telifq =0;
	int temp = 1 ;
	int nbif = 0;
	char * tempc;
	char ConstType[10];
	char currenttype[10]="";

%}
%union{
	char* nom;
	int entier; 
	struct s {char * val; int type;} s;
}
%token <s> IDF 
%token <entier> NUM 
%token IF ELIF ELSE INT
%token  '(' ')' ':'  ',' '+' '*' '-' '/' 
%token TAB
%right '='
%left '+' '-'
%left '*' '/'
%left LE GE EQ NE LT GT
%type <s> Assignment VAR Declaration inst 
%start start

%%

start: Stmt
	 ;

 Stmt: Declaration
	| inst
	| IfStmt
	;

Declaration: INT inst {if(!search(&TS,$2)) insert(&TS,$2,INT,1,"VAR",NL); }

;

inst: IDF '=' Assignment { if(!search(&TS,$1)) insert(&TS,$1,INT,1,"VAR",NL);
						   insq(&Q,"=",$3.val,"",$1.val,num);
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
	| Assignment '-' Assignment {char* tempc = malloc(sizeof(10));
								sprintf(tempc,"T%d",temp);
								temp++;
								insq(&Q,"-",$1.val,$3.val,tempc,num);
								num++;
								strcpy($$.val,tempc);

										}
	| Assignment '*' Assignment {char* tempc = malloc(sizeof(10));
								sprintf(tempc,"T%d",temp);
								temp++;
								insq(&Q,"*",$1.val,$3.val,tempc,num);
								num++;
								strcpy($$.val,tempc);

										}
	| Assignment '/' Assignment{char* tempc = malloc(sizeof(10));
								sprintf(tempc,"T%d",temp);
								temp++;
								insq(&Q,"/",$1.val,$3.val,tempc,num);
								num++;
								strcpy($$.val,tempc);
								}
	| '(' Assignment ')' {$$.type=$2.type; $$.val=$2.val;}
	| NUM {$$.type=1; $$.val=$1;}
  	| IDF  {if(search(&TS,$1)) printf("Erreur a la ligne %d : IDF non declaré\n " ,NL); }
  	;

IfStmt: ifcond elifstmt;

ifcond: IF '(' cond ')' ':' 
		TAB Stmt 
	 {/*incrémentation*/
							  nbif++;}
;							  							

elifstmt: ELIF '(' cond ')' ':'/*incrementation*/
		  TAB Stmt
		  elsestmt 

;		|elsestmt

elsestmt: /*epcilonne*/ 
		| ELSE ':'/*incrementation*/
		  TAB Stmt 
;	

VAR: IDF
	|NUM { struct s nums= malloc(sizeof(struct s)); nums.val=$1;}
	;	

cond: VAR LE VAR {  insq(&Q,"BG","",$1.val,$3.val,num);
                    num++;

	}
	| VAR GE VAR   {insq(&Q,"BE","",$1.val,$3.val,num);
	                num++;

	}
	| VAR NE VAR {	insq(&Q,"BE","",$1.val,$3.val,num);
                    num++;

	}
	| VAR GT VAR {  insq(&Q,"BLE","",$1.val,$3.val,num);
                    num++;

	}
	| VAR LT VAR {	insq(&Q,"BGE","",$1.val,$3.val,num);
                    num++;

	}
	| VAR EQ VAR {	insq(&Q,"BNE","",$1.val,$3.val,num);
                    num++;

	}
	;

%%
int yyerror(char* msg){
	printf("%s ligne %d \n",msg,NL,NC);
	exit(0);
	return 1;
}

int main()
{
	yyin=fopen("test.txt","r");
	
	yyparse();
	showTab(&TS);
	operate(&Q,&TS);
	usless(&Q,&TS);
	showq(&Q);
	fclose(yyin);
	return 0;
}