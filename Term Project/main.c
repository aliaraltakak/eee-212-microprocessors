#include <MKL25Z4.h>
#include <stdio.h>
#include <math.h>
#include "Project_Utils.h"

#define SINE_WAVE "CUR. WAVE: SIN"
#define SQUARE_WAVE "CUR. WAVE: SQU"
#define SAWTOOTH_WAVE "CUR. WAVE: SAW"
#define WAVEFORM_LENGTH 48

/* Define function prototypes. */
void initializeHardware(void);
void PORTA_IRQHandler(void);
void SysTick_Handler(void);
void sineGenerator(void);

/* Define the global variables. */
static int buttonStatus = 0;
static int sinewave[WAVEFORM_LENGTH];
static short int result;
const static int waveform[] = {0,0,0,0,0,0,
0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,3724,
3724,3724,3724,3724,3724,3724,3724,3724,3724,
3724,3724,3724,3724,3724,3724,3724,3724,3724,3724,
};
const float PI = 3.1415926535897;

/* Define a function that will initialize the hardware. */
void initializeHardware() {
	LCD_init(); 			// LCD
	DAC0_init(); 			// DAC
	ADC0_init(); 			// ADC
	init_systick(); 	// SysTick
}

/* Define a function to handle the interrupt request on port A. */
void PORTA_IRQHandler(void) {  
	buttonStatus++;
	PORTA->ISFR  = 0x00000006; /* clear interrupt flag*/
}

/* Define a function to calculate the value of the sine from the lookup table. */
void sineGenerator(void) {
    float fRadians = ((2 * PI) / WAVEFORM_LENGTH);
    for (int i = 0; i < WAVEFORM_LENGTH; i++) {
        sinewave[i] = (int)((3.0 * sinf(fRadians * i)) / 0.000806);
    }
}

/* Define a function to handle the LCD screen display by using SysTick. */
void SysTick_Handler(void) {
	
	/* Define decimal variables to display the amplitude. */
	int firstDecimal = 0;
	int secondDecimal = 0;
	int thirdDecimal = 0;
	
	clear_lcd();
	
	/* Display the abbreviation of the waveform depending on the status of the push button. */
	if (buttonStatus % 3 == 0) {
		print_lcd((unsigned char *)SQUARE_WAVE);
	}
	if (buttonStatus % 3 == 1) {
		print_lcd((unsigned char *)SINE_WAVE); 
	}
	if (buttonStatus % 3 == 2){
		print_lcd((unsigned char *)SAWTOOTH_WAVE);
	}
	
	/* Move the cursor to the second line of the LCD and display the amplitude of the generated waveform. */
	LCD_command(0xC0);  
	print_lcd("AMPLITUDE:");
	
	result = result*3320/4095;
	
  firstDecimal = power(3);
	secondDecimal = result / firstDecimal;
	result = result % firstDecimal;
	
	if(secondDecimal == 0) {
		if(thirdDecimal != 0) {
			LCD_data((char)(secondDecimal + '0'));
		}
	}
	
	else {
		LCD_data((char)(secondDecimal + '0'));
		thirdDecimal++;
		}
	
	LCD_data('.');
		
	firstDecimal = power(2);
	secondDecimal = result / firstDecimal;
	result = result % firstDecimal;
		
	if(secondDecimal == 0) {
		if(thirdDecimal != 0) {
			LCD_data((char)(secondDecimal + '0'));
			 }
		 }
	
	else {
		LCD_data((char)(secondDecimal + '0'));
		thirdDecimal++;
		 }
	
	firstDecimal = power(1);
	secondDecimal = result / firstDecimal;
	result = result % firstDecimal;
		 
	if(secondDecimal == 0) {
		if(thirdDecimal != 0) {
			LCD_data((char)(secondDecimal + '0'));
		}
	}
	
	else {
		LCD_data((char)(secondDecimal + '0'));
		thirdDecimal++;
	}
	
	LCD_data('V');
	
}

int main(void) {
	
	/* Initialize functions. */
	initializeHardware();
	sineGenerator();
	
	LCD_command(0x80);      
	__disable_irq(); /* global disable IRQs */
	
	/* Configure Port A Pin 1 as interrupt. */
	SIM->SCGC5 |= 0x200; 
	PORTA->PCR[1] |= 0x00100; 
	PORTA->PCR[1] |= 0X00003; 
	PTA->PDDR &= ~0x0002; 
	PORTA->PCR[1] &= ~0xF0000; 
	PORTA->PCR[1] |= 0XA0000;

	__enable_irq(); /* global enable interrupt */
	NVIC->ISER[0] |= 0x40000000;
	ADC0->SC1[0] = 0; /* start conversion on channel 0 */
	while(!(ADC0->SC1[0] & 0x80)) { } /* wait for conversion complete */
	result = ADC0->R[0]; /* read conversion result and clear COCO flag */
		
	while (1) {
		while (buttonStatus % 3 == 0) {
			for (int i = 0; i < 39; i++) {
				ADC0->SC1[0] = 0;
        while (!(ADC0->SC1[0] & 0x80)) {} // Wait for conversion complete.
        result = ADC0->R[0];
        DAC0->DAT[0].DATL = result * waveform[i] / 3724 & 0xff;
        DAC0->DAT[0].DATH = (result * waveform[i] / 3724) >> 8;
        Delay(41);
      }
     }
		
    while (buttonStatus % 3 == 2) {
			for (int a = 0; a < 0x1241; a += 0x000077) {
				ADC0->SC1[0] = 0;
        while (!(ADC0->SC1[0] & 0x80)) {} // Wait for conversion complete.
        result = ADC0->R[0];
        DAC0->DAT[0].DATL = result * a / 4095 & 0xff;
        DAC0->DAT[0].DATH = (result * a / 4095) >> 8;
        Delay(29);
      }
    }
		
    while (buttonStatus % 3 == 1) {
			for (int i = 0; i < 25; i++) {
				ADC0->SC1[0] = 0;
        while (!(ADC0->SC1[0] & 0x80)) {} // Wait for conversion complete.
        result = ADC0->R[0];
        DAC0->DAT[0].DATL = result * sinewave[i] / 4095 & 0xff;
        DAC0->DAT[0].DATH = (result * sinewave[i] / 4095) >> 8;
        Delay(11);
      }
      for (int i = 0; i < 48; i++) {
				DAC0->DAT[0].DATL = 61 & 0xff;
        DAC0->DAT[0].DATH = (18 >> 8) & 0x0f;
        Delay(34);
      }
		}
}
	}
