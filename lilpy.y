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
	int int; 
	struct s {char * val; int type;} s;
}
%token <s> IDF 
%token <int> NUM 
%token IF ELIF ELSE int 

%token  '(' ')' ':'  ',' '+' '*' '-' '/' 
%token TAB
%right '='
%left '+' '-'
%left '*' '/'
%left LE GE EQ NE LT GT
%type <s> Assignment VAR Declaration inst 
%start start

%%

start: Declaration
	 | inst 
	 | Stmt
	 ;

 Stmt: Declaration
	| inst
	| IfStmt
	| PrintFunc
	;

Declaration: int IDF {if(!search(&TS,$2)) insert(&TS,$2,int,1,"VAR",NL); }
;

inst: IDF '=' Assignment { if(!search(&TS,$1)) insert(&TS,$1,int,1,"VAR",NL);
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

IfStmt: IF '(' cond ')' ':'  {/*incrémentation*/
							  nbif++;}							
		TAB Stmt 
		elifstmt
;
elifstmt: elsestmt
		| ELIF '(' cond ')' ':'/*incrementation*/
		  TAB Stmt
		  elsestmt 
;	
elsestmt: 
		| ELSE ':'/*incrementation*/
		  TAB Stmt 
;	

VAR: IDF
	|NUM
	;	

cond: VAR LE VAR { 	majq(&Q,pull(&stack),num+1);
					int x;
					x=pull(&stack);
                    char *tempc;
                    tempc=malloc(sizeof(10));
                    sprintf(tempc,"%d",x);
                    insq(&Q,"BNE",tempc,$1.val,$3.val,num);
                    majq(&Q,pull(&stack),num);
                    num++;

	}
	| VAR GE VAR {	majq(&Q,pull(&stack),num+1);
	                int x;
	                x=pull(&stack);
	                char *tempc;
	                tempc=malloc(sizeof(10));
	                sprintf(tempc,"%d",x);
	                insq(&Q,"BGE",tempc,$1.val,$3.val,num);
	                majq(&Q,pull(&stack),num);
	                num++;

	}
	| VAR NE VAR {	majq(&Q,pull(&stack),num+1);
                    int x;
                    x=pull(&stack);
                    char *tempc;
                    tempc=malloc(sizeof(10));
                    sprintf(tempc,"%d",x);
                    insq(&Q,"BNE",tempc,$1.val,$3.val,num);
                    majq(&Q,pull(&stack),num);
                    num++;

	}
	| VAR GT VAR {	majq(&Q,pull(&stack),num+1);
                    int x;
                    x=pull(&stack);
                    char *tempc;
                    tempc=malloc(sizeof(10));
                    sprintf(tempc,"%d",x);
                    insq(&Q,"BG",tempc,$1.val,$3.val,num);
                    majq(&Q,pull(&stack),num);
                    num++;

	}
	| VAR LT VAR {	majq(&Q,pull(&stack),num+1);
                    int x;
                    x=pull(&stack);
                    char *tempc;
                    tempc=malloc(sizeof(10));
                    sprintf(tempc,"%d",x);
                    insq(&Q,"BL",tempc,$1.val,$3.val,num);
                    majq(&Q,pull(&stack),num);
                    num++;

	}
	| VAR EQ VAR {	majq(&Q,pull(&stack),num+1);
                    int x;
                    x=pull(&stack);
                    char *tempc;
                    tempc=malloc(sizeof(10));
                    sprintf(tempc,"%d",x);
                    insq(&Q,"BE",tempc,$1.val,$3.val,num);
                    majq(&Q,pull(&stack),num);
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