#include <stdio.h>
#include <string.h>
#include "TS.h"
int yyerror (char*);

void dec (char * el)
{ int index; elem * adr; 
int b = recherche(el,&index,&adr); 
if (b==0){yyerror("erreur semantique IDF non declare \n");}

}

void doubleDec (char* el)
{ int index; elem * adr; 
int b = recherche(el,&index,&adr); 
if (b==1){yyerror("erreur semantique double declaration d'un IDF \n");}

}


