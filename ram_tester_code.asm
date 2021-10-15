#make_bin#

; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.

; All directives are optional, if you don't need them, delete them.

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=0500h#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0500h#    ; same as loading segment
#IP=0000h#    ; same as loading offset

; set segment registers
#DS=0500h#    ; same as loading segment
#ES=0500h#    ; same as loading segment

; set stack
#SS=0500h#    ; same as loading segment
#SP=FFFEh#    ; set to top of loading segment

; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
PORTA1 equ 60h
PORTB1 equ 62h
PORTC1 equ 64h
COMPORT1 equ 66h
PORTA2 equ 70h
PORTB2 equ 72h
PORTC2 equ 74h
COMPORT2 equ 76h
PORTA3 equ 50h
PORTB3 equ 52h
PORTC3 equ 54h
COMPORT3 equ 56h





X1:    
	MOV AX, 0200H
	MOV DS, AX
	MOV ES, AX
	MOV SS, AX
	MOV SP, 0FFFEH

	MOV AL, 80H
	OUT COMPORT1, AL
	MOV AL, 80H
	OUT COMPORT3, AL
	MOV AL, 89H
	OUT COMPORT2,AL
	MOV AL, 0FFH
	OUT PORTA1, AL
	MOV AL, 0FFH
	OUT PORTB1, AL
	MOV AL, 0FFH
	OUT PORTC1, AL
	MOV AL, 0FFH
	OUT PORTC3, AL

X2: 
	IN AL, PORTC2
	AND AL, 01H
	CMP AL, 00H
	JNE X3
	JMP X2


X3: ; testing RAM
	TEST1:
		MOV BH, 00H         ; USED FOR WRITING ZEROES
		MOV BL, 01H         ; USED FOR WRITING ONES
		MOV DX, 0000H
		MOV SI, 2000H
	REPE1:
		MOV AH, 08H
	REPE2:
		MOV CH, BH
		CALL WRITE
		CALL READ
		AND AL, BL
		CMP AL, 00H
		JNZ FAIL
		MOV CH, BL
		CALL WRITE
		CALL READ
		AND AL, BL
		CMP AL, BL
		JNZ FAIL
		ROL BL, 01H
		DEC AH
		JNZ REPE2
		INC DX
		CMP DX, SI
		JNZ REPE1

PASS:
	MOV AL, 8CH
	OUT PORTA1, AL

	MOV AL, 88H
	OUT PORTB1, AL

	MOV AL, 92H
	OUT PORTC1, AL

	MOV AL, 92H
	OUT PORTC3, AL
	JMP X2

FAIL:
	MOV AL, 8EH
	OUT PORTA1, AL

	MOV AL, 88H
	OUT PORTB1, AL

	MOV AL, 0CFH
	OUT PORTC1, AL

	MOV AL, 0C7H
	OUT PORTC3, AL
	JMP X2


WRITE:
	MOV AL, 89H
	OUT COMPORT2, AL
	MOV AL, DL ; MOVE A0-A7
	OUT PORTA3, AL
	MOV AL, DH ; SET A8-A14
	OR AL, 40H
	OUT PORTB3, AL
	MOV AL, CH ; GET DATA TO BE WRITTEN
	OUT PORTB2, AL
	;CALL DELAY
RET

READ:
	MOV AL, DH ; SET A8-A14
	OR AL, 20H
	OUT PORTB3, AL
	MOV AL, 8BH
	OUT COMPORT2, AL
	MOV AL, DL ; SET A0-A7
	OUT PORTA3, AL
	IN AL, PORTB2
	;CALL DELAY
RET

DELAY:
	MOV CX, 01H
	W1:
		NOP
		LOOP W1
RET



HLT           ; halt!




