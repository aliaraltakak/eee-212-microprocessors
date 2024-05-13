#include <MKL25Z4.h>
#include <stdio.h>
#include <math.h>

#define RS 0x04     /* PTA2 mask */ 
#define RW 0x10     /* PTA4 mask */ 
#define EN 0x20     /* PTA5 mask */

/* Declare the LCD function prototypes. */
void LCD_command(unsigned char command);
void LCD_data(unsigned char data);
void LCD_init(void);
void LCD_ready(void);
void print_lcd(unsigned char *data_two);
void clear_lcd(void);

/* Declare the ADC and DAC function prototypes. */
void DAC0_init(void);
void ADC0_init(void);

/* Declare the function prototypes for timers and interrupts. */
void init_systick (void);
void SysTick_Handler(void);
void Delay(volatile unsigned int time_del);
void delayMs(int n);
int power(unsigned int val);


/* Declare the ADC and DAC functions. */
void DAC0_init(void) {
	SIM->SCGC6 |= 0x80000000; /*clock to DAC module */
	DAC0-> C1 = 0; /* disable the use of buffer */
	DAC0->C0 = 0x80 | 0x20; /* enable DAC and use software trigger */
}

void ADC0_init(void) {
	SIM->SCGC5 |= 0x2000; /* clock to PORTE */
	PORTE->PCR[20] = 0; /* PTE20 analog input */
	SIM->SCGC6 |= 0x8000000; /* clock to ADC0 */
	ADC0->SC2 &= ~0x40; /* software trigger */
	/* clock div by 4, long sample time, single ended 12 bit, bus clock */
	ADC0->CFG1 = 0x40 | 0x10 | 0x04 | 0x00;
}

/* Declare the delay functions. */
void delayMs(int n) {
	int i;
	int j;
	for (i =0; i <n; i++)
	for(j = 0; j<700; j++){}
}

void Delay(volatile unsigned int time_del) {
  while (time_del--) 
		{
  }
}

/* Declare the LCD functions. */
void LCD_init(void) {
    SIM->SCGC5 |= 0x1000;       /* enable clock to Port D */ 
    PORTD->PCR[0] = 0x100;      /* make PTD0 pin as GPIO */
    PORTD->PCR[1] = 0x100;      /* make PTD1 pin as GPIO */
    PORTD->PCR[2] = 0x100;      /* make PTD2 pin as GPIO */
    PORTD->PCR[3] = 0x100;      /* make PTD3 pin as GPIO */
    PORTD->PCR[4] = 0x100;      /* make PTD4 pin as GPIO */
    PORTD->PCR[5] = 0x100;      /* make PTD5 pin as GPIO */
    PORTD->PCR[6] = 0x100;      /* make PTD6 pin as GPIO */
    PORTD->PCR[7] = 0x100;      /* make PTD7 pin as GPIO */
    PTD->PDDR = 0xFF;           /* make PTD7-0 as output pins */
    
    SIM->SCGC5 |= 0x0200;       /* enable clock to Port A */ 
    PORTA->PCR[2] = 0x100;      /* make PTA2 pin as GPIO */
    PORTA->PCR[4] = 0x100;      /* make PTA4 pin as GPIO */
    PORTA->PCR[5] = 0x100;      /* make PTA5 pin as GPIO */
    PTA->PDDR |= 0x34;          /* make PTA5, 4, 2 as output pins */
    
    LCD_command(0x38);      /* set 8-bit data, 2-line, 5x7 font */
    LCD_command(0x01);      /* clear screen, move cursor to home */
    LCD_command(0x0F);      /* turn on display, cursor blinking */
}

void LCD_ready(void) {
    uint32_t status;
    
    PTD->PDDR = 0x00;          /* PortD input */
    PTA->PCOR = RS;         /* RS = 0 for status */
    PTA->PSOR = RW;         /* R/W = 1, LCD output */
    
    do {    /* stay in the loop until it is not busy */
			  PTA->PCOR = EN;
			  Delay(500);
        PTA->PSOR = EN;     /* raise E */
        Delay(500);
        status = PTD->PDIR; /* read status register */
        PTA->PCOR = EN;
        Delay(500);			/* clear E */
    } while (status & 0x80UL);    /* check busy bit */
    
    PTA->PCOR = RW;         /* R/W = 0, LCD input */
    PTD->PDDR = 0xFF;       /* PortD output */
}

void LCD_command(unsigned char command) {
    LCD_ready();			/* wait until LCD is ready */
    PTA->PCOR = RS | RW;    /* RS = 0, R/W = 0 */
    PTD->PDOR = command;
    PTA->PSOR = EN;         /* pulse E */
    Delay(500);
    PTA->PCOR = EN;
}

void LCD_data(unsigned char data) {
    LCD_ready();			/* wait until LCD is ready */
    PTA->PSOR = RS;         /* RS = 1, R/W = 0 */
    PTA->PCOR = RW;
    PTD->PDOR = data;
    PTA->PSOR = EN;         /* pulse E */
    Delay(500);
    PTA->PCOR = EN;
}

void clear_lcd(void) {	
	int i;
	LCD_command(0x80); //Start from the 1st line
	for(i = 16; i > 0; i--)
	{
			LCD_data(' '); //Clear the 1st line
	}
	LCD_command(0xC0); //Go to the 2nd line
	for(i = 16; i > 0; i--)
	{
			LCD_data(' '); //Clear the 2nd line
	}
	LCD_command(0x80);
}

void print_lcd(unsigned char *data_two) {
	int i = 0 ;
	//Continue until a NULL char comes
	while(data_two[i] != 0x00)
	{
		LCD_data(data_two[i]);
		i++;
	}	
}

/* Define the SysTick and interrupt functions. */
void init_systick (void) {
	SysTick->CTRL = 0; // Disable SysTick
	SysTick->LOAD = 0x13FFFF; // Set reload register to get 1s interrupts clk=20971520 NVIC_SetPriority(SysTick_IRQn, 3);
	SysTick->VAL = 0; // Reset the SysTick counter value
	SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk | SysTick_CTRL_ENABLE_Msk;
}

/* Define a magnitude function. */
int power(unsigned int val){
	int resultpow = 1;
	unsigned int m;
	for(m = 0 ; m < val ; ++m)
			  {
				  resultpow = resultpow * 10;
			  }
			return resultpow;		
}
