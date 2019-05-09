#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"
#include <vector>

#define READY 'r'
#define BLOCK 'b'
#define RUN	'R'
#define BLOCK_SIZE 256
#define MAX_FILENAME 256
#define MAX_BLOCK_SIZE 4096		//256 * 4096 bytes = 1 mb


using namespace std;

//Some code cares that these flags are in exact
// right bits when.  For instance, some code
// "pops" values into the PSW that they didn't push.
//
typedef struct CC{
	uint8_t		cy:1;
	uint8_t		pad:1;
	uint8_t		p:1;
	uint8_t		pad2:1;
	uint8_t		ac:1;
	uint8_t		pad3:1;
	uint8_t		z:1;
	uint8_t		s:1;
} CC;


typedef struct State {
	uint8_t		a;
	uint8_t		b;
	uint8_t		c;
	uint8_t		d;
	uint8_t		e;
	uint8_t		h;
	uint8_t		l;
	uint16_t	sp;
	uint16_t	pc;
//	uint8_t		*memory;
	uint8_t		int_enable;
} State;

typedef struct ThreadTable {
	struct State 	state;
	struct CC 		cc;
	uint16_t 		threadID;			//thread ID starting from 1
	uint64_t 		timeClock;			//quanta time for each thread
	uint64_t 		timeClockTotal;		//cycles the thread has used so far
	uint64_t 		timeClockStarting;	//Starting time of thread
	char		 	stateOf;			//ready(1), blocked(2), running(3)
	uint16_t 		startingAddress;	//starting address of the memory location
	uint16_t 		emptyStack;			//Available empty stack space
	uint16_t 		waitID;
	uint16_t 		isExit;
	uint16_t 		isYield;
} ThreadTable;




typedef struct FileTable {
	char 	name[32];							//32bytes
	int 	block;								//4bytes
	char 	lastAccess[32];						//32bytes
	char 	lastModification[32];				//32bytes
	char 	content[148];						//152bytes
	int 	size;								//4bytes
	int 	seek;								//4bytes
}FileTable;							//256bytes BLOCK SIZE





class GTUOS {
	public:
		uint64_t handleCall(const CPU8080 & CPU);

        uint64_t PRINT_B(const CPU8080 & CPU); 		//OK OK -

        uint64_t PRINT_MEM(const CPU8080 & CPU); 	//OK OK -

        uint64_t READ_B(const CPU8080 & CPU); 		//OK OK -

        uint64_t READ_MEM(const CPU8080 & CPU); 	//OK OK -

        uint64_t PRINT_STR(const CPU8080 & CPU); 	//OK OK -

        uint64_t READ_STR(const CPU8080 & CPU);	 	//OK OK -

        uint64_t GET_RND(const CPU8080 & CPU);	 	//OK OK -

        uint64_t TCreate(const CPU8080 & CPU);	 	//OK OK -

        uint64_t TExit(const CPU8080 & CPU);	 	//OK OK -

        uint64_t TJoin(const CPU8080 & CPU);	 	//OK OK -

        uint64_t TYield(const CPU8080 & CPU);	 	//OK OK -

        uint64_t FileCreate(const CPU8080 & CPU);	//OK OK -

        uint64_t FileClose(const CPU8080 & CPU); 	//OK OK -

        uint64_t FileOpen(const CPU8080 & CPU); 	//OK OK -

        uint64_t FileRead(const CPU8080 & CPU); 	//OK OK -

        uint64_t FileWrite(const CPU8080 & CPU); 	//OK OK -

        uint64_t FileSeek(const CPU8080 & CPU); 	//OK OK -

        uint64_t DirRead(const CPU8080 & CPU); 	//OK OK -


        bool writeToMemFile(const CPU8080 & CPU);
		void setThread();
		void setFileSystem(char fileSystemName[]);

		int roundRobinScheduler(uint64_t timeClock, CPU8080 & CPU, uint64_t quantumTime, int debug);
		int	fd_fileSystem;
		void printFileTable(const CPU8080 & CPU);

	private:

		void setStack();
		void setThreadID();
		void setTimeClockTotal(uint64_t timeClock);
		void setTimeClockPerThread(uint64_t timeClock);
		uint64_t getTimeClockTotal();
		vector<ThreadTable> getThreadTableList();

		void saveCurrentThreadTable(const CPU8080 & CPU);
		void loadCurrentThreadTable(CPU8080 & CPU);
		//void threadCread(const CPU8080 & CPU);

		uint16_t generateStack();
		uint16_t generateThreadID();

		void printInfo();
		void printThreadsInfo();


		uint16_t 	stack_;
		uint8_t 	threadID;
		uint64_t 	timeClockTotal;
		uint64_t 	timeClockPerThread;
		vector<ThreadTable> threadTableList;
		vector<FileTable> 	fileTableList;
		//FileTable		 	fileTable;
		int 				blockNumber;
};



#endif
