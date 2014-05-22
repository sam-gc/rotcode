#include "randgen.h"

static long _seed;

void rand_seed_generator(long seed)
{
    _seed = seed;
}

long rand_generate()
{
    long val = _seed;
    // Pseudo-pseudo random number created using line from glibc.
    val = ((_seed * 1103515245) + 12345) & 0x7fffffff;
    _seed = val;
    return val;
}
