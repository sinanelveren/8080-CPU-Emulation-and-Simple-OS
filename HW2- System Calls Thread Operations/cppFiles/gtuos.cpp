#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"

#include <bitset>
#define INPUT_BUFFER_SIZE 1000


uint64_t GTUOS::handleCall(const CPU8080 &CPU){

    if(CPU.state->a == 1){
        return PRINT_B(CPU);
    }
    if(CPU.state->a == 2){
        return PRINT_MEM(CPU);
    }
    if(CPU.state->a == 3){
        return READ_B(CPU);
    }
    if(CPU.state->a == 4){
        return READ_MEM(CPU);
    }
    if(CPU.state->a == 5){
        return PRINT_STR(CPU);
    }
    if(CPU.state->a == 6){
        return READ_STR(CPU);
    }
    if(CPU.state->a == 7){
        return GET_RND(CPU);
    }
	 if(CPU.state->a ==11){
        return TCreate(CPU);
    }
	 if(CPU.state->a == 8){
        return TExit(CPU);
    }
	 if(CPU.state->a == 9){
        return TJoin(CPU);
    }
	 if(CPU.state->a == 10){
        return TYield(CPU);
    }
	else {
		std::cout << "Unsupported OS call";
		throw -1;
	}

}




/*handle of system call print_B*/
uint64_t GTUOS::PRINT_B(const CPU8080 & CPU) {                          //ok

    cout << (int) CPU.state->b <<  " ";                                //print the value
    return 10;
}


/*handle of system call print_MEM*/
uint64_t GTUOS::PRINT_MEM(const CPU8080 & CPU) {                        //ok

    // 16bit offset <- shift left 8 to most s. bit  | least bit
    uint16_t offset=(CPU.state->b << 8) | (CPU.state->c & 0xff);        //convert to 16 bit for find the offset

    std::cout <<  (int) CPU.memory->at(offset) << " ";            //print the value which address at

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
    cout << endl;
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

    CPU.state->b = ((rand() + z) % 254) + 1;                           //random byte 1-255 (1 byte)

    return 5;       //number of cycles
}


/* Write memory content to mem file as hex values */
bool GTUOS::writeToMemFile(const CPU8080 & CPU){

    FILE *memoryFile;

    memoryFile = fopen ("exe.mem","w");


    if(memoryFile == NULL) {
        printf("error: Couldn't create exe.mem");
        exit(1);
    }

    for(uint32_t i=0x0000; i <= 0xffff;  ) {
        fprintf(memoryFile, "0x%04x \t", i);     //opcode

        for(int j =0; j < 16; ++j) {
            fprintf(memoryFile, "%02X ", CPU.memory->at(i));    //16 byte at the one line
            i++;
        }
        fprintf(memoryFile, "\n");
    }

    fclose(memoryFile);
}


/* * * * * * * * * * **  **  * * * * * * * * * Homework 2 * ** * * ** *  * ** * * * * * * * * * * * ** * *  ** * * ** */


/*main thread with initial value*/
void GTUOS::setThread(){
    setStack();
    setThreadID();
    setTimeClockTotal(0);
    setTimeClockPerThread(0);

    ThreadTable threadTable;

    threadTable.threadID =  generateThreadID();
    threadTable.timeClock = 0;
    threadTable.timeClockTotal = 0;
    threadTable.timeClockStarting = 0;          //getTimeClockTotal
    threadTable.stateOf = RUN;
    threadTable.startingAddress = 0;
    threadTable.emptyStack = 0x32;
    threadTable.waitID = 0;
    threadTable.isExit = 0;
    threadTable.isYield = 0;

    this->threadTableList.push_back(threadTable);
}
/*set stack*/
void GTUOS::setStack() {
    this->stack_ = 0xF000;      //start from 0xF000
}


/*generate new stack*/
uint16_t GTUOS::generateStack() {
    this->stack_ = this->stack_ + 0x0050;
    return this->stack_;
}

/*set threadID*/
void GTUOS::setThreadID() {
    this->threadID = 0x00;      //start from 0 than first main thread id is 1
}


/*generate new threadID*/
uint16_t GTUOS::generateThreadID() {
    this->threadID = this->threadID + 0x0001;
    return this->threadID;
}


/*Create a thread. It returns the thread ID in register B on success. On fail, returns 0.*/
uint64_t GTUOS::TCreate(const CPU8080 & CPU){
    ThreadTable     threadTable;

    //load the initial value into new thread
    threadTable.state.sp = generateStack();
    threadTable.threadID = generateThreadID();
    threadTable.timeClock = 0;
    threadTable.timeClockTotal = 0;
    threadTable.timeClockStarting = getTimeClockTotal();
    threadTable.stateOf = READY;
    threadTable.state.pc = (CPU.state->b << 8) | (CPU.state->c & 0xff);        //convert to 16 bit for pc
    threadTable.startingAddress = threadTable.state.pc;
    threadTable.emptyStack = 0x32;
    threadTable.waitID = 0;
    threadTable.isExit = 0;
    threadTable.isYield = 0;



    //if there are any error while create new thread. (stack full)(thread id full)
    if (threadTable.state.sp > 0xF700 || threadTable.threadID > 0x32) {     //if thread it > 50  or sp > f700
        CPU.state->b = 0;
        return 80;
    }

    if(this->threadTableList.size() == 1)               //now, there are multi thread
        this->threadTableList.front().timeClock = 0;    //then make 0 to first thread's clock


    this->threadTableList.push_back(threadTable);

    //return value
    CPU.state->b = threadTable.threadID;

    return 80;
}

/*pthread_exit, It terminates the calling thread.*/
uint64_t GTUOS::TExit(const CPU8080 & CPU){

    this->threadTableList.front().isExit = 1;

    //return value into reg B (exit status)
    CPU.state->b = 1;

    return 50;
}

/*Blocks the calling thread until the thread with thread ID is terminated*/
uint64_t GTUOS::TJoin(const CPU8080 & CPU){
    uint16_t waitID = (uint16_t) CPU.state->b;

    this->threadTableList.front().stateOf = BLOCK;
    this->threadTableList.front().waitID = waitID;

    return 40;
}

/*Causes the calling thread to yield the CPU. Thethread is placed at the end of the schedule queue*/
uint64_t GTUOS::TYield(const CPU8080 & CPU){
    this->threadTableList.front().isYield = 1;
    return 40;
}


void GTUOS::setTimeClockTotal(uint64_t timeClock) {
    this->timeClockTotal = timeClock;
}

void GTUOS::setTimeClockPerThread(uint64_t timeClock) {
    this->timeClockTotal = timeClock;
}


uint64_t GTUOS::getTimeClockTotal(){
    return this->timeClockTotal;
}

vector<ThreadTable> GTUOS::getThreadTableList() {
    return this->threadTableList;
}



/*load thread table to active thread table*/
void GTUOS::loadCurrentThreadTable(CPU8080 & CPU) {

    CPU.state->a = this->threadTableList.front().state.a;
    CPU.state->b = this->threadTableList.front().state.b;
    CPU.state->c = this->threadTableList.front().state.c;
    CPU.state->d = this->threadTableList.front().state.d;
    CPU.state->e = this->threadTableList.front().state.e;
    CPU.state->h = this->threadTableList.front().state.h;
    CPU.state->l = this->threadTableList.front().state.l;
    CPU.state->pc = this->threadTableList.front().state.pc;
    CPU.state->sp = this->threadTableList.front().state.sp;
    //  CPU.state->a = this->threadTableList.front().state.** memory;
    CPU.state->int_enable = this->threadTableList.front().state.int_enable;

    CPU.state->cc.cy = this->threadTableList.front().cc.cy;
    CPU.state->cc.pad = this->threadTableList.front().cc.pad;
    CPU.state->cc.p = this->threadTableList.front().cc.p;
    CPU.state->cc.pad2 = this->threadTableList.front().cc.pad2;
    CPU.state->cc.ac = this->threadTableList.front().cc.ac;
    CPU.state->cc.pad3 = this->threadTableList.front().cc.pad3;
    CPU.state->cc.z = this->threadTableList.front().cc.z;
    CPU.state->cc.s = this->threadTableList.front().cc.s;
}



/*Copy thread table to end of tables list*/
void GTUOS::saveCurrentThreadTable(const CPU8080 & CPU) {
    ThreadTable threadTable;

    threadTable.state.a = CPU.state->a;
    threadTable.state.b = CPU.state->b;
    threadTable.state.c = CPU.state->c;
    threadTable.state.d = CPU.state->d;
    threadTable.state.e = CPU.state->e;
    threadTable.state.h = CPU.state->h;
    threadTable.state.l = CPU.state->l;
    threadTable.state.sp = CPU.state->sp;
    threadTable.state.pc = CPU.state->pc;
    threadTable.state.int_enable = CPU.state->int_enable;
    threadTable.cc.cy = CPU.state->cc.cy;
    threadTable.cc.pad = CPU.state->cc.pad;
    threadTable.cc.p = CPU.state->cc.p;
    threadTable.cc.pad2 = CPU.state->cc.pad2;
    threadTable.cc.pad3 = CPU.state->cc.pad3;
    threadTable.cc.ac = CPU.state->cc.ac;
    threadTable.cc.z = CPU.state->cc.z;
    threadTable.cc.s = CPU.state->cc.s;

    threadTable.threadID =  this->threadTableList.front().threadID;
    threadTable.timeClock = 0;            //reset time clock of firts thread
    threadTable.timeClockTotal = this->threadTableList.front().timeClockTotal;
    threadTable.timeClockStarting = this->threadTableList.front().timeClockStarting;
    threadTable.startingAddress = this->threadTableList.front().startingAddress;
    threadTable.emptyStack = this->threadTableList.front().emptyStack;
    threadTable.waitID = this->threadTableList.front().waitID;
    threadTable.isExit = this->threadTableList.front().isExit;
    threadTable.isYield = this->threadTableList.front().isYield;

    this->threadTableList.push_back(threadTable);
}


/*round robin scheduler as parameter that quantum time*/
int GTUOS::roundRobinScheduler(uint64_t timeClock, CPU8080 & CPU, uint64_t quantumTime, int debug) {
    //save the thread 1's time clock (current total - old total)
    this->threadTableList.front().timeClock += timeClock - getTimeClockTotal();
    this->threadTableList.front().timeClockTotal += timeClock - getTimeClockTotal();

    //refresh to cycles count
    setTimeClockTotal(timeClock);

    //update stack pointer & available empt stack
    if(CPU.state->sp < this->threadTableList.front().state.sp){
        this->threadTableList.front().emptyStack -= 2;
        this->threadTableList.front().state.sp = CPU.state->sp;
    }
    if(CPU.state->sp > this->threadTableList.front().state.sp){
        this->threadTableList.front().emptyStack += 2;
        this->threadTableList.front().state.sp = CPU.state->sp;
    }

    //if there are any exit, erase it
    if(this->threadTableList.front().isExit == 1) {

        this->threadTableList.at(1).stateOf = RUN;
        if(debug == 2) {
            cout << endl << "Thread ID " <<this->threadTableList.front().threadID << " exit" << endl << endl;
            printInfo();
        }
        if(debug == 3) {
            cout << endl << "Thread ID " <<this->threadTableList.front().threadID << " exit"<< endl << endl;
            printThreadsInfo();
        }

        this->threadTableList.erase(this->threadTableList.begin());

        loadCurrentThreadTable(CPU);
        return 0;
    }


    if (this->threadTableList.size() == 0) {
        printf("\n Exit value : %X", CPU.state->b);
        return 1;
    }
    //if there are NOT only main thread
    if (this->threadTableList.size() > 1) {
        //process switch if the thread's time is over
        if (this->threadTableList.front().timeClock >= quantumTime || this->threadTableList.front().isYield == 1) {
            //only one time -yield
            this->threadTableList.front().isYield = 0;
            //reloade cycle count of thread - quantum time
            //this thread will be push to back and old one(front) will be erase.
            saveCurrentThreadTable(CPU);
            this->threadTableList.back().stateOf = READY;
            if(this->threadTableList.at(1).stateOf != BLOCK)
                this->threadTableList.at(1).stateOf = RUN;

            if(debug == 2)
                printInfo();
            if(debug == 3)
                printThreadsInfo();

            this->threadTableList.erase(this->threadTableList.begin());

            loadCurrentThreadTable(CPU);

        }
    }

    if(this->threadTableList.front().stateOf == BLOCK) {
        for (int i = 1; i < this->threadTableList.size() ; ++i) {
            //will still wait and blocked
            if (this->threadTableList.front().waitID == this->threadTableList.at(i).threadID) {
                while (this->threadTableList.front().stateOf == BLOCK) {
                    saveCurrentThreadTable(CPU);
                    this->threadTableList.back().stateOf = BLOCK;
                    if (this->threadTableList.at(1).stateOf != BLOCK)
                        this->threadTableList.at(1).stateOf = RUN;
                    if(debug == 2)
                        printInfo();
                    if(debug == 3)
                        printThreadsInfo();

                    this->threadTableList.erase(this->threadTableList.begin());

                    loadCurrentThreadTable(CPU);

                    return 0;
                }
            }
        }
        this->threadTableList.front().waitID = 0;
        this->threadTableList.front().stateOf = RUN;
    }

    return 0;
}

/*print information of threads*/
void GTUOS::printInfo() {
    //info of blocked thread
    cout << endl << endl<< "Thread ID(blocked): "<< threadTableList.back().threadID;
    printf("\tSTACK: %04X", threadTableList.back().state.sp);
    cout<< " \tPC: " << threadTableList.back().state.pc ;
    cout << "\tStarting time : " << threadTableList.back().timeClockStarting;
    cout << "\tTotal time : " << threadTableList.back().timeClockTotal;
    cout << "\tQuanta time : " << threadTableList.front().timeClock << endl;
    cout <<"StateOf [r/b/R]: " << threadTableList.back().stateOf;
    cout << "\tStartAdd: " << threadTableList.back().startingAddress<< endl << endl;

    //info of running thread
    cout << "Thread ID(running): "<< threadTableList.at(1).threadID;
    printf("\tSTACK: %04X", threadTableList.at(1).state.sp);
    cout << " \tPC: " << threadTableList.at(1).state.pc ;
    cout << "\tStarting time : " << threadTableList.at(1).timeClockStarting;
    cout << "\tTotal time : " << threadTableList.at(1).timeClockTotal;
    cout << "\tQuanta time : " << threadTableList.at(1).timeClock << endl;
    cout <<"StateOf [r/b/R]: " << threadTableList.at(1).stateOf;
    cout << "\tStartAdd: " << threadTableList.at(1).startingAddress<< endl << endl;

}


void GTUOS::printThreadsInfo(){
    cout << "Thread ID \tWaitID \tState \tSP \tEmptStack \tStartingAdd \tPC \tStartinTime \tTotalTime \tQuantaTime "
         << "\tA   B   C   D   E   H   L\n";

    for (int i = 1; i < this->threadTableList.size(); ++i) {
        cout << "       " << this->threadTableList.at(i).threadID << "\t"
             << this->threadTableList.at(i).waitID << " \t"
             << this->threadTableList.at(i).stateOf << " \t";
        printf("%04X\t", this->threadTableList.at(i).state.sp);
        cout << this->threadTableList.at(i).emptyStack << "\t\t"
             << this->threadTableList.at(i).startingAddress<< "\t\t"
             << this->threadTableList.at(i).state.pc << " \t"
             << this->threadTableList.at(i).timeClockStarting << " \t\t"
             << this->threadTableList.at(i).timeClockTotal << " \t\t";
        if(i == this->threadTableList.size() -1)
            cout << this->threadTableList.at(0).timeClock << " \t";
        else
            cout << this->threadTableList.at(i).timeClock << " \t";

        printf("\t$%02x $%02x $%02x $%02x $%02x $%02x $%02x \n",
               this->threadTableList.at(i).state.a, this->threadTableList.at(i).state.b,
               this->threadTableList.at(i).state.c, this->threadTableList.at(i).state.d,
               this->threadTableList.at(i).state.e, this->threadTableList.at(i).state.h,
               this->threadTableList.at(i).state.l);
    }
}