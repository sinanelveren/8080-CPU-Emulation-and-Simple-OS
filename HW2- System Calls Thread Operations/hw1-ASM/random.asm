        ; 8080 assembler code
        .hexfile random.hex
        .binfile random.com
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

	;This program will generate random byte, and The byte is stored at B register
	;randombyte. The random byte is also printed on the screen.


info:	dw 'Random byte has been generated succesfuly ',00AH,00H ; null terminated string
endline:dw ' ',00AH,00H ; null terminated string

begin:
	LXI SP,stack 	; always initialize the stack pointer

			
	MVI A, GET_RND	; store the OS call code to A to generate random byte and assign it to B
			; Now we will call the OS to store generated byte to register B 
	call GTU_OS	; call the OS
			; has been stored value in the register B

			; print the random byte
	MVI A, PRINT_B	; store the OS call code to A to print the value of B
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS


			; show to user some info 
	LXI B, info	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	
	hlt		; end program
