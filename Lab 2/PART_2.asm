ORG 000H

	ACALL CONFIGURE_LCD
	CLR A
	MOV DPTR, #INPUT_MESSAGE

INPUT_LOOP: ; Print an input message for user.
	MOVC A,@A+DPTR
	JZ READ_INPUT
	ACALL SEND_DATA
	CLR A
	INC DPTR
	SJMP INPUT_LOOP

KEYBOARD_LOOP:
	
	ACALL KEYBOARD		; NOW A HAS THE KEY THAT IS PRESSED
	ACALL SEND_DATA 	; SEND DATA TO LCD SCREEN
	SJMP KEYBOARD_LOOP	; DOING ALL OVER AGAIN


READ_INPUT:

	CLR A
	ACALL KEYBOARD ; Now A has the key pressed.
	ACALL SEND_DATA ; Send the data to LCD screen.
	CJNE A, #35D , COMPUTE_INPUT ; Compute the input if the key '#' is not pressed.
	LJMP CHECK_INPUTS ; Jump to the countdown subroutine. 
	

COMPUTE_INPUT: ; Obtain input from the pressed key, and turn it into an integer. 

	SUBB A, #30H
	MOV R5, A
	MOV A, R4
	MOV B, #10D
	MUL AB
	MOV R3, B
	ADD A, R5
	MOV R4, A
	SJMP READ_INPUT ; Register R4 holds the input value. 

CHECK_INPUTS:
	MOV A, R4

	CJNE A, #1, CHECK_INPUT_2      
	ACALL DISPLAY_INPUT_1          ; Call the display subroutine for input 1
	SJMP AFTER_DISPLAY             

CHECK_INPUT_2:
    	CJNE A, #2, CHECK_INPUT_3
    	ACALL DISPLAY_INPUT_2
    	SJMP AFTER_DISPLAY

CHECK_INPUT_3:
   	CJNE A, #3, CHECK_INPUT_4
    	ACALL DISPLAY_INPUT_3
    	SJMP AFTER_DISPLAY

CHECK_INPUT_4:
    	CJNE A, #4, CHECK_INPUT_5
    	ACALL DISPLAY_INPUT_4
    	SJMP AFTER_DISPLAY

CHECK_INPUT_5:
    	CJNE A, #5, CHECK_INPUT_6
    	ACALL DISPLAY_INPUT_5
    	SJMP AFTER_DISPLAY

CHECK_INPUT_6:
    	CJNE A, #6, CHECK_INPUT_7
    	ACALL DISPLAY_INPUT_6
    	SJMP AFTER_DISPLAY

CHECK_INPUT_7:
    	CJNE A, #7, CHECK_INPUT_8
    	ACALL DISPLAY_INPUT_7
    	SJMP AFTER_DISPLAY

CHECK_INPUT_8:
    	CJNE A, #8, CHECK_INPUT_9
    	ACALL DISPLAY_INPUT_8
    	SJMP AFTER_DISPLAY

CHECK_INPUT_9:
    	CJNE A, #9, CHECK_INPUT_10
    	ACALL DISPLAY_INPUT_9
    	SJMP AFTER_DISPLAY

CHECK_INPUT_10:
    	CJNE A, #10, CHECK_INPUT_11
    	ACALL DISPLAY_INPUT_10
    	SJMP AFTER_DISPLAY

CHECK_INPUT_11:
    	CJNE A, #11, CHECK_INPUT_12
    	ACALL DISPLAY_INPUT_11
    	SJMP AFTER_DISPLAY

CHECK_INPUT_12:
    	CJNE A, #12, CHECK_INPUT_13
    	ACALL DISPLAY_INPUT_12
    	SJMP AFTER_DISPLAY

CHECK_INPUT_13:
    	CJNE A, #13, CHECK_INPUT_14
    	ACALL DISPLAY_INPUT_13
    	SJMP AFTER_DISPLAY

CHECK_INPUT_14:
    	CJNE A, #14, CHECK_INPUT_15
    	ACALL DISPLAY_INPUT_14
    	SJMP AFTER_DISPLAY

CHECK_INPUT_15:
    	CJNE A, #15, INVALID_INPUT     
    	ACALL DISPLAY_INPUT_15
    	SJMP AFTER_DISPLAY

INVALID_INPUT:
	NOP

AFTER_DISPLAY:
	LJMP READ_INPUT
		
DISPLAY_INPUT_1:
    	MOV DPTR, #INPUT_1            ; Point to the message for input 1
    	ACALL PRINT_STRING_FROM_PTR   
    	RET

DISPLAY_INPUT_2:
    	MOV DPTR, #INPUT_2            ; Point to the message for input 2
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_3:
    	MOV DPTR, #INPUT_3            ; Point to the message for input 3
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_4:
    	MOV DPTR, #INPUT_4            ; Point to the message for input 4
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_5:
    	MOV DPTR, #INPUT_5            ; Point to the message for input 5
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_6:
    	MOV DPTR, #INPUT_6            ; Point to the message for input 6
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_7:
    	MOV DPTR, #INPUT_7            ; Point to the message for input 7
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_8:
    	MOV DPTR, #INPUT_8            ; Point to the message for input 8
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_9:
    	MOV DPTR, #INPUT_9            ; Point to the message for input 9
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_10:
    	MOV DPTR, #INPUT_10           ; Point to the message for input 10
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_11:
    	MOV DPTR, #INPUT_11           ; Point to the message for input 11
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_12:
    	MOV DPTR, #INPUT_12           ; Point to the message for input 12
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_13:
    	MOV DPTR, #INPUT_13           ; Point to the message for input 13
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_14:
    	MOV DPTR, #INPUT_14           ; Point to the message for input 14
    	ACALL PRINT_STRING_FROM_PTR
    	RET

DISPLAY_INPUT_15:
    	MOV DPTR, #INPUT_15           ; Point to the message for input 15
    	ACALL PRINT_STRING_FROM_PTR
    	RET
	    
PRINT_STRING_FROM_PTR:
    	MOV A, #01H           ; Command to clear the LCD or set cursor at the beginning
    	ACALL SEND_COMMAND
    	CLR A
    	MOV A, #0C0H          
    	ACALL SEND_COMMAND
    
NEXT_STRING:
	MOV A, #01H
	ACALL SEND_COMMAND
	CLR A
    	MOV R7, #8            ; Counter for 7 characters
    	CLR A

PRINT_CHARS:
	CLR A
    	MOVC A, @A+DPTR       ; Move the next character from program memory to A
    	JZ END_PRINT          
    	ACALL SEND_DATA       ; Send the character to the LCD
    	INC DPTR              ; Increment the data pointer to the next character
    	DJNZ R7, PRINT_CHARS  ; Decrement R7 and loop back if not zero
    	ACALL DELAY_500MS     
    	SJMP NEXT_STRING      

END_PRINT:
    	RET                   


MOV TMOD, #01H     
CLR TR0            
MOV TL0, #0B3H     
MOV TH0, #0CCH     
SETB TR0           

DELAY_500MS:
    	MOV TMOD, #01H     ; Timer 0 in mode 1 
    	CLR TR0            
    	CLR TF0            

    	MOV R2, #7         ; Counter for the number of overflows (7 overflows)

DELAY_LOOP:
    	MOV TH0, #0x7C     
    	MOV TL0, #0xB0     
    	SETB TR0           

WAIT_FOR_OVERFLOW:
    	JNB TF0, WAIT_FOR_OVERFLOW 
    	CLR TR0            
    	CLR TF0            
    	DJNZ R2, DELAY_LOOP 

    	RET                

	

;------------- LCD Configuration Subroutine ----------------;

CONFIGURE_LCD:	;THIS SUBROUTINE SENDS THE INITIALIZATION COMMANDS TO THE LCD

	MOV A,#38H	;TWO LINES, 5X7 MATRIX
	ACALL SEND_COMMAND
	MOV A,#0FH	;DISPLAY ON, CURSOR BLINKING
	ACALL SEND_COMMAND
	MOV A,#06H	;INCREMENT CURSOR (SHIFT CURSOR TO RIGHT)
	ACALL SEND_COMMAND
	MOV A,#01H	;CLEAR DISPLAY SCREEN
	ACALL SEND_COMMAND
	MOV A,#80H	;FORCE CURSOR TO BEGINNING OF THE FIRST LINE
	ACALL SEND_COMMAND
	RET

SEND_COMMAND: ;THIS SUBROUTINE SENDS THE LCD COMMANDS TO THE LCD

	MOV P1,A		;THE COMMAND IS STORED IN A, SEND IT TO LCD
	CLR P3.5		;RS=0 BEFORE SENDING COMMAND
	CLR P3.6		;R/W=0 TO WRITE
	SETB P3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	ACALL DELAY
	CLR P3.7
	RET

SEND_DATA: ;THIS SUBROUTINE SENDS DATA TO BE DISPLAYED IN AN ASCII FORMAT TO THE LCD

	MOV P1,A		;SEND THE DATA STORED IN A TO LCD
	SETB P3.5	;RS=1 BEFORE SENDING DATA
	CLR P3.6		;R/W=0 TO WRITE
	SETB P3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	ACALL DELAY
	CLR P3.7
	RET



;------------- Delay Subroutines for keyboard functioning ----------------;


DELAY:

	PUSH 0
	PUSH 1
	MOV R0,#55
	
DELAY_OUTER_LOOP:

	MOV R1,#255
	DJNZ R1,$
	DJNZ R0,DELAY_OUTER_LOOP
	POP 1
	POP 0
	RET


;-------------- Keyboard Subroutines ------------;


KEYBOARD: ; TAKES THE KEY PRESSED FROM THE KEYBOARD AND PUTS IT TO A

	MOV	P0, #0FFH	;MAKES P0 INPUT
	
K1:

	MOV	P2, #0	;GROUND ALL ROWS
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, K1
	
K2:

	ACALL	DELAY
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, KB_OVER
	SJMP	K2
	
KB_OVER:

	ACALL DELAY
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, KB_OVER1
	SJMP	K2
	
KB_OVER1:

	MOV	P2, #11111110B
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, ROW_0
	MOV	P2, #11111101B
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, ROW_1
	MOV	P2, #11111011B
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, ROW_2
	MOV	P2, #11110111B
	MOV	A, P0
	ANL	A, #00001111B
	CJNE	A, #00001111B, ROW_3
	LJMP	K2
	
ROW_0:

	MOV	DPTR, #KCODE0
	SJMP	KB_FIND
	
ROW_1:

	MOV	DPTR, #KCODE1
	SJMP	KB_FIND
	
ROW_2:

	MOV	DPTR, #KCODE2
	SJMP	KB_FIND
	
ROW_3:

	MOV	DPTR, #KCODE3
	
KB_FIND:

	RRC	A
	JNC	KB_MATCH
	INC	DPTR
	SJMP	KB_FIND
	
KB_MATCH:

	CLR	A
	MOVC	A, @A+DPTR; GET ASCII CODE FROM THE TABLE 
	RET


;---------------- Lookup Tables ----------------;


;ASCII LOOK-UP TABLE 
KCODE0:	DB	'1', '2', '3', 'A'
KCODE1:	DB	'4', '5', '6', 'B'
KCODE2:	DB	'7', '8', '9', 'C'
KCODE3:	DB	'*', '0', '#', 'D'


; Display the input indicator string in the LCD. 
INPUT_MESSAGE: DB 'INPUT: ', 0

; Define the decrement counter sequences.

INPUT_15: DB '15.0 SEC', '14.5 SEC', '14.0 SEC', '13.5 SEC', '13.0 SEC', '12.5 SEC', '12.0 SEC', '11.5 SEC', '11.0 SEC', '10.5 SEC', '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_14: DB '14.0 SEC', '13.5 SEC', '13.0 SEC', '12.5 SEC', '12.0 SEC', '11.5 SEC', '11.0 SEC', '10.5 SEC', '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_13: DB '13.0 SEC', '12.5 SEC', '12.0 SEC', '11.5 SEC', '11.0 SEC', '10.5 SEC', '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_12: DB '12.0 SEC', '11.5 SEC', '11.0 SEC', '10.5 SEC', '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_11: DB '11.0 SEC', '10.5 SEC', '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_10: DB '10.0 SEC', '9.50 SEC', '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_9: DB '9.00 SEC', '8.50 SEC', '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_8: DB '8.00 SEC', '7.50 SEC', '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_7: DB '7.00 SEC', '6.50 SEC', '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_6: DB '6.00 SEC', '5.50 SEC', '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_5: DB '5.00 SEC', '4.50 SEC', '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_4: DB '4.00 SEC', '3.50 SEC', '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_3: DB '3.00 SEC', '2.50 SEC', '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_2: DB '2.00 SEC', '1.50 SEC', '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0

INPUT_1: DB '1.00 SEC', '0.50 SEC', 'LAUNCH!', 0


END 

