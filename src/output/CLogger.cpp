#include "CLogger.h"

#include <stdio.h>
#include <stdarg.h>

namespace vhdl
{

void CLogger::Log(const char* file, const char* function, int line, ELogLevel logLevel, const char* format, ...)
{
	va_list args;
	va_start(args, format);

	printf("%s: (%s::%s():%d) ", LogLevelToString(logLevel), file, function, line);
	vprintf(format, args);
	printf("\n");
}

const char* CLogger::LogLevelToString(ELogLevel logLevel)
{
	switch(logLevel)
	{
		case ELogLevel::DEBUG:
			return "DEBUG";
		case ELogLevel::INFO:
			return "INFO";
		case ELogLevel::WARN:
			return "WARN";
		case ELogLevel::ERROR:
			return "ERROR";
		case ELogLevel::FATAL:
			return "FATAL";
		default:
			return "UNKNOWN";
	}
}

} /* namespace vhdl */
