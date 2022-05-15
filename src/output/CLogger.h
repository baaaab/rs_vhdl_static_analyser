#ifndef SRC_OUTPUT_CLOGGER_H_
#define SRC_OUTPUT_CLOGGER_H_

#include "ELogLevel.h"

namespace vhdl
{

class CLogger
{
public:
	static void Log(const char* file, const char* function, int line, ELogLevel logLevel, const char* format, ...);
	static const char* LogLevelToString(ELogLevel logLevel);
};

} /* namespace vhdl */

#endif /* SRC_OUTPUT_CLOGGER_H_ */
