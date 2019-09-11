
    	.include "p30F4013.inc"
	.global __U2RXinterrupt
	.global _comandoAT


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

_comandoAT:
	MOV W0,W1
CICLO:
	MOV.B [W1++],W0
	AND #0x00FF, W0
	CP0.B W0
	BRA Z,FIN
	BCLR IFS1, #U2TXIF
	MOV W0,		U2TXREG
	NOP
CHECK:
	BTSC IFS1, #U2TXIF
	GOTO CICLO
	GOTO CHECK
FIN:
	RETURN


