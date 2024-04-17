#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
void kerneltrap (void);
void machine_vec (void);


void kerneltrap() {
  printf("kerneltrap");
}

void machine_vec () {
  printf("machine_vec\n");
}

