#ifndef OS_CPU_H
#define OS_CPU_H



/*
*********************************************************************************************************
*                                              DATA TYPES
*                                         (Compiler Specific)
*********************************************************************************************************
*/


typedef unsigned char  BOOLEAN;                 
typedef unsigned char  INT8U;                  
typedef signed   char  INT8S;
typedef unsigned short INT16U;
typedef signed   short INT16S;
typedef unsigned int   INT32U;
typedef signed   int   INT32S;
typedef float          FP32;
typedef double         FP64;

typedef INT32U         OS_STK;

#define BYTE           INT8S
#define UBYTE          INT8U
#define WORD           INT16S
#define UWORD          INT16U
#define LONG           INT32S
#define ULONG          INT32U

#ifndef NULL
#define NULL 0
#endif 

typedef INT32U   		OS_CPU_SR;

/* 
*********************************************************************************************************
*                                              ARM
*
* Method #1:  NOT IMPLEMENTED
*             Disable/Enable interrupts using simple instructions.  After critical section, interrupts
*             will be enabled even if they were disabled before entering the critical section.
*             
* Method #2:  NOT IMPLEMENTED
*             Disable/Enable interrupts by preserving the state of interrupts.  In other words, if 
*             interrupts were disabled before entering the critical section, they will be disabled when
*             leaving the critical section.
*             NOT IMPLEMENTED
*
* Method #3:  Disable/Enable interrupts by preserving the state of interrupts.  Generally speaking you
*             would store the state of the interrupt disable flag in the local variable 'cpu_sr' and then
*             disable interrupts.  'cpu_sr' is allocated in all of uC/OS-II's functions that need to 
*             disable interrupts.  You would restore the interrupt disable state by copying back 'cpu_sr'
*             into the CPU's status register.  This is the prefered method to disable interrupts.
*********************************************************************************************************
*/

#define  OS_CRITICAL_METHOD    3

#if      OS_CRITICAL_METHOD == 3
#define  OS_ENTER_CRITICAL()  {cpu_sr = OS_CPU_SR_Save();}
#define  OS_EXIT_CRITICAL()   {OS_CPU_SR_Restore(cpu_sr);}
#endif

/*
*********************************************************************************************************
*                                         ARM Miscellaneous
*********************************************************************************************************
*/

#define  OS_STK_GROWTH        1                       /* Stack grows from HIGH to LOW memory on ARM    */

#define  OS_TASK_SW()         OSCtxSw()

/*
*********************************************************************************************************
*                                            GLOBAL VARIABLES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                              PROTOTYPES
*********************************************************************************************************
*/

#if OS_CRITICAL_METHOD == 3                           /* Allocate storage for CPU status register      */
OS_CPU_SR  OSCPUSaveSR(void);
void OSCPURestoreSR(OS_CPU_SR cpu_sr);
void OSCPUEnableIrq(void);
int OSCPUGetSR(void);


#endif

#endif

