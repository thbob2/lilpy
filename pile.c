#include <stdio.h>
#include <stdlib.h>

typedef struct  STACK{
	int value;
	struct STACK *nxt;
};
int emptyStack(struct STACK** head){
	if(*head==NULL) return 1;
	else return 0;
}
int stackSummit(struct STACK** head) {
	if(emptyStack(head)) return -1;
	else return (**head).value;
}
void push(struct STACK** head,int val){
	if(emptyStack(head)){
		*head = malloc(sizeof(struct STACK));
		(**head).value = val;
		(**head).nxt = NULL;
	}
	else{
		struct STACK newS;
		newS = malloc(sizeof(struct STACK));
		(*newS).value = val;
		(*newS).nxt = *head;
		*head = newS;
	}
}
int pull(struct STACK** head){
	int val=-1;
	if(!emptyStack(head)){
		val = (**head).value;
		if((*head)->nxt==NULL) (*head)=NULL;
		else *head =(*head)->nxt; 
	}
	return val ;
}