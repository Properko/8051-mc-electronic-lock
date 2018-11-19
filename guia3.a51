#include <REG51F380.h>
$include(DISPLAY_LOOKUP.INC)

; define global variables
BLOCK_SIZE EQU 8

PB1 EQU P0.6
PB2 EQU P0.7

NOT_INITIALIZED EQU 0FFH

; we have a way of representing 16 numbers on the display (0-F)
NUMBER_COUNT EQU 16

; CALL INIT
CSEG	AT	0H
	LJMP	INIT
CSEG	AT	50H

INIT:
	MOV PCA0MD, #0
	; needed for using buttons and screen
	MOV XBR1, #40H
	SETB PB1
	SETB PB2
	
	LJMP MAIN
MAIN:
	MOV R0, #01H
	MOV R1, #02H
	MOV R2, #03H
	MOV R3, #04H
    CALL ENCRYPT_KEY_R2_R3_R4_R5_INTO_R6_R7
	MOV R0, #00H
	MOV R1, #00H
	MOV R2, #00H
	MOV R3, #00H
    CALL DECRYPT_KEY_R6_R7_INTO_R2_R3_R4_R5
RET

ENCRYPT_KEY_R2_R3_R4_R5_INTO_R6_R7:
    MOV A, R2
    XRL A, #0FH
    MOV B, #010H
    MUL AB
    MOV R6, A

    MOV A, R3
    XRL A, #0FH
    MOV B, #010H
	ADD A, R6
    MOV R6, A

    MOV A, R4
    XRL A, #0FH
    MOV B, #010H
    MUL AB
    MOV R7, A

    MOV A, R5
    XRL A, #0FH
    MOV B, #010H
	ADD A, R7
    MOV R7, A
RET

DECRYPT_KEY_R6_R7_INTO_R2_R3_R4_R5:
    MOV A, R6
    XRL A, #0FFH
    MOV B, #010H
    DIV AB
    MOV R2, A
    MOV R3, B

    MOV A, R7
    XRL A, #0FFH
    MOV B, #010H
    DIV AB
    MOV R4, A
    MOV R5, B
RET

DISPLAY_R0:
	; --- display number/operator based on value in #TABLE
	MOV DPTR, #TABLE
	MOV A, R0
	MOVC A, @A+DPTR
	MOV P2, A
RET

END
