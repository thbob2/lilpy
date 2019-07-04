#define taille 100
typedef struct elt{
				char* nom;
				int type;
				struct elt* svt;
				}elem;
elem * TS[taille];
void init ();
int Fhach (char* );
int recherche (char * , int*, elem **);
void inserer (char*,int );
int typeIdf(char*);
void afficherTS ();

