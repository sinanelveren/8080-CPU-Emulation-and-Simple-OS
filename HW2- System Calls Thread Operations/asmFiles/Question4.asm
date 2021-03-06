        ; 8080 assembler code
        .hexfile Question4.hex
        .binfile Question4.com
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

	; A program that creates two parallel threads with F4 and F5.
	; Waits until all of them done, then terminates
	; The program also prints them				
	;sort subrutine in C:
	;for (int j = 1; j < size; j++)
	;	for (int i = 0; i <size - j; i++)
	;		if (a[i] > a[i +1])
	;			swap(a[i], a[i+1])				

info:	dw 'Random numbers has been generated.',00AH,00H ; null terminated string
info2:	dw 'The numbers has been sorted.',00AH,00H ; null terminated string
info3:	dw 'All threads has been exit succesfuly.',00AH,00H ; null terminated string
infoTarget:dw 'Target for search them 1st 10th 40th elements',00AH,00H ; null terminated string
infoEnd:dw 'Indexes is found.',00AH,00H ; null terminated string
	; Position for random numbers
arr	equ 0500h
	
arr2	equ 0600h ; Position for random numbers for f5
targets	equ 0400h ; keep bytes which will search for f5


begin:
	LXI SP,stack 	; always initialize the stack pointer



			;create thread 1 ID 2
	LXI B, F4	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	
	MOV D, B	;store thread ID to D



			;create thread 2 ID 3
	LXI B, F5	
	MVI A, TCreate	;store OScall code to A
	call GTU_OS	;call the OS
	
	MOV E, B	;store thread ID to D
	



			;wait all threads

			;wait thread ID 2
	MOV B, D	
	MVI A, TJoin	;wait D (thread ID 2)
	call GTU_OS
	
			;wait thread ID 3
	MOV B, E	
	MVI A, TJoin	;wait E (thread ID 3)
	call GTU_OS
	


			;;; show to user exit info 
	LXI B, info3	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

	NOP
	NOP
	hlt		;end program

			


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


F4:

        mvi C, 50	; init E with 50 ; counter up to zero
	LXI D, arr	; D&E = arr  ;array starts at this location

loop:
			; generate 50 random number and store them in arr location
	MVI A, GET_RND	; store the OS call code to A to generate random byte and assign it to B
			; Now we will call the OS to store generated byte to register B 
	call GTU_OS	; call the OS
			; has been stored value in the register B

			
	MOV A, B	; A = B
	STAX D		; MEM[D] = B
	INX D		; D = D + 2	; for next byte

	DCR C		; C = C - 1 ;counter
	JNZ loop	; goto loop if C!= 0

	
			;print screen to generated numbers
	MVI D, 50	;50
	LXI B, arr

writeArr:		; has been writting all random numbers
	MVI A, PRINT_MEM; store the OS call code to A for print B MEM
	call GTU_OS	; call the OS
	
	INX B		; B = B + 2 ;for next byte
	DCR D		; D = D - 1 ;counter
	JNZ writeArr	; goto loop if D != 0
	



			;;; show to user some info 
	LXI B, info	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS




	LXI H, arr	; H&D = mem(arr) 	source
;	LXI D, sortArr	; D&E = mem(sortArr)	destination

	MVI D, 0	;counter 2 = 0
	MVI C, 1	;counter 1 = 1
	

sortLoop:		;sort them
	LXI H, arr

	INR C		;c1 ++	
	MOV E, C
	MVI A, 50	;50
	SUB E		; Size - counter1 < 0 ? check counter 1 up to 50
	JM break 	; a ?< e   sign bit is 1


	MVI A, 51	;counter2 = 50-counter1 up to zero
	SUB C
	MOV D, A	;size-k counter2

;	
innloop:
	MOV E, D	; E = D
	MVI A, 0	; A = 0
	SUB E		; A = A - E
	JZ sortLoop	; if (A < = 0) jump sortLoop
		
	DCR D		;c2--	
	
			;;TEST for in for
;MOV B,C
;MVI A, PRINT_B; store the OS call code to A for print B MEM
;call GTU_OS	; call the OS
;MOV B,D
;MVI A, PRINT_B; store the OS call code to A for print B MEM
;call GTU_OS	; call the OS
			;;END TEST for in for

	MOV B, M	; first
	INX H		; next byte HL = hL + 1
	
	MOV E, B	; first
	SUB A
	MOV A, M	; second : read from memory B = mem(H&L)
	
	CMP E		;a ?< b	swap ; will be incr order
	JZ back
	JC swap
back:
	JMP innloop

swap:

	MOV A, M	; exchange 
	DCX H
	MOV B, M
	
	MOV M, A	
	INX H
	MOV M, B
;MOV B, A
;MVI A, PRINT_B; store the OS call code to A for print B MEM
;call GTU_OS	; call the OS	
;MOV B, E
;MVI A, PRINT_B; store the OS call code to A for print B MEM
;call GTU_OS	; call the OS

	JMP back


break:


	
	MVI D, 50	;50
	LXI B, arr
loopWrite:
			;show all sorted data
	MVI A, PRINT_MEM; store the OS call code to A for print B MEM
	call GTU_OS	; call the OS
	
	INX B		; B = B + 2 ;for next byte
	DCR D		; D = D - 1 ;counter
	JNZ loopWrite	; goto loop if D != 0
	


			;;; show to user some info 
	LXI B, info2	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



	
			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F5:

        mvi C, 50	; init E with 50 ; counter up to zero
	LXI D, arr2	; D&E = arr  ;array starts at this location

loopGenerate2:
			; generate 50 random number and store them in arr location
	MVI A, GET_RND	; store the OS call code to A to generate random byte and assign it to B
			; Now we will call the OS to store generated byte to register B 
	call GTU_OS	; call the OS
			; has been stored value in the register B

			
	MOV A, B	; A = B
	STAX D		; MEM[D] = B
	INX D		; D = D + 2	; for next byte

	DCR C		; C = C - 1 ;counter
	JNZ loopGenerate2; goto loopGenerate if C!= 0

	
			;print screen to generated numbers
	MVI D, 50	;50
	LXI B, arr2

writeArr2:		; has been writting all random numbers
	MVI A, PRINT_MEM; store the OS call code to A for print B MEM
	call GTU_OS	; call the OS
	
	INX B		; B = B + 2 ;for next byte
	DCR D		; D = D - 1 ;counter
	JNZ writeArr2	; goto loop if D != 0
	



			;;; show to user some info 
	LXI B, info	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS

			;save 1 st , 10 th , and 40 th bytes into arr2
	LXI H, arr2
	LXI D, targets
	;
	mvi C, 0	; init C with 0

loopTarget2
	INR C

	MVI A, 1
	CMP C		; C ?= A
	JZ target2	; goto loop if C == target index

	MVI A, 10
	CMP C		; C ?= A
	JZ target2	; goto loop if C == target index

	MVI A, 40
	CMP C		; C ?= A
	JZ target2	; goto loop if C == target index

	INX H		;arr ++

	MVI A, 50
	CMP C		; C ?= D
	JNZ loopTarget2	; goto loop if C != 50
	
	JMP startSort2

target2:
			; print C register's content
	MOV B, M	; B = H
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS
	MOV A, M
	STAX D		;save the 1st target
	INX D		; targets++
	INX H		; arr++
	JMP loopTarget2
	



startSort2:

			;;; show to user some info 
	LXI B, infoTarget; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS




	LXI H, arr2	; H&D = mem(arr) 	source


	MVI D, 0	;counter 2 = 0
	MVI C, 1	;counter 1 = 1
	

sortLoop2:		;sort them
	LXI H, arr2

	INR C		;c1 ++	
	MOV E, C
	MVI A, 50	;50
	SUB E		; Size - counter1 < 0 ? check counter 1 up to 50
	JM break2 	; a ?< e   sign bit is 1


	MVI A, 51	;counter2 = 50-counter1 up to zero
	SUB C
	MOV D, A	;size-k counter2

;	
innLoop2:
	MOV E, D	; E = D
	MVI A, 0	; A = 0
	SUB E		; A = A - E
	JZ sortLoop2	; if (A < = 0) jump sortLoop
		
	DCR D		;c2--	
	

			;;END TEST for in for

	MOV B, M	; first
	INX H		; next byte HL = hL + 1
	
	MOV E, B	; first
	SUB A
	MOV A, M	; second : read from memory B = mem(H&L)
	
	CMP E		;a ?< b	swap ; will be sort incr order
	JZ  back2
	JC swap2	

back2:
	JMP innLoop2

swap2:

	MOV A, M	; exchange 
	DCX H
	MOV B, M
	
	MOV M, A	
	INX H
	MOV M, B


	JMP back2


break2:


	
	MVI D, 50	;50
	LXI B, arr2
loopWrite2:
			;show all sorted data
	MVI A, PRINT_MEM; store the OS call code to A for print B MEM
	call GTU_OS	; call the OS
	
	INX B		; B = B + 2 ;for next byte
	DCR D		; D = D - 1 ;counter
	JNZ loopWrite2	; goto loopWrite if D != 0
	


			;;; show to user some info 
	LXI B, info2	; put the address of string in registers B and C
	MVI A, PRINT_STR; store the OS call code to A
	call GTU_OS	; call the OS



			 
searchBinary:
	LXI D, targets
	LDAX D	
	MOV C, A	;c = target
	

	MVI D, 0	;LOW
	MVI E, 50	;HIGH

while:
	MOV A, E
	SUB D		;low < high	loopsearch
	JP loopSearch
	JZ loopSearch
	JMP notFound

loopSearch:


	MOV A, E	;high - low
	SUB D
	RAR		;rotate right
	ANI 7Fh		;AND 0111 1111
	ADD D		;middle += low
	MOV B, A	; middle = low + (high - low)/2; 

	JMP compare


;b middle, c target, d low, e high , HL arr
compare:


	MOV A, B	;A = middle
	LXI H, arr2
	DCX H		;arr --
loopComp:
	INX H		;first element at the first loop . arr++
	
			
	DCR A		; A--
	JNZ loopComp	; goto loop if A != 0

	MOV A, M
	SUB C		;middle ?< target compare ;found less big
	JZ  found	
	JP  less	
	JM  big	



less:
	MOV A, B
	SUI 1		;middle = middle - 1
	MOV E, A
	
	JMP while

big:
	MOV A, B
	ADI 1		;middle = middle + 1
	MOV D, A

	JMP while

notFound:
	MVI B, 0
found:	
	MVI A, PRINT_B; store the OS call code to A for print B MEM
	call GTU_OS	; call the OS

		;search again for second and third target
	

	LXI D, targets




	INX D		; shift left(all target array) for try 3 elements
	LDAX D
	DCX D
	STAX D
	INX D
	INX D
	LDAX D
	DCX D
	STAX D

	INX D
	INX D
	LDAX D
	DCX D
	STAX D

	LXI D, targets
	LDAX D
	MOV C, A
	MVI A,0
	CMP C	
	JZ exit		;searched 3 elements until target 0


	JMP searchBinary

exit:


			 ;;; show to user some info 
	LXI B, infoEnd; put the address of string in registers B and C
	MVI A, PRINT_STR ; store the OS call code to A
	call GTU_OS	 ; call the OS



	
			;Exit thread
	MVI A, TExit	;store OScall code to A
	call GTU_OS	;call the OS











