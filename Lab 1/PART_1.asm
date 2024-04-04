MOV R0, #01ch ; Start by moving a hex value to the register R0.

MOV A, R0 ; Move the input value to the accumulator to execute mathematical operations.

MOV B, #10d ; Store the decimal value ten in register B convert from hex to decimal.

DIV AB ; Divide the hex value stored in the accumulator by the value in B to find the quoitent and remainder.

MOV R1, B ; Move the remainder to register R1.

MOV B, #10D ; Move the decimal value 10 to register B. 

DIV AB ; Divide the contents of register A by the contents of register B.

MOV R2, B ; Move the remainder to register R2.

ADD A, R1 ; Append the value inside register R1 to A.

ADD A, R2 ; Append the value inside register R2 to A.

MOV R0, #0D ;Clear the contents of register R0.

MOV R2, #0D ; Clear the contents of register R2. 

MOV R1, A ; Move the contents of register A to register R1. 