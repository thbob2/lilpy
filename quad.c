#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hashtable.h"
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
    (*flow).nxt=new_q;
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

void showq(struct QUAD** head){
	struct QUAD* flow;
	flow = *head;
	FILE* f= NULL;
	f = fopen("quadreplet.txt","w+");
	while(flow!=NULL){
		fprintf(f,"%d-(%s,%s,%s,%s)\n",(*flow).qnum,(*flow).op1,(*flow).op2,(*flow).op3,(*flow).result);
		flow = (*flow).nxt;
	}
	fclose(f);
}

void majq(struct QUAD** head, int num,int qend){
	struct QUAD* flow;
	flow = *head;
	char *string; 
	string = malloc(sizeof(10));
	while((*flow).qnum!= num){
		flow = (*flow).nxt;
	}
	sprintf(string,"%d",qend);
	strcpy((*flow).op2,string);
}

void operate(struct QUAD** head, struct Entite** tsHead){
	struct QUAD *flow = *head ;
	while(flow !=NULL){
		if(strcmp((*flow).op1,"=")==0 && strcmp((*flow).op3,"")==0 && searchE(tsHead,(*flow).result)!=0){
			struct QUAD *headon = (*flow.nxt);
			while (headon != NULL && strcmp((*headon).result, (*flow).op2) != 0 && strcmp((*headon).result, (*flow).result) != 0){
			if (strcmp((*headon).op1, "BGE") != 0 && strcmp((*headon).op1, "BLE") != 0 && strcmp((*headon).op1, "BNE") != 0 && strcmp((*headon).op1, "BG") != 0 && strcmp((*headon).op1, "BE") != 0 && strcmp((*headon).op1, "BL") != 0 && strcmp((*headon).op1, "BR") != 0){
			if (strcmp((*headon).op2, (*flow).result) == 0){
            strcpy((*headon).op2, (*flow).op2);
          }else{
            if (strcmp((*headon).op3, (*flow).result) == 0){
              strcpy((*headon).op3, (*flow).op2);
            }
          }
        }
        headon = (*headon).nxt;
      }
    }
    flow = (*flow).nxt;
  }
}