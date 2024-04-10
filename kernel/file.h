#include "types.h"
struct devsw {
    int (* read) (int, uint64, int);
    int (* write) (int, uint64, int);
};

extern struct devsw devsw[];

#define CONSOLE 1