#include "CSourceLocation.h"

#include <cstring>

namespace vhdl
{

CSourceLocation::CSourceLocation() :
		_line(0)
{

}

CSourceLocation::~CSourceLocation()
{
}

bool CSourceLocation::setFromComment(const char* line)
{
	//-- entities/async_dpram.vhd:40:10
	char* copy = strdup(line);
	char* ptr = copy;

	while(*ptr == ' ' || *ptr == '\t')
	{
		ptr++;
	}

	if(ptr[0] == '-' && ptr[1] == '-')
	{
		ptr +=2;

		char* state = NULL;
		char* filename = strtok_r(ptr, ":", &state);
		char* lineNumber = strtok_r(NULL, ":", &state);

		if(filename && lineNumber)
		{
			_file = filename;
			_line = strtoul(lineNumber, NULL, 10);
			return true;
		}
	}
	return false;
}

void CSourceLocation::setFromFileAndline(const std::string& file, uint32_t line)
{
	_file = file;
	_line = line;
}

const std::string& CSourceLocation::getFile() const
{
	return _file;
}

uint32_t CSourceLocation::getLine() const
{
	return _line;
}

} /* namespace vhdl */
