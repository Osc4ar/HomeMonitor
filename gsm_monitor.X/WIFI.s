
    		.include "p30F4013.inc"
		.global __U2RXinterrupt

__U2RXInterrupt:
    PUSH W0
    MOV U2RXREG, W0
    NOP
    MOV W0, U1TXREG
    NOP
    BCLR IFS1, #U2RXIF
    NOP
    POP W0
    RETFIE
    