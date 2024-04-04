; Set both timers to mode 1.
MOV TMOD, #00010001B 

CLR P2.6            ; Clear the output pin P2.6
CLR P2.7            ; Clear the output pin P2.7

MAIN:
    MOV A, #0FFH
    MOV P1, A           ; Set P1 as input

    JB P1.0, SWITCH_ON
    JNB P1.0, SWITCH_OFF

SWITCH_ON:
    ; Load the calculated timer reload values for the ON state.
    MOV TH0, #0F8H
    MOV TL0, #2CH
    SETB TR0            ; Start Timer 0

    MOV TH1, #0FCH
    MOV TL1, #16H
    SETB TR1            ; Start Timer 1

    ; Main loop for ON state.
    ON_MAIN:
        JNB TF0, NO_TOGGLE_ON
        CLR TR0
        CPL P2.6
        MOV TH0, #0F8H   ; Reload Timer 0 high byte
        MOV TL0, #2CH    ; Reload Timer 0 low byte
        SETB TR0
        CLR TF0

    NO_TOGGLE_ON:
        JNB TF1, CHECK_SWITCH_ON
        CLR TR1
        CPL P2.7
        MOV TH1, #0FCH   ; Reload Timer 1 high byte
        MOV TL1, #16H    ; Reload Timer 1 low byte
        SETB TR1
        CLR TF1
        SJMP ON_MAIN

    CHECK_SWITCH_ON:
        JB P1.0, ON_MAIN
        SJMP MAIN

SWITCH_OFF:
    ; Clear the outputs for OFF state.
    CLR P2.6
    CLR P2.7

    ; Load the calculated timer reload values for the OFF state.
    MOV TH0, #0FEH
    MOV TL0, #0BH
    SETB TR0            ; Start Timer 0

    MOV TH1, #0FCH
    MOV TL1, #16H
    SETB TR1            ; Start Timer 1

    ; Main loop for OFF state.
    OFF_MAIN:
        JNB TF0, NO_TOGGLE_OFF
        CLR TR0
        CPL P2.6
        MOV TH0, #0FEH   ; Reload Timer 0 high byte
        MOV TL0, #0BH    ; Reload Timer 0 low byte
        SETB TR0
        CLR TF0

    NO_TOGGLE_OFF:
        JNB TF1, CHECK_SWITCH_OFF
        CLR TR1
        CPL P2.7
        MOV TH1, #0FCH   ; Reload Timer 1 high byte
        MOV TL1, #16H    ; Reload Timer 1 low byte
        SETB TR1
        CLR TF1
        SJMP OFF_MAIN

    CHECK_SWITCH_OFF:
        JNB P1.0, OFF_MAIN
        SJMP MAIN

END

