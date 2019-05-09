# 8080-CPU-Emulation-and-Simple-OS


##8080 CPU Emulation and Simple OS

8080Book.pdf : Good book on 8080 Assembly programming
8080_Z80 Instruction Set.pdf : reference for 8080 assembly programming


PRINT_B 
Prints the contents of register B on the screen as a decimal number.


PRINT_MEM  
Prints the contents of the memory pointed by registers B and C as a decimal number.


READ_B 
Reads an integer from the keyboard and puts it in register B.


READ_MEM 
Reads an integer from the keyboard and puts it in the memory location pointed by registers B and C


PRINT_STR 
Prints the null terminated string atthe memory location pointed by B and C


READ_STR 
Reads the null terminated string from the keyboard and puts the result at the memory location pointed by B and C


GET_RND
Produces a random byte and puts in register B


1. PrintNumbers.asm: file that prints integers from 0 to 50 by steps of 2 on the screen. Each
number will be printed on a new line.
2. Sort.asm: file that produces 50 random bytes, sorts them in increasing order and prints them
on screen.
3. Binary Search.asm: Produces 50 random bytes and sorts them. Your program then take a
number from the keyboard, makes a binary search on these numbers. If found prints the
memory address else prints "error"
4. test.asm: a file that tests each of the system calls one by one.
