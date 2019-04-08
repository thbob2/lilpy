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

void insert(char *ent_name, char *ent_code,char *ent_st ,int *ent_size,int position){
	Entite *ptr=NULL;

	if(search(ent_name,position) == 1){
		ptr=(Entite*)malloc(sizeof(Entite));
		strcpy(ptr->name,ent_name);
		strcpy(ptr->code,ent_code);
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
	printf("\n/***************Table des symboles ******************/\n");
 	printf("________________________________________________________\n");
	printf("\t|      NomEntite      | index |       CodeEntite     |\n");
	printf(" ___________________________________________________\n");
	for (int i = 0; i < MAX;i++)
	{ 
		Entite *ptr = Tabhash[i].head;
		while(ptr!=NULL){
			printf("\t|%15s| %5d |%20s  |\n",ptr->nom,i,ptr->code);
			ptr = ptr->nxt;
		}
		printf("\n");
	}
}
