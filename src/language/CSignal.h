#ifndef SRC_PARSER_CSIGNAL_H_
#define SRC_PARSER_CSIGNAL_H_

#include <string>
#include <vector>

#include "../parser/CSourceLocation.h"

namespace vhdl
{

class CSignal
{
public:
	CSignal(const char* name, const char* type, const char* synthFile, uint32_t synthline);
	virtual ~CSignal();

	const std::vector<CSignal*>& getContributors() const;
	void setClockedContributors(CSignal* clockSignal, const std::vector<CSignal*>& clockedContributors);
	void setCombinatorialContributors(const std::vector<CSignal*>& combinatorialContributors);

	bool isInput() const;
	void setIsInput(bool isInput);

	bool isOutput() const;
	void setIsOutput(bool isOutput);

	bool isPort() const;
	void setIsPort(bool isPort);

	bool isUserDefined() const;
	void setIsUserDefined(bool isuserDefined);
	
	bool isClock() const;
	void setIsClock(bool isClock);

	const std::string& getName() const;

	const CSourceLocation& getSourceAssignment() const;
	void setSourceAssignment(const CSourceLocation& sourceAssignment);

	const CSourceLocation& getSynthAssignment() const;
	void setSynthAssignment(const CSourceLocation& synthAssignment);

	const CSourceLocation& getSynthDefinition() const;
	void setSynthDefinition(const CSourceLocation& synthDefinition);

	const std::string& getType() const;

	const CSignal* getClock() const;
	CSignal* getClock();

	const std::string& getAssignmentStatementRhs() const;
	void setAssignmentStatementRhs(const char* assignmentStatementRhs);

private:
	std::string _name;
	std::string _type;

	CSourceLocation _synthDefinition;

	CSourceLocation _sourceAssignment;
	CSourceLocation _synthAssignment;

	bool _isPort;
	bool _isInput;
	bool _isOutput;

	bool _isUserDefined;

	bool _isClock;

	std::vector<CSignal*> _contributors;
	CSignal*              _clock;

	std::string _assignmentStatementRHS;
};

} /* namespace vhdl */

#endif /* SRC_PARSER_CSIGNAL_H_ */
