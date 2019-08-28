#include "p30F4013.h"

#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/

#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)

#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)

#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)

#define EVER 1
#define MUESTRAS 64

void iniPerifericos(void);
void iniInterrupciones(void);
void configUART(void);
void RETARDO_30ms(void);
void RETARDO_1S(void);
void RETARDO_5S(void);
void RETARDO_3S(void);
void comando(char [], int);
void takePicture(void);
void requestJPEG(int);

int main(void)
{
    iniPerifericos();
    configUART();
    iniInterrupciones();
    
    U1MODEbits.UARTEN = 1;
    U1STAbits.UTXEN = 1;
    
    U2MODEbits.UARTEN = 1;
    U2STAbits.UTXEN = 1;

    takePicture();
    
    for(;EVER;)
    {
        Nop();
    }
    return 1;
}

void takePicture(void)
{
    char reset[] = {0x56, 0x00, 0x26, 0x00};
    //char changeBaud[] = {0x56, 0x00, 0x24, 0x03, 0x01, 0xAE, 0xC8};
    char takePic[] = {0x56, 0x00, 0x36, 0x01, 0x00};
    char jpgSize[] = {0x56, 0x00, 0x34, 0x01, 0x00};
    RETARDO_5S();
    comando(reset, 4);
    RETARDO_1S();
    comando(takePic, 5);
    RETARDO_1S();
    comando(jpgSize, 5);
    RETARDO_1S();
    int i;
    for (i = 0; i < 4; i++)
        requestJPEG(i);
}

void requestJPEG(int i) {
    char requestJPEG[] = {0x56, 0x00, 0x32, 0x0C, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x0A};
    requestJPEG[8] = 0x10 * i;
    comando(requestJPEG, 16);
    RETARDO_3S();
}

void comando(char c[], int s) {
    int i;
    for (i = 0; i < s; i++) {
        IFS1bits.U2TXIF = 0;
        U2TXREG = c[i];
        Nop();
        while (IFS1bits.U2TXIF == 0)
            Nop();
    }
}

void iniInterrupciones(void)
{
    IFS1bits.U2RXIF = 0;
    IEC1bits.U2RXIE = 1;
}

void configUART(void)
{
    U1MODE = 0x0420;
    U1STA = 0x8000;
    U1BRG = 2; //38400
    //U1BRG = 25; //9600
    
    U2MODE = 0x0020;
    U2STA = 0x8000;
    U2BRG = 2; //38400
}

void RETARDO_5S(void)
{
    int k = 0;
    for(k = 0; k < 5; k++)
        RETARDO_1S();
}

void RETARDO_3S(void)
{
    int k = 0;
    for(k = 0; k < 3; k++)
        RETARDO_1S();
}

void iniPerifericos( void )
{
    PORTB = 0;
    Nop();
    LATB = 0;
    Nop();
    
    PORTD = 0;
    Nop();
    LATD = 0;
    Nop();
    
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();   
    
    PORTC = 0;
    Nop();
    LATC = 0;
    Nop(); 
    
    TRISBbits.TRISB8 = 0;
    Nop();
    
    TRISCbits.TRISC13 = 0;
    Nop();
    TRISCbits.TRISC14 = 1;
    Nop();
    
    TRISDbits.TRISD1 = 0;
    Nop(); 
    
    TRISFbits.TRISF5 = 1;
    Nop();
    TRISFbits.TRISF4 = 0;
    Nop();
    
    ADPCFG = 0xFFFF;
}