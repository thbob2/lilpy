#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "TS.h"


void init ()
{ int i;
for (i=0;i<taille;i++)
TS[i]=NULL;
}

int Fhach (char* e)
{int i=0, count=0; 
while(e[i]!='\0')
{count+=e[i]*i*(10*(i+1));i++;
} 
return (count%taille);
} 

int recherche (char * el, int* index, elem** adr)
{elem* p;
*index = Fhach(el);
p=TS[*index]; *adr =p;
if (p==NULL) return 0;
if (!strcmp(p->nom,el)) return 1;
p=p->svt;
	while (p!=NULL && strcmp(p->nom,el)) p=p->svt;
	*adr =p;
if (p==NULL) return 0;
return 1;
}

void inserer (char* el,int type)
{int index; elem* p; elem* adr;
index= Fhach(el);
p= malloc(sizeof(elem));
p->nom=el; p->type=type;
if (TS[index]==NULL) {p->svt=NULL; TS[index]=p;}
else {p->svt=TS[index]; TS[index]=p;}

}

/*
void inserer (char* el,int type)
{int index; elem* p; elem* adr;
int b= recherche(el,&index,&adr);
if (b==0)
p= malloc(sizeof(elem));
p->nom=el; p->type=type;
if (TS[index]==NULL) {p->svt=NULL; TS[index]=p;}
else {p->svt=TS[index]; TS[index]=p;}

}*/

int typeIdf(char* el)
{ int index; elem * adr; 
recherche(el,&index,&adr); 
return (adr->type);
}

void afficherTS ()
{
int i=0; elem*p;
for (i=0;i<taille;i++)
{if (TS[i]!=NULL){p=TS[i]; 
				  while(p!=NULL) {printf ("%s ---> %d\n",p->nom,p->type);
									p=p->svt;
								 }
				 }
}
				  
}

