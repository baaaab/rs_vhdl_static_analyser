#include "CSignal.h"

namespace vhdl
{

CSignal::CSignal(const char* name, const char* type, const char* synthFile, uint32_t synthLine) :
		_name(name),
		_type(type),
		_isPort(false),
		_isInput(false),
		_isOutput(false),
		_isUserDefined(true),
		_isClock(false),
		_combinatorialContributors(),
		_clock(nullptr)
{
	_synthDefinition.setFromFileAndline(synthFile, synthLine);
}

CSignal::~CSignal()
{

}

const std::vector<CSignal*>& CSignal::getClockedContributors() const
{
	return _clockedContributors;
}

void CSignal::setClockedContributors(CSignal* clockSignal, const std::vector<CSignal*>& clockedContributors)
{
	_clock = clockSignal;
	_clockedContributors = clockedContributors;
	_combinatorialContributors.clear();
}

const std::vector<CSignal*>& CSignal::getCombinatorialContributors() const
{
	return _combinatorialContributors;
}

void CSignal::setCombinatorialContributors(const std::vector<CSignal*>& combinatorialContributors)
{
	_combinatorialContributors = combinatorialContributors;
	_clock = NULL;
	_clockedContributors.clear();
}

bool CSignal::isInput() const
{
	return _isInput;
}

void CSignal::setIsInput(bool isInput)
{
	_isInput = isInput;
}

bool CSignal::isOutput() const
{
	return _isOutput;
}

void CSignal::setIsOutput(bool isOutput)
{
	_isOutput = isOutput;
}

bool CSignal::isPort() const
{
	return _isPort;
}

void CSignal::setIsPort(bool isPort)
{
	_isPort = isPort;
}

bool CSignal::isUserDefined() const
{
	return _isUserDefined;
}

void CSignal::setIsUserDefined(bool isuserDefined)
{
	_isUserDefined = isuserDefined;
}

bool CSignal::isClock() const
{
	return _isClock;
}

void CSignal::setIsClock(bool isClock)
{
	_isClock = isClock;
}

const std::string& CSignal::getName() const
{
	return _name;
}

const CSourceLocation& CSignal::getSourceAssignment() const
{
	return _sourceAssignment;
}

void CSignal::setSourceAssignment(const CSourceLocation& sourceAssignment)
{
	_sourceAssignment = sourceAssignment;
}

const CSourceLocation& CSignal::getSynthAssignment() const
{
	return _synthAssignment;
}

void CSignal::setSynthAssignment(const CSourceLocation& synthAssignment)
{
	_synthAssignment = synthAssignment;
}

const CSourceLocation& CSignal::getSynthDefinition() const
{
	return _synthDefinition;
}

void CSignal::setSynthDefinition(const CSourceLocation& synthDefinition)
{
	_synthDefinition = synthDefinition;
}

const std::string& CSignal::getType() const
{
	return _type;
}

const CSignal* CSignal::getClock() const
{
	return _clock;
}

CSignal* CSignal::getClock()
{
	return _clock;
}

const std::string& CSignal::getAssignmentStatementRhs() const
{
	return _assignmentStatementRHS;
}

void CSignal::setAssignmentStatementRhs(const char* assignmentStatementRhs)
{
	_assignmentStatementRHS = assignmentStatementRhs;
}

} /* namespace vhdl */
