#include "regs.h"
#include "interrupts.h"
#include "ucos/includes.h"

extern INTERRUPT_VECTOR g_VectorTable[BCM2835_INTC_TOTAL_IRQ];

static void tickISR()
{
	OSTimeTick();

	timerRegs->CLI = 0;
}

void timer_init( void )
{

	DisableInterrupt(64);

	g_VectorTable[64].pfnHandler=tickISR;

	timerRegs->CTL = 0x003E0000;
	timerRegs->LOD = 1000000/OS_TICKS_PER_SEC - 1;
	timerRegs->RLD = 1000000/OS_TICKS_PER_SEC - 1;
	timerRegs->DIV = 0xF9;
	timerRegs->CLI = 0;
	timerRegs->CTL = 0x003E00A2;

	EnableInterrupt(64);
}

