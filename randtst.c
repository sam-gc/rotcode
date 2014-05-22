#include <stdlib.h>
#include <stdio.h>
#include "randgen.h"

int main(int argc, char *argv[])
{
    rand_seed_generator(5);
    srand(5);

    int i;
    for(i = 0; i < 100; i++)
    {
        long a = rand() % 13;
        long b = rand_generate() % 13;

        printf("%ld\t%ld\n", a, b);
    }

    return 0;
}