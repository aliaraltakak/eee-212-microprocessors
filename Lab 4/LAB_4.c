#include <MKL25Z4.h>
#include <stdio.h>
#include <math.h>
#define MASK(x) (1UL << (x))

void initializeTPM1(void); /* Use TPM1 for Pulse-Width-Modulation. */
void delay500ms(void); /* Use 0.5 sec delay for movement of servo between angles. */
void initializeButton(void); /* Button control for servo state. */
void PORTD_IRQHandler(void); /* Interrupt service for servo state. */

volatile int servoLoc = 0;

/* Define a function to initialize TPM1 */
void initializeTPM1(void) {
	
	SIM -> SCGC6 |= SIM_SCGC6_TPM1_MASK;
	SIM -> SCGC5 |= SIM_SCGC5_PORTB_MASK;
	SIM -> SOPT2 &=  ~SIM_SOPT2_TPMSRC_MASK;
	SIM -> SOPT2 |= SIM_SOPT2_TPMSRC(1);
	
	PORTB -> PCR[0] &=  ~PORT_PCR_MUX_MASK;
	PORTB -> PCR[0] |= PORT_PCR_MUX(3);
	
	// Set up TPM1 values for 50 Hz signal (32 prescaler).
	TPM1 -> MOD = 209700;
	TPM1->SC &= ~((TPM_SC_PS_MASK) | (TPM_SC_CMOD_MASK));
	TPM1->SC |= TPM_SC_PS(5) | TPM_SC_CMOD(1);
	TPM1_C0SC &= ~((TPM_CnSC_ELSB_MASK) | (TPM_CnSC_ELSA_MASK) | (TPM_CnSC_MSB_MASK) | (TPM_CnSC_MSA_MASK));
	TPM1_C0SC |= (TPM_CnSC_ELSB(1)) | (TPM_CnSC_MSB(1));	

}


/* Define a 0.5 sec delay function for time between movement of servo angles. */
void delay500ms(void) {
	
	SysTick -> LOAD = 10484999UL;
	SysTick -> VAL = 0UL;
	SysTick -> CTRL = SysTick_CTRL_CLKSOURCE_Msk | SysTick_CTRL_ENABLE_Msk;
	
	while ((SysTick -> CTRL & SysTick_CTRL_COUNTFLAG_Msk) == 0);
		
		SysTick -> CTRL = 0;
	}

/* Define a function that will initialize the button which will control the states. */
void initializeButton(void) {
	
	/* Use PORT D Pin 1 */
	SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;
	PORTD->PCR[1] = PORT_PCR_MUX(1) | PORT_PCR_PE_MASK | PORT_PCR_PS_MASK;
	PORTD->PCR[1] |= PORT_PCR_IRQC(0x0A); /* Set for falling edge triggering. */
	
	/* Clear and enable interrups for PORT D. */
	PTD->PDDR &= ~MASK(1);
	
	NVIC_SetPriority(PORTD_IRQn, 128);
	NVIC_ClearPendingIRQ(PORTD_IRQn);
  NVIC_EnableIRQ(PORTD_IRQn);
  }

/* Define the Port D IRQ Handler. */
void PORTD_IRQHandler(void) {
	
    if (PORTD->ISFR & MASK(1)) {  
       
        NVIC_ClearPendingIRQ(PORTD_IRQn);
				servoLoc ^= 1;
        
        PORTD->ISFR = 0xffffffff;
				
	}
}

int main(void) {
	
	__enable_irq();
	initializeTPM1();
	initializeButton();

	while (1) {
		if (servoLoc == 0) {
       
				TPM1_C0V = 297; /* Location for degree 0. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 504; /* Location for degree 30. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 720; /* Location for degree 60. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 928; /* Location for degree 90. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 720; /* Location for degree 60. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 504;	/* Location for degree 30. */
				if (servoLoc == 1) {
						continue;
				}
				delay500ms();
		
				TPM1_C0V = 297; /* Location for degree 0. */
        } 
		else {
        
			
				TPM1_C0V = 1548; /* Location for degree 180. */
			if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 1329;  /* Location for degree 150. */
				if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 1129; /* Location for degree 120. */
				if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 928;  /* Location for degree 90. */
				if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 1129; /* Location for degree 120. */
				if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 1329;  /* Location for degree 150. */
								if (servoLoc == 0) {
						continue;
				}
				delay500ms();
				
				TPM1_C0V = 1548; /* Location for degree 180. */
        }
    }
}



	
	
