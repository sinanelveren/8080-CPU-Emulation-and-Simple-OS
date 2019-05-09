        ; 8080 assembler code
        .hexfile P2.hex
        .binfile P2.com
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
FileCreate 	equ 12
FileClose 	equ 13
FileOpen 	equ 14
FileRead 	equ 15
FileWrite	equ 16
FileSeek	equ 17
DirRead		equ 18


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

	;This program prints integers from 0 to 50 on fil sytem. The numbers is shown in hex representaion

fileName:dw 'newFile',00AH,00H ; null terminated string
askName:dw 'Enter a file name : ',00AH,00H ; null terminated string

readHere   equ 0600h
writeFrom  equ 0700h
writeHere   equ 0500h




begin:
	LXI SP,stack 		; always initialize the stack pointer
       

;;;;;P1 ;;;;;;;


			;write 50 bytes to mem
			;initalize and print to file	
	mvi H, 100	; init D with 100
	mvi C, 0	; C = 0
	LXI D, writeFrom

loop:
			; write C register's content to memory
	MOV A, C	; A = C
	STAX D		; MEM[D] = C
	INX D		; D = D + 2	; for next byte


	INR C		; C = C + 2
	INR C		; 
	MOV A, C
	CMP H		; C ?= D
	JNZ loop	; goto loop if C != 100






				;create ** file name into BX
	LXI B, fileName	; 	(second chance for file name)put the address of string in registers B and C
	MVI A, FileCreate	; store the OS call code to A
	call GTU_OS		; call the OS


	
				;;open file ** BC
	MVI A, FileOpen		; store the OS call code to A
	call GTU_OS		; call the OS

	
;;write 51 byte to fileHandle:E
	MVI D, 51
	MOV E, B	

	LXI B, writeFrom	;;read file **to  BC
	MVI A, FileWrite	; store the OS call code to A
	call GTU_OS		; call the OS

;;;;; END of P1 ;;;;;;;



;;;;; END of P2 ;;;;;;;

;;ask file name

				; ask to user for get input file name
	LXI B, askName		; put the address of string in registers B and C
	MVI A, PRINT_STR	; store the OS call code to A
	call GTU_OS		; call the OS
	

				;read file name from keyboard and put it in BC
	MVI A, READ_STR		; store the OS call code to A
	call GTU_OS		; call the OS


;;open file			;;open file ** BC
	
	MVI A, FileOpen		; store the OS call code to A
	call GTU_OS		; call the OS



;;READ FILE;;

	MVI D, 50		;bytes count
	MVI E, 1		;file handler into E

				;read file from fileSystem
	LXI B, writeFrom
	MVI A, FileRead		; store the OS call code to A
	call GTU_OS		; call the OS


;;Print from mem;;


			;write 50 bytes to mem
			;initalize and print to file	
	mvi H, 50	; init D with 100
	mvi L, 0	; C = 0
	LXI D, writeFrom

loopP:
			; write C register's content to memory
	
	LDAX D		;  
	MOV B, A	; B = MEM[D]
	INX D		; D = D + 2	; for next byte


			; print B 
	MVI A, PRINT_B	; store the OS call code to A to print the value of B
			; Now we will call the OS to print the value of sum
	call GTU_OS	; call the OS




	INR L		; C = C + 1
		; 
	MOV A, L
	CMP H		; C ?= D
	JNZ loopP	; goto loopP if C != 50




	
	hlt		; end program		







