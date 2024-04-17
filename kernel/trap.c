#include "include/riscv.h"
#include "include/defs.h"


extern void kernelvec (void);
void kerneltrap (void);
void machine_vec (void);

void trapinithart (void) {
  w_stvec((uint64)kernelvec);
}

void kerneltrap() {
  printf("kerneltrap");
}

void machine_vec () {
  printf("machine_vec\n");
}

