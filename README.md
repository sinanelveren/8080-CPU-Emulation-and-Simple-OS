# 8080-CPU-Emulation-and-Simple-OS


**8080 CPU Emulation and Simple OS**

* 8080Book.pdf : Good book on 8080 Assembly programming

* 8080_Z80 Instruction Set.pdf : reference for 8080 assembly programming



## OS Calls
**PRINT_B :** Prints the contents of register B on the screen as a decimal number.



**PRINT_MEM :** Prints the contents of the memory pointed by registers B and C as a decimal number.



**READ_B :** Reads an integer from the keyboard and puts it in register B.



**READ_MEM :** Reads an integer from the keyboard and puts it in the memory location pointed by registers B and C



**PRINT_STR :** Prints the null terminated string atthe memory location pointed by B and C



**READ_STR :** Reads the null terminated string from the keyboard and puts the result at the memory location pointed by B and C



**GET_RND :** Produces a random byte and puts in register B



**TCreate Register :** It works like the pthread_create call of UNIX systems. It returns the thread ID in register B on success. On fail, returns 0. After this call, a new thread is created and it starts running the function passed as parameter.



**TExit :** It works like the pthread_exit call of UNIX systems. It terminates the calling thread.



**TJoin :** Blocks the calling thread until the thread with thread ID is terminated.



**TYield :** Causes the calling thread to yield the CPU. The thread is placed at the end of the schedule queue.



**FileCreate :**  It works like the file create call of UNIX systems. On fail, returns 0 in register B. On success, it returns 1. There are no owners, no access permissions. 



**FileClose :** It works like the close call of UNIX systems. It closes the file. On fail, returns 0 in register B. On success, it returns 1.



**FileOpen :** It works like the file open call of UNIX systems. Itreturns the file handle ID in register B on success. On fail, returns 0. The file is always opened for read/write mode. There are no owners, the file pointer points to the beginning of the file.



**FileRead  :** It works like the read call of UNIX systems. It reads the file. On fail, returns 0 in register B. On success, it returns the number of bytes read. It advances the file pointer by the number of bytes read.



**FileWrite  :** It writes to the file. On fail, returns 0 in register B. On success, it returns the number of bytes written. It advances the file pointer by the number of bytes written. It append the file if needed.



**FileSeek  :** It moves the file pointer to the desired seek position. On fail, returns 0 in register B. On success it returns 1. DirRead Register A = 18, Register BC holds the adress of the buffer to write the directory information. We have a single directory in our system: Root. The information about the files will be read and will be put to the memory as a null terminated string.




 * **ASM Programs:**


1. PrintNumbers.asm: file that prints integers from 0 to 50 by steps of 2 on the screen. Each
number will be printed on a new line.
2. Sort.asm: file that produces 50 random bytes, sorts them in increasing order and prints them
on screen.
3. Binary Search.asm: Produces 50 random bytes and sorts them. Your program then take a
number from the keyboard, makes a binary search on these numbers. If found prints the
memory address else prints "error"
4. test.asm: a file that tests each of the system calls one by one.


5. F1: A function that prints numbers from 0 to 50
6. F2: A function that adds numbers from 1 to 1000 and prints the result
7. F3: A function that prints numbers from 50 to 100
8. F4: A function produces 50 random bytes, sorts them in increasing order and prints them on
screen
9. F5: A function that produces 50 random bytes and sorts them. Your function then searches
the 1st, 10th, and 40th bytes in the sorted array using binary search and prints the returned indexes

9. P1: A program that creates a file (file name is given from the keyboard) writes single byte
integers from 0 to 50 to this file and closes it.
10. P2: A program that opens a file (name is given from the keyboard) and reads all the numbers
from the file and prints them to the screen.
11. P3: A program that read the root directory and prints all the information to the screen.
12. P4: A program that opens a file, appends 10 numbers to the end of the file. These numbers
should be the continuation of the existing numbers.

**exe.mem** : write to file memory content
