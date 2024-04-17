#include "include/spinlock.h"
#include "include/riscv.h"
#include "include/defs.h"


#define BACKSPACE 0x100
#define C(x) ((x)-'@')



struct {
    struct spinlock lock;
#define INPUT_BUF_SIZE 128
    char buf[INPUT_BUF_SIZE];
    uint r;
    uint w;
    uint e;
} cons;

void
consputc(int c)
{
  if(c == BACKSPACE){
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
  } else {
    uartputc_sync(c);
  }
}



void consoleinit (void) {
    initlock(&cons.lock, "cons");
    uartinit();
 
}