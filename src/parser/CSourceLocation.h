#ifndef SRC_PARSER_CSOURCELOCATION_H_
#define SRC_PARSER_CSOURCELOCATION_H_

#include <string>

namespace vhdl
{

class CSourceLocation
{
public:
	CSourceLocation();
	virtual ~CSourceLocation();

	bool setFromComment(const char* line);
	void setFromFileAndline(const std::string& file, uint32_t line);

	const std::string& getFile() const;
	uint32_t getLine() const;

private:
	std::string _file;
	uint32_t _line;
};

} /* namespace vhdl */

#endif /* SRC_PARSER_CSOURCELOCATION_H_ */
