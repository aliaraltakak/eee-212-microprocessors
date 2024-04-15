/* Include the required headers. */
#include <MKL25Z4.h> 
#include <stdio.h>
#include <math.h>
#include "utils.h"
#include <stdint.h>


/* Define a function that initializes the IO mapping for ports. */
void initIOMAP(void) {
	
    /* Enable clock for Port C and Port B. */,
	
    SIM->SCGC5 |= (1 << 10) | (1 << 11); 

    /* Define the GPIO pin configuration for switch. */
	
    PORTC->PCR[2] |= (1 << 8); /* Port C Pin 2 */
    PORTC->PCR[3] |= (1 << 8); /* Port C Pin 3 */
    PORTC->PCR[4] |= (1 << 8); /* Port C Pin 4 */

    /* Define the GPIO pin configuration for indicator LEDS. */
	
    PORTB->PCR[0] |= (1 << 8); /* Port B Pin 0 */
    PORTB->PCR[1] |= (1 << 8); /* Port B Pin 1 */
    PORTB->PCR[2] |= (1 << 8); /* Port B Pin 2 */
    PORTB->PCR[3] |= (1 << 8); /* Port B Pin 3 */

    /* Define the LED Pins as output pins. */
	
    GPIOB->PDDR |= (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3);
}

int main() {
	
		/* Initialize IO mapper function inside main. */
    initIOMAP();

    uint8_t counterVal = 0; /* Initialize a memory address for counter indicator. (8-bit unsigned integer) */
    uint32_t userDelay = 0; /* Initialize a memory address for delay time. (32-bit unsigned integer) */

    while (1) {
				
				/* Read switch states in order to implement varying outcomes. */
        uint8_t readSwitch1 = (GPIOC->PDIR & (1 << 2)) >> 2; 
        uint8_t readSwitch2 = (GPIOC->PDIR & (1 << 3)) >> 3;
        uint8_t readSwitch3 = (GPIOC->PDIR & (1 << 4)) >> 4;
				
				/* Different states for incrementing mode. */
        if (readSwitch1) {
					
						/* Switch 3 ON, Switch 2 OFF. */
						if (readSwitch3 && !readSwitch2) {	
                userDelay = 500; 
							
            }
						
						/* Switch 3 OFF, Switch 2 OFF. */
						else if (!readSwitch3 && !readSwitch2) {
                userDelay = 250; 
							
            }
						
						/* Switch 3 OFF, Switch 2 ON. */
						else if (!readSwitch3 && readSwitch2) {
                userDelay = 1000; 
							
            } 
						
						else {
                userDelay = 0; 
            }	
        }
				
					/* Different states for decrementing mode. */
				else {
            
						/* Switch 3 ON, Switch 2 OFF. */
            if (readSwitch3 && !readSwitch2) { 
                userDelay = 500; 
							
            }
						
						/* Switch 3 OFF, Switch 2 OFF. */
						else if (!readSwitch3 && !readSwitch2) {
                userDelay = 250; 
							
            }
						
						/* Switch 3 OFF, Switch 2 ON. */
						else if (!readSwitch3 && readSwitch2) {
                userDelay = 1000; 
							
            }
						
						else {
                userDelay = 0; 
            }
        }

				/* Read the state of switch 1 to indicate increment or decrement mode. */
        if (readSwitch1) {
            
            counterVal++; /* Increment counterVal. */
					
						/* Return to 0 if counterVal reaches 15 in increment mode. */
            if (counterVal > 15) {	
                counterVal = 0; 
            }
        } else {
            
						/* Return to 15 if counterVal reaches 0 in decrement mode. */
            if (counterVal == 0) { 
                counterVal = 15; 
            } else {
							
                counterVal--; /* Decrement counterVal. */
            }
        }

        GPIOB->PDOR = counterVal;

        /* Implement a delay function for the specified time. */
				
        for (volatile uint32_t i = 0; i < userDelay * 1000; i++) {
				__NOP(); /* Multiply the input with 1000 due to 1MC = 1 microsec. */
				}
    }

    return 0;
}