
#define	_ASMLANGUAGE
	.extern OSRunning                    //External references
    .extern OSPrioCur
    .extern OSPrioHighRdy
    .extern OSTCBCur
    .extern OSTCBHighRdy
    .extern OSIntNesting
    .extern OSIntExit
    .extern OSTaskSwHook
	.extern OS_CPU_IRQ_ISR_Handler

	.globl	OSDisableInt
	.globl	OSEnableInt

	.global OSCtxSw;
	.global OSIntCtxSw;
	.global	OSStartHighRdy
	
	.global OSTaskSwHook
	.global OSRunning
	.global OSTCBCur
	.global OSTCBHighRdy
	.global OSPrioCur
	.global OSPrioHighRdy
	.global OS_CPU_SR_Save
	.global OS_CPU_SR_Restore
	.global OS_CPU_IRQ_ISR


OSCtxSw:
                                        // SAVE CURRENT TASK'S CONTEXT
        STR     LR,  [SP, #-4]!         //     Return address
        STR     LR,  [SP, #-4]!
        STR     R12, [SP, #-4]!
        STR     R11, [SP, #-4]!
        STR     R10, [SP, #-4]!
        STR     R9,  [SP, #-4]!
        STR     R8,  [SP, #-4]!
        STR     R7,  [SP, #-4]!
        STR     R6,  [SP, #-4]!
        STR     R5,  [SP, #-4]!
        STR     R4,  [SP, #-4]!
        STR     R3,  [SP, #-4]!
        STR     R2,  [SP, #-4]!
        STR     R1,  [SP, #-4]!
        STR     R0,  [SP, #-4]!
        MRS     R4,  CPSR               //    push current CPSR
        STR     R4,  [SP, #-4]!

        LDR     R4, =OSTCBCur         // OSTCBCur->OSTCBStkPtr = SP;
        LDR     R5, [R4]
        STR     SP, [R5]

        BL      OSTaskSwHook            // OSTaskSwHook();

        LDR     R4, =OSPrioCur        // OSPrioCur = OSPrioHighRdy
        LDR     R5, =OSPrioHighRdy
        LDRB    R6, [R5]
        STRB    R6, [R4]

        LDR     R4, =OSTCBCur         // OSTCBCur  = OSTCBHighRdy;
        LDR     R6, =OSTCBHighRdy
        LDR     R6, [R6]
        STR     R6, [R4]

        LDR     SP, [R6]                // SP = OSTCBHighRdy->OSTCBStkPtr;

                                        // RESTORE NEW TASK'S CONTEXT
        LDR     R4,  [SP], #4           //    pop new task's CPSR
        MSR     CPSR_cxsf, R4
        LDR     R0,  [SP], #4           //    pop new task's context
        LDR     R1,  [SP], #4
        LDR     R2,  [SP], #4
        LDR     R3,  [SP], #4
        LDR     R4,  [SP], #4
        LDR     R5,  [SP], #4
        LDR     R6,  [SP], #4
        LDR     R7,  [SP], #4
        LDR     R8,  [SP], #4
        LDR     R9,  [SP], #4
        LDR     R10, [SP], #4
        LDR     R11, [SP], #4
        LDR     R12, [SP], #4
        LDR     LR,  [SP], #4
        LDR     PC,  [SP], #4

OSIntCtxSw:
        BL      OSTaskSwHook           // OSTaskSwHook();

        LDR     R4,=OSPrioCur         // OSPrioCur = OSPrioHighRdy
        LDR     R5,=OSPrioHighRdy
        LDRB    R6,[R5]
        STRB    R6,[R4]

        LDR     R4,=OSTCBCur          // OSTCBCur  = OSTCBHighRdy;
        LDR     R6,=OSTCBHighRdy
        LDR     R6,[R6]
        STR     R6,[R4]

        LDR     SP,[R6]                 // SP = OSTCBHighRdy->OSTCBStkPtr;

                                        // RESTORE NEW TASK'S CONTEXT
        LDR     R4,  [SP], #4           //    pop new task's CPSR
        MSR     CPSR_cxsf, R4
        LDR     R0,  [SP], #4           //    pop new task's context
        LDR     R1,  [SP], #4
        LDR     R2,  [SP], #4
        LDR     R3,  [SP], #4
        LDR     R4,  [SP], #4
        LDR     R5,  [SP], #4
        LDR     R6,  [SP], #4
        LDR     R7,  [SP], #4
        LDR     R8,  [SP], #4
        LDR     R9,  [SP], #4
        LDR     R10, [SP], #4
        LDR     R11, [SP], #4
        LDR     R12, [SP], #4
        LDR     LR,  [SP], #4
        LDR     PC,  [SP], #4

OSStartHighRdy:

        MSR     CPSR_cxsf, #0xDF        //Switch to SYS mode with IRQ and FIQ disabled

        BL      OSTaskSwHook            //OSTaskSwHook();

        LDR     R4, =OSRunning        //OSRunning = TRUE
        MOV     R5, #1
        STRB    R5, [R4]

                                        //SWITCH TO HIGHEST PRIORITY TASK
        LDR     R4, =OSTCBHighRdy     //    Get highest priority task TCB address
        LDR     R4, [R4]                //    get stack pointer
        LDR     SP, [R4]                //    switch to the new stack

        LDR     R4,  [SP], #4           //    pop new task's CPSR
        MSR     CPSR_cxsf,R4
        LDR     R0,  [SP], #4           //    pop new task's context
        LDR     R1,  [SP], #4
        LDR     R2,  [SP], #4
        LDR     R3,  [SP], #4
        LDR     R4,  [SP], #4
        LDR     R5,  [SP], #4
        LDR     R6,  [SP], #4
        LDR     R7,  [SP], #4
        LDR     R8,  [SP], #4
        LDR     R9,  [SP], #4
        LDR     R10, [SP], #4
        LDR     R11, [SP], #4
        LDR     R12, [SP], #4
        LDR     LR,  [SP], #4

       // LDR     R0, [SP]

		//BL		uart_send

        LDR     PC,  [SP], #4

OS_CPU_SR_Save:
        MRS     R0,CPSR                     // Set IRQ and FIQ bits in CPSR to disable all interrupts
        ORR     R1,R0,#0xC0
        MSR     CPSR_c,R1
        MRS     R1,CPSR                     // Confirm that CPSR contains the proper interrupt disable flags
        AND     R1,R1,#0xC0
        CMP     R1,#0xC0
        BNE     OS_CPU_SR_Save              // Not properly disabled (try again)
        MOV     PC,LR                       // Disabled, return the original CPSR contents in R0

OS_CPU_SR_Restore:
        MSR     CPSR_c,R0
        MOV     PC,LR


OS_CPU_IRQ_ISR:

        STR     R3,  [SP, #-4]!                // PUSH WORKING REGISTERS ONTO IRQ STACK
        STR     R2,  [SP, #-4]!
        STR     R1,  [SP, #-4]!

        MOV     R1, SP                         // Save   IRQ stack pointer

        ADD     SP, SP,#12                     // Adjust IRQ stack pointer

        SUB     R2, LR,#4                      // Adjust PC for return address to task

        MRS     R3, SPSR                       // Copy SPSR (i.e. interrupted task's CPSR) to R3

        MSR     CPSR_c, #0xDF 					// Change to SYS mode

                                               // SAVE TASK'S CONTEXT ONTO TASK'S STACK
        STR     R2,  [SP, #-4]!                //    Push task's Return PC
        STR     LR,  [SP, #-4]!                //    Push task's LR
        STR     R12, [SP, #-4]!                //    Push task's R12-R4
        STR     R11, [SP, #-4]!
        STR     R10, [SP, #-4]!
        STR     R9,  [SP, #-4]!
        STR     R8,  [SP, #-4]!
        STR     R7,  [SP, #-4]!
        STR     R6,  [SP, #-4]!
        STR     R5,  [SP, #-4]!
        STR     R4,  [SP, #-4]!

        LDR     R4,  [R1], #4                  //    Move task's R1-R3 from IRQ stack to SYS stack
        LDR     R5,  [R1], #4
        LDR     R6,  [R1], #4
        STR     R6,  [SP, #-4]!
        STR     R5,  [SP, #-4]!
        STR     R4,  [SP, #-4]!

        STR     R0,  [SP, #-4]!                //    Push task's R0    onto task's stack
        STR     R3,  [SP, #-4]!                //    Push task's CPSR (i.e. IRQ's SPSR)

                                               // HANDLE NESTING COUNTER
        LDR     R0, =OSIntNesting            // OSIntNesting++;
        LDRB    R1, [R0]
        ADD     R1, R1,#1
        STRB    R1, [R0]

        CMP     R1, #1                         // if (OSIntNesting == 1) {
        BNE     OS_CPU_IRQ_ISR_1

        LDR     R4, =OSTCBCur                //     OSTCBCur->OSTCBStkPtr = SP
        LDR     R5, [R4]
        STR     SP, [R5]                       // }

OS_CPU_IRQ_ISR_1:
        MSR     CPSR_c, #0xD2    			   // Change to IRQ mode (to use the IRQ stack to handle interrupt)

        BL      OS_CPU_IRQ_ISR_Handler         // OS_CPU_IRQ_ISR_Handler();

        MSR     CPSR_c, #0xDF 				  // Change to SYS mode

        BL      OSIntExit                     // OSIntExit();

                                              // RESTORE TASK'S CONTEXT and RETURN TO TASK
        LDR     R4,  [SP], #4                 //    pop new task's CPSR
        MSR     CPSR_cxsf, R4
        LDR     R0,  [SP], #4                 //    pop new task's context
        LDR     R1,  [SP], #4
        LDR     R2,  [SP], #4
        LDR     R3,  [SP], #4
        LDR     R4,  [SP], #4
        LDR     R5,  [SP], #4
        LDR     R6,  [SP], #4
        LDR     R7,  [SP], #4
        LDR     R8,  [SP], #4
        LDR     R9,  [SP], #4
        LDR     R10, [SP], #4
        LDR     R11, [SP], #4
        LDR     R12, [SP], #4
        LDR     LR,  [SP], #4
        LDR     PC,  [SP], #4
