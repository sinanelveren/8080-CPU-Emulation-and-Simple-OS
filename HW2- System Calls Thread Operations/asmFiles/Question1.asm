        ; 8080 assembler code
        .hexfile Question1.hex
        .binfile Question1.com
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

	; program that creates a thread with F1, waits until it is done, then creates another thread F2, 
	; waits until it is done, then creates another thread with F3, then ends the program.
	; The program also prints them				

info:	dw 'Random numbers has been generated.',00AH,00H ; null terminated string
info2:	dw 'The numbers has been sorted.',00AH,00H ; null terminated string
newline dw ' ',00AH,00H ; null terminated string

	; Position for random numbers
arr	equ 0500h


begin:
	LXI SP,stack 	; always initialize the stack pointer
	
	LXI B, F1	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	MOV M, B
	
	MOV B, M	
	MVI A, TJoin	;wait B (thread ID)
	call GTU_OS

			;new line print
	LXI B, newline	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS


	LXI B, F2	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	MOV M, B

	MOV B, M		
	MVI A, TJoin	;wait B (thread ID)
	call GTU_OS

			;new line print
	LXI B, newline	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS


	LXI B, F3	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	MOV M, B
	
	MOV B, M	
	MVI A, TJoin	;wait B (thread ID)
	call GTU_OS


	hlt		;end program


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F1:			;print numbers from 0 to 50

        mvi D, 51	; init D with 51
	mvi C, 0	; C = 0

loopf1:
			; print C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS


	INR C		; C = C + 1
	MOV A, C
	CMP D		; C ?= D
	JNZ loopf1	; goto loop if C != 50



			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F2:			;add numbers from 0 to 100 and print result, unimplemented function


	MVI B, 255	; 
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS	
		
			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F3:			;prints numbers from 50 to 100

        mvi D, 101	; init D with 101
	mvi C, 50	; C = 50

loopf3:
			; print C register's content
	MOV B, C	; B = C
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS


	INR C		; C = C + 1
	MOV A, C
	CMP D		; C ?= D
	JNZ loopf3	; goto loop if C != 100



			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS








