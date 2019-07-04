%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "hashtable.h"
	
	include "quad.c"
	include "pile.c"
	int yylex();
	int yyerror(char *)
	extern FILE *yyin;
	extern int NL,NC ,len; // récupération de la taille du dernier idf 
	extern FILE yyout;
	struct QUAD *Q = NULL; //quadruplet
	struct STACK *stack; //pile
	STACK * lists [10];
	struct Entite *TS;//table symbole
	int num = 1 ;
	int temp = 1 ;
	int brtmp, if_lvl = -1;
	int elif = 0 ; // 0 if 1 elif
	char * tempc;
	char ConstType[10];
	char currenttype[10]="";
	int x;

%}
%union{
	char* nom;
	int entier; 
	struct s {char * val; int type;} s;
}
%token <nom> IDF 
%token <entier> NUM 
%token IF ELIF ELSE ENDIF INT
%token  '(' ')' ':'  ',' '+' '*' '-' '/' 
%token TAB
%right '='
%left '+' '-'
%left '*' '/'
%left LE GE EQ NE LT GT
%type <s>  VAR cond Assignment
%start start

%%

start: Declaration Stmt
	 ;

 Stmt: inst Stmt
	| IfStmt Stmt
	|
	;

Declaration: INT IDF {if(!search(&TS,$2)) insert(&TS,$2,INT,1,"VAR",NL); }

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



IfStmt: IF {if_lvl++; verif_ind(if_lvl,NC,1,"IF",3)}'(' cond ')' ':' if_inst if_rest
;							  							


if_rest:ELIF{
	verif_ind(if_lvl,NC,1,"ELIF",5); 
	lists[if_lvl] = push(&lists[if_lvl],cptquad);
	insq(&Q,"BR"," "," ","test",num);
	num++;
}'(' cond ')' ':' if_inst if_rest
	|ELSE {
		verif_ind(if_lvl,NC,1,"ELSE",5);
		lists[if_lvl] = push(&lists[if_lvl],cptquad);
		insq(&Q,"BR"," "," ","test",num);
		num++;
		tempc = malloc(sizeof(10));
		sprintf(tempc,"%i",cptquad);
		majq(&Q,pull(&stack),temp);
	} if_inst ENDIF{
		verif_ind(if_lvl,NC,1,"ENDIF",6);
		while(lists[if_lvl]!=NULL){
			x = pull(&lists[if_lvl]);
			tempc = malloc(sizeof(10));
			majq(&Q,x,tempc);
		}
		if_lvl--;
	}
	|ENDIF {
		verif_ind(if_lvl,NC,1,"ENDIF",6);
		if_lvl--;
	}
;
	

if_inst: {verif_ind(if_lvl,NC,2,"",len)} Assignment if_inst
	| IfStmt
	|
	;

VAR: IDF {if(search(&TS,$1)) printf("erreur sémantique idf non déclarer")}
	|NUM { $$.type=1; $$.val=$1;}
	;	

cond: VAR LE VAR {  
					insq(&Q,"BG","",$1.val,$3.val,num);
					push(&stack,num);
                    num++;
                    if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
	}
	| VAR GE VAR   {insq(&Q,"BE","",$1.val,$3.val,num);
	                push(&stack,num);
	                num++;
	                if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
	}
	| VAR NE VAR {	insq(&Q,"BE","",$1.val,$3.val,num);
                    push(&stack,num);
                    num++;
                    if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
	}
	| VAR GT VAR {  insq(&Q,"BLE","",$1.val,$3.val,num);
                    push(&stack,num);
                    num++;
					if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
	}
	| VAR LT VAR {	insq(&Q,"BGE","",$1.val,$3.val,num);
                    push(&stack,num);
                    num++;
					if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
	}
	| VAR EQ VAR {	insq(&Q,"BNE","",$1.val,$3.val,num);
                    push(&stack,num);
                    num++;
                    if(elif==0){
                    	head = push(&stack,cptquad);
                    	insq(&Q,"BR","","","vide",num);
                    	num++;
                    }else{
                    	x = pull(&stack);
                    	tempc = malloc(sizeof(10));
                    	sprintf(tempc,"%i",cptquad);
                    	majq(&Q,x,tempc);
                    }
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
	//operate(&Q,&TS);
	//usless(&Q,&TS);
	showq(&Q);
	fclose(yyin);
	return 0;
}