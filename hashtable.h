#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX 150
#define CHLEN 20

typedef struct Entite
{
	char name[CHLEN];
	char type[CHLEN];
	int  sizeE;
	char state[CHLEN];
	int pos;
 	struct Entite* nxt;
} Entite;



int search(struct Entite** head,char str[CHLEN]){
	struct Entite* ptr ;
	ptr= *head;
	if(ptr!=NULL){
		while ((ptr != NULL)&&(strcmp(ptr->name,str)!=0)){ptr = ptr->nxt;}
		if(ptr==NULL) return 0;
		else return 1 ;
}
	return 0 ;
}

void insert(struct Entite** head,char ent_name[CHLEN], char ent_type[CHLEN],int ent_size ,char ent_state,int position){

		struct Entite* parc;
		parc = *head;
		struct Entite* ptr ;
		ptr=NULL;
		if(parc !=NULL){
			while((*parc).nxt!=NULL) {parc=(*parc).nxt;}
			ptr=malloc(sizeof(struct Entite));
			strcpy(ptr->name,ent_name);
			strcpy(ptr->type,ent_type);
			ptr->size =ent_size;
			strcpy(ptr->state,ent_state);
			ptr->pos= position;
			ptr->nxt = NULL;
			(*parc).nxt= ptr;
		}else{
			*head = malloc(sizeof(struct Entite));
			strcpy((**head).name,ent_name);
			strcpy((**head).type,ent_type);
			(**head).size =ent_size;
			strcpy((**head).state,ent_state);
			(**head).pos= position;
			(**head).nxt = NULL;
			
		}
	
}
void showTab(struct Entite** head){
	struct Entite* parc;
	parc = *head;
	FILE* file = NULL;
	char type[CHLEN]; char vc[CHLEN];
	file=fopen("Table_symbole","w+");
	fprintf(file, "_________________________________________________________________________________________________________________________________\n");
	fprintf(file,"|			IDENTIFIANT			|			TYPE 			|			TAILLE 				|			NATURE |\n");	
	if(FILE==NULL){
		printf("Failler : \n");
	else{
		while(parc!=NULL){
			if(strcmp((*parc).type,"int")==0) strcpy(type,"Entier");
			if(strcmp((*parc).state,"VAR")==0) strcpy(vc,"Variable");
			fprintf(file,"_________________________________________________________________________________________________________________________________\n");
			fprintf(file,"|	%s   						| %s      					| %d     					|  %s 				  |\n",(*parc).name,type,(*parc).size,vc);
		}
		fprintf(file, "_________________________________________________________________________________________________________________________________\n");
		fclose(file)
	}
	}
}

int searchE(struct Entite** head,char ename[12]){
	struct Entite* flow;
	flow = *head;
	if(flow!=NULL){ 
	 	while(flow!=NULL && strcmp((*flow).name,ename)!=0){
	 		flow=(*flow).SVT;
	  	}
	  	if(flow==NULL) return 0;
	  	else return 1; 
	}
	return 0;
}

char* getType(struct Entite** head, char nameE[CHLEN]){
	struct Enitite *flow;
	flow = *head;
	if(flow!=NULL){
		if(strcmp((*flow).nameE,name)==0){
			return (*flow).type;
		}
		else{
			flow=(*flow).nxt;
		}
	}
	return "";
}
char* getState(struct Entite** head, char nameE[CHLEN]){
	struct Enitite *flow;
	flow = *head;
	if(flow!=NULL){
		if(strcmp((*flow).nameE,name)==0){
			return (*flow).state;
		}
		else{
			flow=(*flow).nxt;
		}
	}
	return "";
}

int getSize(struct Entite** head, char nameE[CHLEN]){
	struct Enitite *flow;
	flow = *head;
	if(flow!=NULL){
		if(strcmp((*flow).nameE,name)==0){
			return (*flow).sizeE;
		}
		else{
			flow=(*flow).nxt;
		}
	}
	return 0;
}


int verif_ind(int lvl,int col,int type,char* clause,int len){
    // type 1 pour le if clause et 2 pour les inst
    if(type == 1){
        // if clause
        // +3 pour le if
        if(tab_len*lvl+len != col){
            printf("expected %s on colonne %i not on colonne %i \n",clause,tab_len*lvl,col-len);
            yyerror("erreur semantique indentation \n");
        }
    }else{
        //inst on met lvl + 1 pour que l'inst soit après le if
        //printf("%i - %i != %i ",tab_len*(lvl+1),(len+1),col);
        if(tab_len*(lvl+1) + (len+1) != col){
            printf("expected instruction on colonne %i not on colonne %i \n",tab_len*(lvl+1),col-len-1);
            yyerror("erreur semantique indentation \n");
        }
    }
}