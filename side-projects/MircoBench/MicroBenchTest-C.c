#include <time.h>
#include <math.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

//variables for clock time
clock_t start, end;

//Setup node structure 
typedef struct node {
  char* val;
  struct node * next;
}node;



char cTest[1000];


//copy strings into node recursively 
void recurse (struct node* n)
{
   
   //base case: empty list
   if(n->next == NULL)
   {  
      return;
   }
   else
   {
   //move through the list   
   strcpy(cTest, n->val);
   n = n->next;
   //Get next string
   printf("%s\n\n",cTest);  
   recurse(n);
   }
   
} 


int main(void)
{
    /* This will be the unchanging first node */      
    char s1[10] = "this ";
    char s2[10] = "is ";
    char s3[10] = "a ";
    char s4[10] = "linked ";
    char s5[10] = "list ";
   
    struct node* root = malloc(sizeof(root));
    struct node* n1 = malloc(sizeof(n1));
    struct node* n2 = malloc(sizeof(n2));
    struct node* n3 = malloc(sizeof(n3));
    struct node* n4 = malloc(sizeof(n4));
    struct node* n5 = malloc(sizeof(n5));
    
    /* root connects all values of s1 - s5 */
    root->val = s1;
    root->next = n1;
	
    n1->val = s2;
    n1->next = n2;
	
    n2->val = s3;
    n2->next = n3;
	
    n3->val = s4;
    n3->next = n4;
	
    n4->val = s5;
    n4->next = n5;
	
    n5->next = NULL;
    
         
   //timer on
   start = clock();
    {
      int i = 0;
      while(i<1000000)
      {
      i++;
	  printf("count = ", i);
      recurse(root);
      }
    }
	
    //timer off
    end = clock();
    double time_used = (double)(end - start)/(CLOCKS_PER_SEC * 1000000);
    printf("time elapsed: %f ms", difftime(end,start)); 
    return 0; 
}