#include "badrandom.h"

static int array_length;
static int *array;
static int mult;
static int add;
static int div;
static int min;

static bool badrandom_recurse(int current) {

    if( array_length >= MAXARRAYSIZE) {
        return false; }

    array[array_length] = current;

    array_length += 1;

    if (current < min) {
        return true; } 
     
    if (current%min == 0) {
        return badrandom_recurse((current*mult+add)%div); }
    else {
        return badrandom_recurse((current*mult-add)%div);
    }
}



bool badrandom(int start, int in_mult, int in_add, int in_div, int in_min, int *in_length, int* in_array) {

     array_length = 0;
     mult = in_mult;
     add = in_add;
     div = in_div;
     min = in_min;
     array = in_array;

     bool result = false;

     if(start >= 1) { 
         result = badrandom_recurse(start);
     }
     *in_length=array_length;
     return result;
}

     



