        ; 8080 assembler code
        .hexfile inputMemStr.hex
        .binfile inputMemStr.com
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

	;This program will get string input from user, and shows it
	;input. The input is also printed on the screen.


read:	dw 'Enter a string for write to MEM(pointed by B&C) : ',00AH,00H ; null terminated string
endline:dw ' ',00AH,00H ; null terminated string
write:	dw 'was your input string ',00AH,00H ; null terminated string
begin:
	LXI SP,stack 	; always initialize the stack pointer

			; ask to user for get input string
	LXI B, read	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	

	MVI A, READ_STR	; store the OS call code to A to get input string
			; Now we will call the OS to store the string to memory where is pointing B&C 
	call GTU_OS	; call the OS
			; has been stored value in the memory where is point (B+C)


	MVI A, PRINT_STR; store the OS call code to A to print the string of memory(B+C)
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS


			; show to user some info 
	LXI B, endline	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

	LXI B, write	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	hlt		; end program
