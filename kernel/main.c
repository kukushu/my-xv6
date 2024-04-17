#include "include/riscv.h"
#include "include/defs.h"


volatile static int started = 0;

void main () {
    consoleinit();
    printfinit();
    trapinithart();
    //printf("a");
	while (1);
}
