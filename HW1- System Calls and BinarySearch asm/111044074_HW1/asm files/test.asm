        ; 8080 assembler code
        .hexfile test.hex
        .binfile test.com
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

	;This program will test all system call and shows clearly


infoSTR:dw '>> PRINT_STR : HAS BEEN TESTED!!',00AH,00H; null terminated string
readstr:dw '>> READ_STR : HAS BEEN TESTED!!',00AH,00H; null terminated string
infoRB:	dw '>> TEST : READ_B System Call (3) ',00AH,00H; null terminated string
infoRBM:dw '>> READ_B : HAS BEEN TESTED ',00AH,00H; null terminated string
infoRB2:dw '>> Enter a number to store your number in to reg B ',00AH,00H; null terminated string
infoRB3:dw '>> READ_MEM : HAS BEEN TESTED ',00AH,00H; null terminated string
infoB:	dw '>> PRINT_B : HAS BEEN TESTED ',00AH,00H; null terminated string
infoinp:dw '>> Your input is',00AH,00H; null terminated string
read:	dw 'Enter a integer for write to MEM(B&C) : ',00AH,00H ; null terminated string
infoBM:	dw '>> PRINT_MEM : HAS BEEN TESTED',00AH,00H; null terminated string
read2:	dw 'Enter a string for write to MEM(pointed by B&C) : ',00AH,00H ; null terminated string
write:	dw '  << was your input string ',00AH,00H ; null terminated string
rand:	dw 'Random Number is ',00AH,00H ; null terminated string
rand2:	dw '>> GET_RND : HAS BEEN TESTED ',00AH,00H; null terminated string

begin:
	LXI SP,stack 	; always initialize the stack pointer



;test READ_STR
;test PRINT_STR

			; ask to user for get input string
	LXI B, read2	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	

	MVI A, READ_STR	; store the OS call code to A to get input string
			; Now we will call the OS to store the string to memory where is pointing B&C 
	call GTU_OS	; call the OS
			; has been stored value in the memory where is point (B+C)


	MVI A, PRINT_STR; store the OS call code to A to print the string of memory(B+C)
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS

	

	
	LXI B, write	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

	
	LXI B, readstr	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS




;test PRINT_STR
			; show to user some info  about test - PRINT_STR call
	LXI B, infoSTR	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



; test READ_B
			; show to user some info  about test - READ_B call
	LXI B, infoRB	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

			; test READ_B
			; show to user some info  about test - READ_B call
	LXI B, infoRB2	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



; call READ_B
			; read a input and save it in to reg B
	MVI A, READ_B	; store the OS call code to A to print the value of B
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS
			; has been stored value in the memory where is point (B+C)
	
	MOV E, B	; save B
	

				; show to user some info  about test - READ_B tested info
	LXI B, infoRBM	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

	

	
			; show to user some info  about test - READ_B call
	LXI B, infoinp	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS


; test PRINT_B
	MOV B, E
			; print B to test it
	MVI A, PRINT_B	; store the OS call code to A to print the value of B
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS

	MOV E, B	; save B


			; show to user some info  about test - PRINT_B call
	LXI B, infoB	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



;test READ_MEM
			; ask to user for get input
	LXI B, read	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	
			
			;os call READ_MEM
	MVI A, READ_MEM	; store the OS call code to A to get input
			; Now we will call the OS to store the value of input
	call GTU_OS	; call the OS
			; has been stored value in the memory where is point (B+C)

	LDAX B
	MOV E, A	; save B

	
	
			; show to user some info  about test - PRINT_MEM call
	LXI B, infoRB3	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



; test PRINT_MEM
			; show to user some info  about test - PRINT_MEM
	LXI B, infoinp	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS


	MOV A, E
	STAX B
	
			; print_mem to test it
	MVI A, PRINT_MEM; store the OS call code to A to print the value of memory(B+C)
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS


			; show to user some info  about test - PRINT_MEM call
	LXI B, infoBM	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
		




;test GET_RND

			; show to user some info  about test - GET_RND call
	LXI B, rand	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS


	MVI A, GET_RND	; store the OS call code to A to generate random byte and assign it to B
			; Now we will call the OS to store generated byte to register B 
	call GTU_OS	; call the OS
			; has been stored value in the register B


			; print B to test it
	MVI A, PRINT_B	; store the OS call code to A to print the value of B
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS

			; show to user some info  about test - GET_RND call
	LXI B, rand2	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS
	
	hlt		; end program





