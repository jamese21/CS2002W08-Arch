#include <stdio.h>
#include "badrandom.h"

int length;

void print_result(bool result, int length, int* array) { 

    if (!result) { 
        printf("Sequence too long \n");
    }
    for(int i=0; i < length; i++) { 
        printf("%d ",array[i]);
    }
    printf("\n");
}


int main(void) {

    printf("%d %d\n", MAXARRAYSIZE, INT_MAX);
    int sequence[MAXARRAYSIZE];

    print_result(badrandom(27,7351,17,1003,10,&length,sequence),length,sequence);
    print_result(badrandom(95,7351,17,1000,10,&length,sequence),length,sequence);

}

