
//tabulation size
int tab_len = 4;
char* msg;
int yyerror (char*);

void dec (char * el)
{
    int index;
    elem * adr;
    int b = recherche(el,&index,&adr);
    if (b==0){
            yyerror("erreur semantique IDF non declare \n");
    }
}

void doubleDec (char* el)
{
    int index;
    elem * adr;
    int b = recherche(el,&index,&adr);
    if (b==1){
            yyerror("erreur semantique double declaration d'un IDF \n");
    }

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