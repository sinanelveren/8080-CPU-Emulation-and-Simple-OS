#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"

using namespace std;


class GTUOS{
	public:
		uint64_t handleCall(const CPU8080 & CPU);


        uint64_t PRINT_B(const CPU8080 & CPU); 		//OK OK -

        uint64_t PRINT_MEM(const CPU8080 & CPU); 	//OK OK -

        uint64_t READ_B(const CPU8080 & CPU); 		//OK OK -

        uint64_t READ_MEM(const CPU8080 & CPU); 	//OK OK -

        uint64_t PRINT_STR(const CPU8080 & CPU); 	//OK OK -

        uint64_t READ_STR(const CPU8080 & CPU);	 	//OK OK -

        uint64_t GET_RND(const CPU8080 & CPU);	 	//OK OK -

        bool writeToMemFile(const CPU8080 & CPU);
};



#endif
