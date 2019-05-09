        ; 8080 assembler code
        .hexfile Question5.hex
        .binfile Question5.com
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
GET_RND		equ 7
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

	; F1 and F3 so that they call TYield at every loop iteration. Then write a program that
	; creates parallel threads with F1 and F3. Waits until all of them done, then terminates
	; The program also prints them				



begin:
	LXI SP,stack 	; always initialize the stack pointer
	
	LXI B, F1	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	
	MOV D, B
	

	LXI B, F3	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS

	MOV E, B


	MOV B, D	
	MVI A, TJoin	;wait D (thread ID 2)
	call GTU_OS

	
	MOV B, E	
	MVI A, TJoin	;wait E (thread ID 3)
	call GTU_OS


	hlt		;end program


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F1:			;print numbers from 0 to 50

        mvi D, 50	; init D with 50
	mvi C, 0	; C = 0

loopf1:
	MVI A, TYield	;release the cpu
	call GTU_OS

			; print C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS


	INR C		; C = C + 1
	MOV A, C
	CMP D		; C ?= D
	JNZ loopf1	; goto loop if C != 50

			; print last C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS

			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F3:			;prints numbers from 50 to 100

        mvi D, 100	; init D with 100
	mvi C, 50	; C = 50

loopf3:
	MVI A, TYield	;release the cpu
	call GTU_OS
	
			; print C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS


	INR C		; C = C + 1
	MOV A, C
	CMP D		; C ?= D
	JNZ loopf3	; goto loop if C != 100

			; print last C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS
	

			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS








