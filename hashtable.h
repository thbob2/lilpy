#include <stdio.h>
#include <string.h>
#define MAX 150
#define CHLEN 20

typedef struct hashtab
{
		Entite * head;
		Entite * tail;

}hashtab;

hashtab Tabhash[MAX];

typedef struct Entite
{
	char name[CHLEN];
	char code[CHLEN];
	char state[CHLEN];
	char type[CHLEN];
	int  sizeE;
 	struct Entite *nxt;
} Entite;

int hashing(char *str){

	int hashNumber = 0; 
	for (int i = 0; str[i]!='\0';i++)	
	{
		hashNumber +=str[i];
	}
	hashNumber %= MAX;
	return hashNumber;
}

int search(char *str, int position){
	int exist = 0;
	int pos = 0; 
	Entite *ptr =Tabhash[position].head;
	while ((ptr != NULL)&&(exist==0)){
		if(strcmp(ptr->name,str)==0){
			exist = 1;
		}
		else ptr = ptr->nxt;
		pos++;
	}
	if (exist) return pos;
	else return -1;
}

void insert(char *ent_name, char *ent_code,char *ent_st ,char *ent_type,int *ent_size,int position){
	
	Entite *ptr=NULL;
	if(search(ent_name,position) == 1){
		ptr=(Entite*)malloc(sizeof(Entite));
		strcpy(ptr->name,ent_name);
		strcpy(ptr->code,ent_code);
		strcpy(ptr->type,ent_type);
		strcpy(ptr->state,ent_st);
		ptr->size =ent_size;
		ptr->nxt = NULL;
		// dans le cas où c'est le premier élément à etre insérer
		if(Tabhash[position].head == NULL){
			Tabhash[position].head = ptr;
			Tabhash[position].tail = ptr;
		}
		else{
			(Tabhash[position].tail->nxt) = ptr;
			Tabhash[position].tail = ptr;
		}
	}
}
void showTab(){
	//printf("\n/--------------Table des symboles ------------------/\n");
 	printf("_________________________________________________________________________________________________________________\n");
	printf("\t|      Nom Entite      | index |   Code Entite  |   Etat Entite   |     Type Entite     |    Taille Entite     |\n");
	printf(" _______________________________________________________________________________________________________________\n");
	for (int i = 0; i < MAX;i++)
	{ 
		Entite *ptr = Tabhash[i].head;
		while(ptr!=NULL){
			printf("\t|%15s| %5d | %20s | %20s | %20s | %5d  |\n",ptr->name,i,ptr->code,ptr->state,ptr->type,ptr->sizeE);
			ptr = ptr->nxt;
		}
		printf("\n");
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

