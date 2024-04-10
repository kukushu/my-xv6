#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"


volatile static int started = 0;

void main () {
    consoleinit();
    printfinit();
    printf("a");
	while (1);
}
