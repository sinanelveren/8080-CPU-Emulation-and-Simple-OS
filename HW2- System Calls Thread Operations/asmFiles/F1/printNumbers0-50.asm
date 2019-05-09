        ; 8080 assembler code
        .hexfile PrintNumbers50.hex
        .binfile PrintNumbers50.com
        ; try "hex" for downloading in hex format
        .download bin  
        .objcopy gobjcopy
        .postbuild echo "OK!"
        ;.nodump

	; OS call list
PRINT_B		equ 1
PRINT_MEM	equ 2
READ_B		equ 3
READ_MEM	equ 4
PRINT_STR	equ 5
READ_STR	equ 6
TCreate		equ 11
TExit		equ 8
TJoin		equ 9
TYield		equ 10

	; Position for stack pointer
stack   equ 0F000h

	org 000H
	jmp begin

	; Start of our Operating System
GTU_OS:	PUSH D
	push D
	push H
	push psw
	nop	; This is where we run our OS in C++, see the CPU8080::isSystemCall()
		; function for the detail.
	pop psw
	pop h
	pop d
	pop D
	ret
	; ---------------------------------------------------------------
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE        

	;This program prints integers from 0 to 50 on the screen. The numbers is shown line by line


begin:
	LXI SP,stack 	; always initialize the stack pointer
        mvi D, 51	; init D with 50
	mvi C, 0	; C = 0

loop:
			; print C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS



	INR C		; C = C + 1
	MOV A, C
	CMP D		; C ?= D
	JNZ loop	; goto loop if C != 50


	
	hlt		; end program



