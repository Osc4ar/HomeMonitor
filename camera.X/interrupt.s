		.include "p30F4013.inc"
		.global __T3Interrupt
		.GLOBAL	_RETARDO_1S

__T3Interrupt:
    BTG	    LATD,	#LATD0
    NOP
    BCLR    IFS0,	#T3IF
    RETFIE
    