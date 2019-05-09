#include <iostream>
#include <unistd.h>
#include "8080emuCPP.h"
#include "gtuos.h"
#include "memory.h"



// This is just a sample main function, you should rewrite this file to handle problems
	// with new multitasking and virtual memory additions.
int main (int argc, char**argv) {
    if (argc != 4) {
        std::cerr << "Usage: prog exeFile debugOption\n";
        exit(1);
    }
    int DEBUG = atoi(argv[3]);

    memory mem;
    CPU8080 theCPU(&mem);
    GTUOS theOS;
    int flag = 1;
    uint64_t totalCyclesCount = 0;

    theOS.setThread();
    theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);
    theOS.setFileSystem(argv[2]);


    do {
        //exute instruction
        totalCyclesCount += theCPU.Emulate8080p(DEBUG);

        if (DEBUG == 2) {
            if (flag == 1) {
                cout << " \n\nPress to Enter Key\n";
            }
            getchar();
            flag = 0;
            //write to file content memory
            theOS.writeToMemFile(theCPU);
        }


        if (theCPU.isSystemCall()) {
            //system call
            totalCyclesCount += theOS.handleCall(theCPU);

            if (DEBUG == 1) {
                theOS.printFileTable(theCPU);
                cout << " \n\nOS CALL! Press to Enter Key\n";
                getchar();

            }
        }


        if (theOS.roundRobinScheduler(totalCyclesCount, theCPU, 100/*quantumTime*/, DEBUG))
            break;

    } while (!theCPU.isHalted());

    if (DEBUG == 0 || DEBUG == 1 || DEBUG == 2 || DEBUG == 3) {
        theOS.writeToMemFile(theCPU);
        cout << endl << endl << "Memory has been written at the file named 'exe.mem'" ;
    }


    //close
    close(theOS.fd_fileSystem);


    cout << endl << "Total cycles count is " << totalCyclesCount << endl;
    return 0;

}



