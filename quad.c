#include <stdio.h>
#include <stdlib.h>
#include <string.h>
define chlen 10;
typedef struct QUAD{
	char op1[chlen];
	char op2[chlen];
	char op3[chlen];
	char result[chlen];
	int qnum;
	struct QUAD* nxt;

};

void insq(struct QUAD** head,char o1[chlen],char o2[chlen],char o3[chlen],char r[chlen],int n){
	struct QUAD* flow;
	flow = *head;
	struct QUAD* new_q;
	new_q = NULL;
	if(flow!=NULL){
		while((*flow).nxt!=NULL){
			flow=(*flow).nxt;

		}
	
	new_q = malloc(sizeof(stuct QUAD));
	strcpy((*new_q).op1,o1);
    strcpy((*new_q).op2,o2);
    strcpy((*new_q).op3,o3); 
    strcpy((*new_q).result,r);
    (*new_q).qnum=n;
    (*new_q).nxt=NULL;
    (*Parcourir).nxt=new_q;
  }else{
    *head=malloc(sizeof(struct QUAD));
    strcpy((**head).op1,o1);
    strcpy((**head).op2,o2);
    strcpy((**head).op3,o3); 
    strcpy((**head).result,r);
    (**head).qnum=n;
    (**head).nxt=NULL;
  }
}