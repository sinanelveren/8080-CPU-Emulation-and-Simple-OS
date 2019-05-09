#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"

#define INPUT_BUFFER_SIZE 1000


uint64_t GTUOS::handleCall(const CPU8080 &CPU){

    if(CPU.state->a == 1 ){
        return PRINT_B(CPU);
    }
    if(CPU.state->a == 2 ){
        return PRINT_MEM(CPU);
    }
    if(CPU.state->a == 3 ){
        return READ_B(CPU);
    }
    if(CPU.state->a == 4 ){
        return READ_MEM(CPU);
    }
    if(CPU.state->a == 5 ){
        return PRINT_STR(CPU);
    }
    if(CPU.state->a == 6 ){
        return READ_STR(CPU);
    }
    if(CPU.state->a == 7 ){
        return GET_RND(CPU);
    }
	else {
		std::cout << "Unimplemented OS call";
		throw -1;
	}

}


/*handle of system call print_B*/
uint64_t GTUOS::PRINT_B(const CPU8080 & CPU) {                          //ok

    cout << (int) CPU.state->b <<  endl;                                //print the value
    return 10;
}


/*handle of system call print_MEM*/
uint64_t GTUOS::PRINT_MEM(const CPU8080 & CPU) {                        //ok

    // 16bit offset <- shift left 8 to most s. bit  | least bit
    uint16_t offset=(CPU.state->b << 8) | (CPU.state->c & 0xff);        //convert to 16 bit for find the offset

    std::cout <<  (int) CPU.memory->at(offset) << std::endl;            //print the value which address at

    return 10;       //number of cycles
}



/*handle of system call READ_B*/
uint64_t GTUOS::READ_B(const CPU8080 & CPU) {                           //ok
    int input = 0;
    cin >> input;                                                       //get input - read only 0-255

    if(input < 0)                                                       //don't show negative number
        input = -1 * input;
    CPU.state->b = input;                                               //store input to B

    return 10;     //number of cycles
}

/*handle of system call READ_MEM*/
uint64_t GTUOS::READ_MEM(const CPU8080 & CPU) {                         //ok
    int input = 0;
    cin >> input;                                                       //get input - read only 0-255

    // 16bit offset <- shift left 8 to most s. bit  | least bit
    uint16_t offset=(CPU.state->b << 8) | (CPU.state->c & 0xff);        //convert to 16 bit for find the offset

    CPU.memory->at(offset) = input;                                     //load the input value to memory shown offset

    return 10;     //number of cycles
}

/*handle of system call PRINT_STR*/
uint64_t GTUOS::PRINT_STR(const CPU8080 & CPU) {                        //ok
    uint16_t offset = (CPU.state->b << 8) | (CPU.state->c & 0xff);

    while (1) {
        if( (char)CPU.memory->at(offset) == '\0')                       //until end of string
            break;
        cout << (char) CPU.memory->at(offset);                          //print the string chararter by character
        offset++;                                                       //next character
    }

    return 100;     //number of cycles
}

/*handle of system call READ_STR*/
uint64_t GTUOS::READ_STR(const CPU8080 & CPU) {                         //ok

    char input[INPUT_BUFFER_SIZE];

    fgets(input, INPUT_BUFFER_SIZE, stdin);                             //read string as buffer_size as

    // 16bit offset <- shift left 8 to most s. bit  | least bit
    uint16_t offset=(CPU.state->b << 8) | (CPU.state->c & 0xff);        //convert to 16 bit for find the offset

    CPU.memory->at(offset) = input[0];                                  //load the input[0] value to memory shown offset


    for(int i = 0; input[i] != '\0'; ++i) {
        if(input[i] == '\n')
            break;
        CPU.memory->at(offset) = input[i];                              //load input content to memory until null char
        offset++;
    }
    CPU.memory->at(offset) = '\0';                                      //assign null character to know end of string

    return 100;     //number of cycles
}


/*handle of system call print_MEM*/
uint64_t GTUOS::GET_RND(const CPU8080 & CPU) {                          //ok
    srand (time(NULL));                                                 //initalize random seed

    static unsigned long x=123456789, y=362436069, z=521288629;

    //period 2^96-1
    unsigned long t;
    x ^= x << 16;
    x ^= x >> 5;
    x ^= x << 1;

    t = x;
    x = y;
    y = z;
    z = t ^ x ^ y;

    CPU.state->b = (rand() + z) % 127;                                        //random byte 0-255 (1 byte)

    return 5;       //number of cycles
}



bool GTUOS::writeToMemFile(const CPU8080 & CPU){

    FILE *memoryFile;

    memoryFile = fopen ("exe.mem","w");


    if(memoryFile == NULL) {
        printf("error: Couldn't create exe.mem");
        exit(1);
    }

    for(uint16_t i=0x0000; i <0xffff; i++) {
        fprintf(memoryFile, "0x%04x \t", i);     //opcode

        for(int j =0; j < 16; ++j) {
            fprintf(memoryFile, "%02X ", CPU.memory->at(i));    //16 byte at the one line
            ++i;
        }
        fprintf(memoryFile, "\n");
    }


    fclose(memoryFile);
}

