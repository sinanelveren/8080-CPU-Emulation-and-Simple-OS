        ; 8080 assembler code
        .hexfile Question3.hex
        .binfile Question3.com
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

	; program that creates 10 threads with F3 (10 parallel threads). 
	; Waits until all of them done, then terminates
	; The program also prints them				

	; 
arr	equ 0500h


begin:
	LXI SP,stack 	; always initialize the stack pointer

	LXI H, arr	; H&L = arr  ;thread ID 's array starts at this location

	
	
	MVI E, 10	; init E with 10 for create 10 threads

loopCreate:
	DCR E

			;thread 1++ ID 2++
	LXI B, F3	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	
	MOV M, B	;store thread ID to mem location H++
	INX H


	MVI A,0
	CMP E
	JNZ loopCreate



			;wait all threads
	LXI H, arr	; H&L = arr  
	MVI E, 11	; init E with 10 for wait 10 threads created
	DCX H

loopJoin:
	DCR E
	
		;wait thread ID 2++ (first thread created)
	MOV B, M	
	MVI A, TJoin	;wait H++ (thread ID++)
	call GTU_OS
	
	INX H		;arr++


	MVI A,0
	CMP E
	JNZ loopJoin


	NOP
	NOP
	hlt		;end program

			


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








