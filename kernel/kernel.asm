
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00002117          	auipc	sp,0x2
    80000004:	41010113          	addi	sp,sp,1040 # 80002410 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	562000ef          	jal	80000578 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <r_tp>:

// read and write tp, the thread pointer, which xv6 uses to hold
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec22                	sd	s0,24(sp)
    80000020:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000022:	8792                	mv	a5,tp
    80000024:	fef43423          	sd	a5,-24(s0)
  return x;
    80000028:	fe843783          	ld	a5,-24(s0)
}
    8000002c:	853e                	mv	a0,a5
    8000002e:	6462                	ld	s0,24(sp)
    80000030:	6105                	addi	sp,sp,32
    80000032:	8082                	ret

0000000080000034 <cpuid>:

struct cpu cpus[NCPU];

int
cpuid()
{
    80000034:	1101                	addi	sp,sp,-32
    80000036:	ec06                	sd	ra,24(sp)
    80000038:	e822                	sd	s0,16(sp)
    8000003a:	1000                	addi	s0,sp,32
  int id = r_tp();
    8000003c:	00000097          	auipc	ra,0x0
    80000040:	fe0080e7          	jalr	-32(ra) # 8000001c <r_tp>
    80000044:	87aa                	mv	a5,a0
    80000046:	fef42623          	sw	a5,-20(s0)
  return id;
    8000004a:	fec42783          	lw	a5,-20(s0)
}
    8000004e:	853e                	mv	a0,a5
    80000050:	60e2                	ld	ra,24(sp)
    80000052:	6442                	ld	s0,16(sp)
    80000054:	6105                	addi	sp,sp,32
    80000056:	8082                	ret

0000000080000058 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000058:	1101                	addi	sp,sp,-32
    8000005a:	ec06                	sd	ra,24(sp)
    8000005c:	e822                	sd	s0,16(sp)
    8000005e:	1000                	addi	s0,sp,32
  int id = cpuid();
    80000060:	00000097          	auipc	ra,0x0
    80000064:	fd4080e7          	jalr	-44(ra) # 80000034 <cpuid>
    80000068:	87aa                	mv	a5,a0
    8000006a:	fef42623          	sw	a5,-20(s0)
  struct cpu *c = &cpus[id];
    8000006e:	fec42783          	lw	a5,-20(s0)
    80000072:	00779713          	slli	a4,a5,0x7
    80000076:	00002797          	auipc	a5,0x2
    8000007a:	f8a78793          	addi	a5,a5,-118 # 80002000 <cpus>
    8000007e:	97ba                	add	a5,a5,a4
    80000080:	fef43023          	sd	a5,-32(s0)
  return c;
    80000084:	fe043783          	ld	a5,-32(s0)
}
    80000088:	853e                	mv	a0,a5
    8000008a:	60e2                	ld	ra,24(sp)
    8000008c:	6442                	ld	s0,16(sp)
    8000008e:	6105                	addi	sp,sp,32
    80000090:	8082                	ret

0000000080000092 <r_sstatus>:
{
    80000092:	1101                	addi	sp,sp,-32
    80000094:	ec22                	sd	s0,24(sp)
    80000096:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000098:	100027f3          	csrr	a5,sstatus
    8000009c:	fef43423          	sd	a5,-24(s0)
  return x;
    800000a0:	fe843783          	ld	a5,-24(s0)
}
    800000a4:	853e                	mv	a0,a5
    800000a6:	6462                	ld	s0,24(sp)
    800000a8:	6105                	addi	sp,sp,32
    800000aa:	8082                	ret

00000000800000ac <w_sstatus>:
{
    800000ac:	1101                	addi	sp,sp,-32
    800000ae:	ec22                	sd	s0,24(sp)
    800000b0:	1000                	addi	s0,sp,32
    800000b2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800000b6:	fe843783          	ld	a5,-24(s0)
    800000ba:	10079073          	csrw	sstatus,a5
}
    800000be:	0001                	nop
    800000c0:	6462                	ld	s0,24(sp)
    800000c2:	6105                	addi	sp,sp,32
    800000c4:	8082                	ret

00000000800000c6 <intr_on>:
{
    800000c6:	1141                	addi	sp,sp,-16
    800000c8:	e406                	sd	ra,8(sp)
    800000ca:	e022                	sd	s0,0(sp)
    800000cc:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800000ce:	00000097          	auipc	ra,0x0
    800000d2:	fc4080e7          	jalr	-60(ra) # 80000092 <r_sstatus>
    800000d6:	87aa                	mv	a5,a0
    800000d8:	0027e793          	ori	a5,a5,2
    800000dc:	853e                	mv	a0,a5
    800000de:	00000097          	auipc	ra,0x0
    800000e2:	fce080e7          	jalr	-50(ra) # 800000ac <w_sstatus>
}
    800000e6:	0001                	nop
    800000e8:	60a2                	ld	ra,8(sp)
    800000ea:	6402                	ld	s0,0(sp)
    800000ec:	0141                	addi	sp,sp,16
    800000ee:	8082                	ret

00000000800000f0 <intr_off>:
{
    800000f0:	1141                	addi	sp,sp,-16
    800000f2:	e406                	sd	ra,8(sp)
    800000f4:	e022                	sd	s0,0(sp)
    800000f6:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800000f8:	00000097          	auipc	ra,0x0
    800000fc:	f9a080e7          	jalr	-102(ra) # 80000092 <r_sstatus>
    80000100:	87aa                	mv	a5,a0
    80000102:	9bf5                	andi	a5,a5,-3
    80000104:	853e                	mv	a0,a5
    80000106:	00000097          	auipc	ra,0x0
    8000010a:	fa6080e7          	jalr	-90(ra) # 800000ac <w_sstatus>
}
    8000010e:	0001                	nop
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <intr_get>:
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80000120:	00000097          	auipc	ra,0x0
    80000124:	f72080e7          	jalr	-142(ra) # 80000092 <r_sstatus>
    80000128:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    8000012c:	fe843783          	ld	a5,-24(s0)
    80000130:	8b89                	andi	a5,a5,2
    80000132:	00f037b3          	snez	a5,a5
    80000136:	0ff7f793          	zext.b	a5,a5
    8000013a:	2781                	sext.w	a5,a5
}
    8000013c:	853e                	mv	a0,a5
    8000013e:	60e2                	ld	ra,24(sp)
    80000140:	6442                	ld	s0,16(sp)
    80000142:	6105                	addi	sp,sp,32
    80000144:	8082                	ret

0000000080000146 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000146:	1101                	addi	sp,sp,-32
    80000148:	ec22                	sd	s0,24(sp)
    8000014a:	1000                	addi	s0,sp,32
    8000014c:	fea43423          	sd	a0,-24(s0)
    80000150:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    80000154:	fe843783          	ld	a5,-24(s0)
    80000158:	fe043703          	ld	a4,-32(s0)
    8000015c:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    8000015e:	fe843783          	ld	a5,-24(s0)
    80000162:	0007a023          	sw	zero,0(a5)
  lk->cpu = 0;
    80000166:	fe843783          	ld	a5,-24(s0)
    8000016a:	0007b823          	sd	zero,16(a5)
}
    8000016e:	0001                	nop
    80000170:	6462                	ld	s0,24(sp)
    80000172:	6105                	addi	sp,sp,32
    80000174:	8082                	ret

0000000080000176 <acquire>:

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
    80000176:	1101                	addi	sp,sp,-32
    80000178:	ec06                	sd	ra,24(sp)
    8000017a:	e822                	sd	s0,16(sp)
    8000017c:	1000                	addi	s0,sp,32
    8000017e:	fea43423          	sd	a0,-24(s0)
  push_off(); // disable interrupts to avoid deadlock.
    80000182:	00000097          	auipc	ra,0x0
    80000186:	0d4080e7          	jalr	212(ra) # 80000256 <push_off>
  if(holding(lk))
    8000018a:	fe843503          	ld	a0,-24(s0)
    8000018e:	00000097          	auipc	ra,0x0
    80000192:	084080e7          	jalr	132(ra) # 80000212 <holding>
    80000196:	87aa                	mv	a5,a0
    80000198:	cb99                	beqz	a5,800001ae <acquire+0x38>

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000019a:	0001                	nop
    8000019c:	fe843783          	ld	a5,-24(s0)
    800001a0:	4705                	li	a4,1
    800001a2:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    800001a6:	86ba                	mv	a3,a4
    800001a8:	0006879b          	sext.w	a5,a3
    800001ac:	fbe5                	bnez	a5,8000019c <acquire+0x26>

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    800001ae:	0ff0000f          	fence

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
    800001b2:	00000097          	auipc	ra,0x0
    800001b6:	ea6080e7          	jalr	-346(ra) # 80000058 <mycpu>
    800001ba:	872a                	mv	a4,a0
    800001bc:	fe843783          	ld	a5,-24(s0)
    800001c0:	eb98                	sd	a4,16(a5)
}
    800001c2:	0001                	nop
    800001c4:	60e2                	ld	ra,24(sp)
    800001c6:	6442                	ld	s0,16(sp)
    800001c8:	6105                	addi	sp,sp,32
    800001ca:	8082                	ret

00000000800001cc <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
    800001cc:	1101                	addi	sp,sp,-32
    800001ce:	ec06                	sd	ra,24(sp)
    800001d0:	e822                	sd	s0,16(sp)
    800001d2:	1000                	addi	s0,sp,32
    800001d4:	fea43423          	sd	a0,-24(s0)
  if(!holding(lk))
    800001d8:	fe843503          	ld	a0,-24(s0)
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	036080e7          	jalr	54(ra) # 80000212 <holding>
    800001e4:	87aa                	mv	a5,a0
    800001e6:	e789                	bnez	a5,800001f0 <release+0x24>

  lk->cpu = 0;
    800001e8:	fe843783          	ld	a5,-24(s0)
    800001ec:	0007b823          	sd	zero,16(a5)
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    800001f0:	0ff0000f          	fence
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);
    800001f4:	fe843783          	ld	a5,-24(s0)
    800001f8:	0f50000f          	fence	iorw,ow
    800001fc:	0807a02f          	amoswap.w	zero,zero,(a5)

  pop_off();
    80000200:	00000097          	auipc	ra,0x0
    80000204:	0ae080e7          	jalr	174(ra) # 800002ae <pop_off>
}
    80000208:	0001                	nop
    8000020a:	60e2                	ld	ra,24(sp)
    8000020c:	6442                	ld	s0,16(sp)
    8000020e:	6105                	addi	sp,sp,32
    80000210:	8082                	ret

0000000080000212 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
    80000212:	7139                	addi	sp,sp,-64
    80000214:	fc06                	sd	ra,56(sp)
    80000216:	f822                	sd	s0,48(sp)
    80000218:	f426                	sd	s1,40(sp)
    8000021a:	0080                	addi	s0,sp,64
    8000021c:	fca43423          	sd	a0,-56(s0)
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000220:	fc843783          	ld	a5,-56(s0)
    80000224:	439c                	lw	a5,0(a5)
    80000226:	cf89                	beqz	a5,80000240 <holding+0x2e>
    80000228:	fc843783          	ld	a5,-56(s0)
    8000022c:	6b84                	ld	s1,16(a5)
    8000022e:	00000097          	auipc	ra,0x0
    80000232:	e2a080e7          	jalr	-470(ra) # 80000058 <mycpu>
    80000236:	87aa                	mv	a5,a0
    80000238:	00f49463          	bne	s1,a5,80000240 <holding+0x2e>
    8000023c:	4785                	li	a5,1
    8000023e:	a011                	j	80000242 <holding+0x30>
    80000240:	4781                	li	a5,0
    80000242:	fcf42e23          	sw	a5,-36(s0)
  return r;
    80000246:	fdc42783          	lw	a5,-36(s0)
}
    8000024a:	853e                	mv	a0,a5
    8000024c:	70e2                	ld	ra,56(sp)
    8000024e:	7442                	ld	s0,48(sp)
    80000250:	74a2                	ld	s1,40(sp)
    80000252:	6121                	addi	sp,sp,64
    80000254:	8082                	ret

0000000080000256 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000256:	1101                	addi	sp,sp,-32
    80000258:	ec06                	sd	ra,24(sp)
    8000025a:	e822                	sd	s0,16(sp)
    8000025c:	1000                	addi	s0,sp,32
  int old = intr_get();
    8000025e:	00000097          	auipc	ra,0x0
    80000262:	eba080e7          	jalr	-326(ra) # 80000118 <intr_get>
    80000266:	87aa                	mv	a5,a0
    80000268:	fef42623          	sw	a5,-20(s0)

  intr_off();
    8000026c:	00000097          	auipc	ra,0x0
    80000270:	e84080e7          	jalr	-380(ra) # 800000f0 <intr_off>
  if(mycpu()->noff == 0)
    80000274:	00000097          	auipc	ra,0x0
    80000278:	de4080e7          	jalr	-540(ra) # 80000058 <mycpu>
    8000027c:	87aa                	mv	a5,a0
    8000027e:	5fbc                	lw	a5,120(a5)
    80000280:	eb89                	bnez	a5,80000292 <push_off+0x3c>
    mycpu()->intena = old;
    80000282:	00000097          	auipc	ra,0x0
    80000286:	dd6080e7          	jalr	-554(ra) # 80000058 <mycpu>
    8000028a:	872a                	mv	a4,a0
    8000028c:	fec42783          	lw	a5,-20(s0)
    80000290:	df7c                	sw	a5,124(a4)
  mycpu()->noff += 1;
    80000292:	00000097          	auipc	ra,0x0
    80000296:	dc6080e7          	jalr	-570(ra) # 80000058 <mycpu>
    8000029a:	87aa                	mv	a5,a0
    8000029c:	5fb8                	lw	a4,120(a5)
    8000029e:	2705                	addiw	a4,a4,1
    800002a0:	2701                	sext.w	a4,a4
    800002a2:	dfb8                	sw	a4,120(a5)
}
    800002a4:	0001                	nop
    800002a6:	60e2                	ld	ra,24(sp)
    800002a8:	6442                	ld	s0,16(sp)
    800002aa:	6105                	addi	sp,sp,32
    800002ac:	8082                	ret

00000000800002ae <pop_off>:

void
pop_off(void)
{
    800002ae:	1101                	addi	sp,sp,-32
    800002b0:	ec06                	sd	ra,24(sp)
    800002b2:	e822                	sd	s0,16(sp)
    800002b4:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	da2080e7          	jalr	-606(ra) # 80000058 <mycpu>
    800002be:	fea43423          	sd	a0,-24(s0)
  if(intr_get())
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	e56080e7          	jalr	-426(ra) # 80000118 <intr_get>
    800002ca:	87aa                	mv	a5,a0
    800002cc:	cf99                	beqz	a5,800002ea <pop_off+0x3c>
  if(c->noff < 1)
    800002ce:	fe843783          	ld	a5,-24(s0)
    800002d2:	5fbc                	lw	a5,120(a5)
    800002d4:	00f04b63          	bgtz	a5,800002ea <pop_off+0x3c>
  c->noff -= 1;
    800002d8:	fe843783          	ld	a5,-24(s0)
    800002dc:	5fbc                	lw	a5,120(a5)
    800002de:	37fd                	addiw	a5,a5,-1
    800002e0:	0007871b          	sext.w	a4,a5
    800002e4:	fe843783          	ld	a5,-24(s0)
    800002e8:	dfb8                	sw	a4,120(a5)
  if(c->noff == 0 && c->intena)
    800002ea:	fe843783          	ld	a5,-24(s0)
    800002ee:	5fbc                	lw	a5,120(a5)
    800002f0:	eb89                	bnez	a5,80000302 <pop_off+0x54>
    800002f2:	fe843783          	ld	a5,-24(s0)
    800002f6:	5ffc                	lw	a5,124(a5)
    800002f8:	c789                	beqz	a5,80000302 <pop_off+0x54>
    intr_on();
    800002fa:	00000097          	auipc	ra,0x0
    800002fe:	dcc080e7          	jalr	-564(ra) # 800000c6 <intr_on>
}
    80000302:	0001                	nop
    80000304:	60e2                	ld	ra,24(sp)
    80000306:	6442                	ld	s0,16(sp)
    80000308:	6105                	addi	sp,sp,32
    8000030a:	8082                	ret

000000008000030c <main>:
#include "defs.h"


volatile static int started = 0;

void main () {
    8000030c:	1141                	addi	sp,sp,-16
    8000030e:	e422                	sd	s0,8(sp)
    80000310:	0800                	addi	s0,sp,16


}
    80000312:	0001                	nop
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
    8000031a:	0000                	unimp
    8000031c:	0000                	unimp
	...

0000000080000320 <kernelvec>:
    80000320:	7111                	addi	sp,sp,-256
    80000322:	e006                	sd	ra,0(sp)
    80000324:	e40a                	sd	sp,8(sp)
    80000326:	e80e                	sd	gp,16(sp)
    80000328:	ec12                	sd	tp,24(sp)
    8000032a:	f016                	sd	t0,32(sp)
    8000032c:	f41a                	sd	t1,40(sp)
    8000032e:	f81e                	sd	t2,48(sp)
    80000330:	fc22                	sd	s0,56(sp)
    80000332:	e0a6                	sd	s1,64(sp)
    80000334:	e4aa                	sd	a0,72(sp)
    80000336:	e8ae                	sd	a1,80(sp)
    80000338:	ecb2                	sd	a2,88(sp)
    8000033a:	f0b6                	sd	a3,96(sp)
    8000033c:	f4ba                	sd	a4,104(sp)
    8000033e:	f8be                	sd	a5,112(sp)
    80000340:	fcc2                	sd	a6,120(sp)
    80000342:	e146                	sd	a7,128(sp)
    80000344:	e54a                	sd	s2,136(sp)
    80000346:	e94e                	sd	s3,144(sp)
    80000348:	ed52                	sd	s4,152(sp)
    8000034a:	f156                	sd	s5,160(sp)
    8000034c:	f55a                	sd	s6,168(sp)
    8000034e:	f95e                	sd	s7,176(sp)
    80000350:	fd62                	sd	s8,184(sp)
    80000352:	e1e6                	sd	s9,192(sp)
    80000354:	e5ea                	sd	s10,200(sp)
    80000356:	e9ee                	sd	s11,208(sp)
    80000358:	edf2                	sd	t3,216(sp)
    8000035a:	f1f6                	sd	t4,224(sp)
    8000035c:	f5fa                	sd	t5,232(sp)
    8000035e:	f9fe                	sd	t6,240(sp)
    80000360:	3d2000ef          	jal	80000732 <kerneltrap>
    80000364:	6082                	ld	ra,0(sp)
    80000366:	6122                	ld	sp,8(sp)
    80000368:	61c2                	ld	gp,16(sp)
    8000036a:	7282                	ld	t0,32(sp)
    8000036c:	7322                	ld	t1,40(sp)
    8000036e:	73c2                	ld	t2,48(sp)
    80000370:	7462                	ld	s0,56(sp)
    80000372:	6486                	ld	s1,64(sp)
    80000374:	6526                	ld	a0,72(sp)
    80000376:	65c6                	ld	a1,80(sp)
    80000378:	6666                	ld	a2,88(sp)
    8000037a:	7686                	ld	a3,96(sp)
    8000037c:	7726                	ld	a4,104(sp)
    8000037e:	77c6                	ld	a5,112(sp)
    80000380:	7866                	ld	a6,120(sp)
    80000382:	688a                	ld	a7,128(sp)
    80000384:	692a                	ld	s2,136(sp)
    80000386:	69ca                	ld	s3,144(sp)
    80000388:	6a6a                	ld	s4,152(sp)
    8000038a:	7a8a                	ld	s5,160(sp)
    8000038c:	7b2a                	ld	s6,168(sp)
    8000038e:	7bca                	ld	s7,176(sp)
    80000390:	7c6a                	ld	s8,184(sp)
    80000392:	6c8e                	ld	s9,192(sp)
    80000394:	6d2e                	ld	s10,200(sp)
    80000396:	6dce                	ld	s11,208(sp)
    80000398:	6e6e                	ld	t3,216(sp)
    8000039a:	7e8e                	ld	t4,224(sp)
    8000039c:	7f2e                	ld	t5,232(sp)
    8000039e:	7fce                	ld	t6,240(sp)
    800003a0:	6111                	addi	sp,sp,256
    800003a2:	10200073          	sret
    800003a6:	00000013          	nop
    800003aa:	00000013          	nop
    800003ae:	0001                	nop

00000000800003b0 <timervec>:
    800003b0:	34051573          	csrrw	a0,mscratch,a0
    800003b4:	e10c                	sd	a1,0(a0)
    800003b6:	e510                	sd	a2,8(a0)
    800003b8:	e914                	sd	a3,16(a0)
    800003ba:	6d0c                	ld	a1,24(a0)
    800003bc:	7110                	ld	a2,32(a0)
    800003be:	6194                	ld	a3,0(a1)
    800003c0:	96b2                	add	a3,a3,a2
    800003c2:	e194                	sd	a3,0(a1)
    800003c4:	4589                	li	a1,2
    800003c6:	14459073          	csrw	sip,a1
    800003ca:	6914                	ld	a3,16(a0)
    800003cc:	6510                	ld	a2,8(a0)
    800003ce:	610c                	ld	a1,0(a0)
    800003d0:	34051573          	csrrw	a0,mscratch,a0
    800003d4:	30200073          	mret
	...

00000000800003da <r_mhartid>:
{
    800003da:	1101                	addi	sp,sp,-32
    800003dc:	ec22                	sd	s0,24(sp)
    800003de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800003e0:	f14027f3          	csrr	a5,mhartid
    800003e4:	fef43423          	sd	a5,-24(s0)
  return x;
    800003e8:	fe843783          	ld	a5,-24(s0)
}
    800003ec:	853e                	mv	a0,a5
    800003ee:	6462                	ld	s0,24(sp)
    800003f0:	6105                	addi	sp,sp,32
    800003f2:	8082                	ret

00000000800003f4 <r_mstatus>:
{
    800003f4:	1101                	addi	sp,sp,-32
    800003f6:	ec22                	sd	s0,24(sp)
    800003f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800003fa:	300027f3          	csrr	a5,mstatus
    800003fe:	fef43423          	sd	a5,-24(s0)
  return x;
    80000402:	fe843783          	ld	a5,-24(s0)
}
    80000406:	853e                	mv	a0,a5
    80000408:	6462                	ld	s0,24(sp)
    8000040a:	6105                	addi	sp,sp,32
    8000040c:	8082                	ret

000000008000040e <w_mstatus>:
{
    8000040e:	1101                	addi	sp,sp,-32
    80000410:	ec22                	sd	s0,24(sp)
    80000412:	1000                	addi	s0,sp,32
    80000414:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000418:	fe843783          	ld	a5,-24(s0)
    8000041c:	30079073          	csrw	mstatus,a5
}
    80000420:	0001                	nop
    80000422:	6462                	ld	s0,24(sp)
    80000424:	6105                	addi	sp,sp,32
    80000426:	8082                	ret

0000000080000428 <w_mepc>:
{
    80000428:	1101                	addi	sp,sp,-32
    8000042a:	ec22                	sd	s0,24(sp)
    8000042c:	1000                	addi	s0,sp,32
    8000042e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000432:	fe843783          	ld	a5,-24(s0)
    80000436:	34179073          	csrw	mepc,a5
}
    8000043a:	0001                	nop
    8000043c:	6462                	ld	s0,24(sp)
    8000043e:	6105                	addi	sp,sp,32
    80000440:	8082                	ret

0000000080000442 <r_sie>:
{
    80000442:	1101                	addi	sp,sp,-32
    80000444:	ec22                	sd	s0,24(sp)
    80000446:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000448:	104027f3          	csrr	a5,sie
    8000044c:	fef43423          	sd	a5,-24(s0)
  return x;
    80000450:	fe843783          	ld	a5,-24(s0)
}
    80000454:	853e                	mv	a0,a5
    80000456:	6462                	ld	s0,24(sp)
    80000458:	6105                	addi	sp,sp,32
    8000045a:	8082                	ret

000000008000045c <w_sie>:
{
    8000045c:	1101                	addi	sp,sp,-32
    8000045e:	ec22                	sd	s0,24(sp)
    80000460:	1000                	addi	s0,sp,32
    80000462:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    80000466:	fe843783          	ld	a5,-24(s0)
    8000046a:	10479073          	csrw	sie,a5
}
    8000046e:	0001                	nop
    80000470:	6462                	ld	s0,24(sp)
    80000472:	6105                	addi	sp,sp,32
    80000474:	8082                	ret

0000000080000476 <r_mie>:
{
    80000476:	1101                	addi	sp,sp,-32
    80000478:	ec22                	sd	s0,24(sp)
    8000047a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000047c:	304027f3          	csrr	a5,mie
    80000480:	fef43423          	sd	a5,-24(s0)
  return x;
    80000484:	fe843783          	ld	a5,-24(s0)
}
    80000488:	853e                	mv	a0,a5
    8000048a:	6462                	ld	s0,24(sp)
    8000048c:	6105                	addi	sp,sp,32
    8000048e:	8082                	ret

0000000080000490 <w_mie>:
{
    80000490:	1101                	addi	sp,sp,-32
    80000492:	ec22                	sd	s0,24(sp)
    80000494:	1000                	addi	s0,sp,32
    80000496:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mie, %0" : : "r" (x));
    8000049a:	fe843783          	ld	a5,-24(s0)
    8000049e:	30479073          	csrw	mie,a5
}
    800004a2:	0001                	nop
    800004a4:	6462                	ld	s0,24(sp)
    800004a6:	6105                	addi	sp,sp,32
    800004a8:	8082                	ret

00000000800004aa <w_medeleg>:
{
    800004aa:	1101                	addi	sp,sp,-32
    800004ac:	ec22                	sd	s0,24(sp)
    800004ae:	1000                	addi	s0,sp,32
    800004b0:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800004b4:	fe843783          	ld	a5,-24(s0)
    800004b8:	30279073          	csrw	medeleg,a5
}
    800004bc:	0001                	nop
    800004be:	6462                	ld	s0,24(sp)
    800004c0:	6105                	addi	sp,sp,32
    800004c2:	8082                	ret

00000000800004c4 <w_mideleg>:
{
    800004c4:	1101                	addi	sp,sp,-32
    800004c6:	ec22                	sd	s0,24(sp)
    800004c8:	1000                	addi	s0,sp,32
    800004ca:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800004ce:	fe843783          	ld	a5,-24(s0)
    800004d2:	30379073          	csrw	mideleg,a5
}
    800004d6:	0001                	nop
    800004d8:	6462                	ld	s0,24(sp)
    800004da:	6105                	addi	sp,sp,32
    800004dc:	8082                	ret

00000000800004de <w_mtvec>:
{
    800004de:	1101                	addi	sp,sp,-32
    800004e0:	ec22                	sd	s0,24(sp)
    800004e2:	1000                	addi	s0,sp,32
    800004e4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800004e8:	fe843783          	ld	a5,-24(s0)
    800004ec:	30579073          	csrw	mtvec,a5
}
    800004f0:	0001                	nop
    800004f2:	6462                	ld	s0,24(sp)
    800004f4:	6105                	addi	sp,sp,32
    800004f6:	8082                	ret

00000000800004f8 <w_pmpcfg0>:
{
    800004f8:	1101                	addi	sp,sp,-32
    800004fa:	ec22                	sd	s0,24(sp)
    800004fc:	1000                	addi	s0,sp,32
    800004fe:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000502:	fe843783          	ld	a5,-24(s0)
    80000506:	3a079073          	csrw	pmpcfg0,a5
}
    8000050a:	0001                	nop
    8000050c:	6462                	ld	s0,24(sp)
    8000050e:	6105                	addi	sp,sp,32
    80000510:	8082                	ret

0000000080000512 <w_pmpaddr0>:
{
    80000512:	1101                	addi	sp,sp,-32
    80000514:	ec22                	sd	s0,24(sp)
    80000516:	1000                	addi	s0,sp,32
    80000518:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000051c:	fe843783          	ld	a5,-24(s0)
    80000520:	3b079073          	csrw	pmpaddr0,a5
}
    80000524:	0001                	nop
    80000526:	6462                	ld	s0,24(sp)
    80000528:	6105                	addi	sp,sp,32
    8000052a:	8082                	ret

000000008000052c <w_satp>:
{
    8000052c:	1101                	addi	sp,sp,-32
    8000052e:	ec22                	sd	s0,24(sp)
    80000530:	1000                	addi	s0,sp,32
    80000532:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80000536:	fe843783          	ld	a5,-24(s0)
    8000053a:	18079073          	csrw	satp,a5
}
    8000053e:	0001                	nop
    80000540:	6462                	ld	s0,24(sp)
    80000542:	6105                	addi	sp,sp,32
    80000544:	8082                	ret

0000000080000546 <w_mscratch>:
{
    80000546:	1101                	addi	sp,sp,-32
    80000548:	ec22                	sd	s0,24(sp)
    8000054a:	1000                	addi	s0,sp,32
    8000054c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000550:	fe843783          	ld	a5,-24(s0)
    80000554:	34079073          	csrw	mscratch,a5
}
    80000558:	0001                	nop
    8000055a:	6462                	ld	s0,24(sp)
    8000055c:	6105                	addi	sp,sp,32
    8000055e:	8082                	ret

0000000080000560 <w_tp>:

static inline void 
w_tp(uint64 x)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec22                	sd	s0,24(sp)
    80000564:	1000                	addi	s0,sp,32
    80000566:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    8000056a:	fe843783          	ld	a5,-24(s0)
    8000056e:	823e                	mv	tp,a5
}
    80000570:	0001                	nop
    80000572:	6462                	ld	s0,24(sp)
    80000574:	6105                	addi	sp,sp,32
    80000576:	8082                	ret

0000000080000578 <start>:
uint64 timer_scratch[NCPU][5];

extern void timervec();


void start () {
    80000578:	1101                	addi	sp,sp,-32
    8000057a:	ec06                	sd	ra,24(sp)
    8000057c:	e822                	sd	s0,16(sp)
    8000057e:	1000                	addi	s0,sp,32
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    80000580:	00000097          	auipc	ra,0x0
    80000584:	e74080e7          	jalr	-396(ra) # 800003f4 <r_mstatus>
    80000588:	fea43423          	sd	a0,-24(s0)
  x &= ~MSTATUS_MPP_MASK;
    8000058c:	fe843703          	ld	a4,-24(s0)
    80000590:	77f9                	lui	a5,0xffffe
    80000592:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <timer_scratch+0xffffffff7fff43ef>
    80000596:	8ff9                	and	a5,a5,a4
    80000598:	fef43423          	sd	a5,-24(s0)
  x |= MSTATUS_MPP_S;
    8000059c:	fe843703          	ld	a4,-24(s0)
    800005a0:	6785                	lui	a5,0x1
    800005a2:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800005a6:	8fd9                	or	a5,a5,a4
    800005a8:	fef43423          	sd	a5,-24(s0)
  w_mstatus(x);
    800005ac:	fe843503          	ld	a0,-24(s0)
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	e5e080e7          	jalr	-418(ra) # 8000040e <w_mstatus>

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);
    800005b8:	00000797          	auipc	a5,0x0
    800005bc:	d5478793          	addi	a5,a5,-684 # 8000030c <main>
    800005c0:	853e                	mv	a0,a5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	e66080e7          	jalr	-410(ra) # 80000428 <w_mepc>

  // disable paging for now.
  w_satp(0);
    800005ca:	4501                	li	a0,0
    800005cc:	00000097          	auipc	ra,0x0
    800005d0:	f60080e7          	jalr	-160(ra) # 8000052c <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    800005d4:	67c1                	lui	a5,0x10
    800005d6:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    800005da:	00000097          	auipc	ra,0x0
    800005de:	ed0080e7          	jalr	-304(ra) # 800004aa <w_medeleg>
  w_mideleg(0xffff);
    800005e2:	67c1                	lui	a5,0x10
    800005e4:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	edc080e7          	jalr	-292(ra) # 800004c4 <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	e52080e7          	jalr	-430(ra) # 80000442 <r_sie>
    800005f8:	87aa                	mv	a5,a0
    800005fa:	2227e793          	ori	a5,a5,546
    800005fe:	853e                	mv	a0,a5
    80000600:	00000097          	auipc	ra,0x0
    80000604:	e5c080e7          	jalr	-420(ra) # 8000045c <w_sie>

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
    80000608:	57fd                	li	a5,-1
    8000060a:	00a7d513          	srli	a0,a5,0xa
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f04080e7          	jalr	-252(ra) # 80000512 <w_pmpaddr0>
  w_pmpcfg0(0xf);
    80000616:	453d                	li	a0,15
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	ee0080e7          	jalr	-288(ra) # 800004f8 <w_pmpcfg0>

  // ask for clock interrupts.
  timerinit();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	032080e7          	jalr	50(ra) # 80000652 <timerinit>

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	db2080e7          	jalr	-590(ra) # 800003da <r_mhartid>
    80000630:	87aa                	mv	a5,a0
    80000632:	fef42223          	sw	a5,-28(s0)
  w_tp(id);
    80000636:	fe442783          	lw	a5,-28(s0)
    8000063a:	853e                	mv	a0,a5
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	f24080e7          	jalr	-220(ra) # 80000560 <w_tp>

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    80000644:	30200073          	mret
}
    80000648:	0001                	nop
    8000064a:	60e2                	ld	ra,24(sp)
    8000064c:	6442                	ld	s0,16(sp)
    8000064e:	6105                	addi	sp,sp,32
    80000650:	8082                	ret

0000000080000652 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit () {
    80000652:	1101                	addi	sp,sp,-32
    80000654:	ec06                	sd	ra,24(sp)
    80000656:	e822                	sd	s0,16(sp)
    80000658:	1000                	addi	s0,sp,32
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	d80080e7          	jalr	-640(ra) # 800003da <r_mhartid>
    80000662:	87aa                	mv	a5,a0
    80000664:	fef42623          	sw	a5,-20(s0)

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
    80000668:	000f47b7          	lui	a5,0xf4
    8000066c:	2407879b          	addiw	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    80000670:	fef42423          	sw	a5,-24(s0)
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000674:	0200c7b7          	lui	a5,0x200c
    80000678:	17e1                	addi	a5,a5,-8 # 200bff8 <_entry-0x7dff4008>
    8000067a:	6398                	ld	a4,0(a5)
    8000067c:	fe842783          	lw	a5,-24(s0)
    80000680:	fec42683          	lw	a3,-20(s0)
    80000684:	0036969b          	slliw	a3,a3,0x3
    80000688:	2681                	sext.w	a3,a3
    8000068a:	8636                	mv	a2,a3
    8000068c:	020046b7          	lui	a3,0x2004
    80000690:	96b2                	add	a3,a3,a2
    80000692:	97ba                	add	a5,a5,a4
    80000694:	e29c                	sd	a5,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000696:	fec42703          	lw	a4,-20(s0)
    8000069a:	87ba                	mv	a5,a4
    8000069c:	078a                	slli	a5,a5,0x2
    8000069e:	97ba                	add	a5,a5,a4
    800006a0:	078e                	slli	a5,a5,0x3
    800006a2:	0000a717          	auipc	a4,0xa
    800006a6:	d6e70713          	addi	a4,a4,-658 # 8000a410 <timer_scratch>
    800006aa:	97ba                	add	a5,a5,a4
    800006ac:	fef43023          	sd	a5,-32(s0)
  scratch[3] = CLINT_MTIMECMP(id);
    800006b0:	fec42783          	lw	a5,-20(s0)
    800006b4:	0037979b          	slliw	a5,a5,0x3
    800006b8:	2781                	sext.w	a5,a5
    800006ba:	873e                	mv	a4,a5
    800006bc:	020047b7          	lui	a5,0x2004
    800006c0:	973e                	add	a4,a4,a5
    800006c2:	fe043783          	ld	a5,-32(s0)
    800006c6:	07e1                	addi	a5,a5,24 # 2004018 <_entry-0x7dffbfe8>
    800006c8:	e398                	sd	a4,0(a5)
  scratch[4] = interval;
    800006ca:	fe043783          	ld	a5,-32(s0)
    800006ce:	02078793          	addi	a5,a5,32
    800006d2:	fe842703          	lw	a4,-24(s0)
    800006d6:	e398                	sd	a4,0(a5)
  w_mscratch((uint64)scratch);
    800006d8:	fe043783          	ld	a5,-32(s0)
    800006dc:	853e                	mv	a0,a5
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	e68080e7          	jalr	-408(ra) # 80000546 <w_mscratch>

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);
    800006e6:	00000797          	auipc	a5,0x0
    800006ea:	cca78793          	addi	a5,a5,-822 # 800003b0 <timervec>
    800006ee:	853e                	mv	a0,a5
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	dee080e7          	jalr	-530(ra) # 800004de <w_mtvec>

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	cfc080e7          	jalr	-772(ra) # 800003f4 <r_mstatus>
    80000700:	87aa                	mv	a5,a0
    80000702:	0087e793          	ori	a5,a5,8
    80000706:	853e                	mv	a0,a5
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	d06080e7          	jalr	-762(ra) # 8000040e <w_mstatus>

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000710:	00000097          	auipc	ra,0x0
    80000714:	d66080e7          	jalr	-666(ra) # 80000476 <r_mie>
    80000718:	87aa                	mv	a5,a0
    8000071a:	0807e793          	ori	a5,a5,128
    8000071e:	853e                	mv	a0,a5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	d70080e7          	jalr	-656(ra) # 80000490 <w_mie>
}
    80000728:	0001                	nop
    8000072a:	60e2                	ld	ra,24(sp)
    8000072c:	6442                	ld	s0,16(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kerneltrap>:

void kerneltrap() {
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e422                	sd	s0,8(sp)
    80000736:	0800                	addi	s0,sp,16
	
}
    80000738:	0001                	nop
    8000073a:	6422                	ld	s0,8(sp)
    8000073c:	0141                	addi	sp,sp,16
    8000073e:	8082                	ret
	...

0000000080001000 <_trampoline>:
    80001000:	14051073          	csrw	sscratch,a0
    80001004:	02000537          	lui	a0,0x2000
    80001008:	fff5051b          	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000100c:	00d51513          	slli	a0,a0,0xd
    80001010:	02153423          	sd	ra,40(a0)
    80001014:	02253823          	sd	sp,48(a0)
    80001018:	02353c23          	sd	gp,56(a0)
    8000101c:	04453023          	sd	tp,64(a0)
    80001020:	04553423          	sd	t0,72(a0)
    80001024:	04653823          	sd	t1,80(a0)
    80001028:	04753c23          	sd	t2,88(a0)
    8000102c:	f120                	sd	s0,96(a0)
    8000102e:	f524                	sd	s1,104(a0)
    80001030:	fd2c                	sd	a1,120(a0)
    80001032:	e150                	sd	a2,128(a0)
    80001034:	e554                	sd	a3,136(a0)
    80001036:	e958                	sd	a4,144(a0)
    80001038:	ed5c                	sd	a5,152(a0)
    8000103a:	0b053023          	sd	a6,160(a0)
    8000103e:	0b153423          	sd	a7,168(a0)
    80001042:	0b253823          	sd	s2,176(a0)
    80001046:	0b353c23          	sd	s3,184(a0)
    8000104a:	0d453023          	sd	s4,192(a0)
    8000104e:	0d553423          	sd	s5,200(a0)
    80001052:	0d653823          	sd	s6,208(a0)
    80001056:	0d753c23          	sd	s7,216(a0)
    8000105a:	0f853023          	sd	s8,224(a0)
    8000105e:	0f953423          	sd	s9,232(a0)
    80001062:	0fa53823          	sd	s10,240(a0)
    80001066:	0fb53c23          	sd	s11,248(a0)
    8000106a:	11c53023          	sd	t3,256(a0)
    8000106e:	11d53423          	sd	t4,264(a0)
    80001072:	11e53823          	sd	t5,272(a0)
    80001076:	11f53c23          	sd	t6,280(a0)
    8000107a:	140022f3          	csrr	t0,sscratch
    8000107e:	06553823          	sd	t0,112(a0)
    80001082:	00853103          	ld	sp,8(a0)
    80001086:	02053203          	ld	tp,32(a0)
    8000108a:	01053283          	ld	t0,16(a0)
    8000108e:	00053303          	ld	t1,0(a0)
    80001092:	12000073          	sfence.vma
    80001096:	18031073          	csrw	satp,t1
    8000109a:	12000073          	sfence.vma
    8000109e:	8282                	jr	t0

00000000800010a0 <userret>:
    800010a0:	12000073          	sfence.vma
    800010a4:	18051073          	csrw	satp,a0
    800010a8:	12000073          	sfence.vma
    800010ac:	02000537          	lui	a0,0x2000
    800010b0:	fff5051b          	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800010b4:	00d51513          	slli	a0,a0,0xd
    800010b8:	02853083          	ld	ra,40(a0)
    800010bc:	03053103          	ld	sp,48(a0)
    800010c0:	03853183          	ld	gp,56(a0)
    800010c4:	04053203          	ld	tp,64(a0)
    800010c8:	04853283          	ld	t0,72(a0)
    800010cc:	05053303          	ld	t1,80(a0)
    800010d0:	05853383          	ld	t2,88(a0)
    800010d4:	7120                	ld	s0,96(a0)
    800010d6:	7524                	ld	s1,104(a0)
    800010d8:	7d2c                	ld	a1,120(a0)
    800010da:	6150                	ld	a2,128(a0)
    800010dc:	6554                	ld	a3,136(a0)
    800010de:	6958                	ld	a4,144(a0)
    800010e0:	6d5c                	ld	a5,152(a0)
    800010e2:	0a053803          	ld	a6,160(a0)
    800010e6:	0a853883          	ld	a7,168(a0)
    800010ea:	0b053903          	ld	s2,176(a0)
    800010ee:	0b853983          	ld	s3,184(a0)
    800010f2:	0c053a03          	ld	s4,192(a0)
    800010f6:	0c853a83          	ld	s5,200(a0)
    800010fa:	0d053b03          	ld	s6,208(a0)
    800010fe:	0d853b83          	ld	s7,216(a0)
    80001102:	0e053c03          	ld	s8,224(a0)
    80001106:	0e853c83          	ld	s9,232(a0)
    8000110a:	0f053d03          	ld	s10,240(a0)
    8000110e:	0f853d83          	ld	s11,248(a0)
    80001112:	10053e03          	ld	t3,256(a0)
    80001116:	10853e83          	ld	t4,264(a0)
    8000111a:	11053f03          	ld	t5,272(a0)
    8000111e:	11853f83          	ld	t6,280(a0)
    80001122:	7928                	ld	a0,112(a0)
    80001124:	10200073          	sret
	...
