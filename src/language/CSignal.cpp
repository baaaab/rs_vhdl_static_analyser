#include "CSignal.h"

#include <cstdio>
#include <algorithm>

#include "../output/CLogger.h"
#include "../output/ELogLevel.h"

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
		_clock(nullptr),
		_isUnconcatenated(false),
		_unconcatenationIndex(0)
{
	_synthDefinition.setFromFileAndline(synthFile, synthLine);
}

CSignal::~CSignal()
{

}

const std::vector<CSignal*>& CSignal::getContributors() const
{
	return _contributors;
}

void CSignal::setClockedContributors(CSignal* clockSignal, const std::vector<CSignal*>& clockedContributors)
{
	_clock = clockSignal;
	_contributors = clockedContributors;
}

void CSignal::setCombinatorialContributors(const std::vector<CSignal*>& combinatorialContributors)
{
	_contributors = combinatorialContributors;
	_clock = NULL;
}

void CSignal::addClockedContributors(CSignal* clockSignal, const std::vector<CSignal*>& clockedContributors)
{
	// maybe this should be a set...
	for(CSignal* signal : clockedContributors)
	{
		if(std::find(_contributors.begin(), _contributors.end(), signal) == _contributors.end())
		{
			_contributors.push_back(signal);
		}
	}
	_clock = clockSignal;
}

void CSignal::addCombinatorialContributors(const std::vector<CSignal*>& combinatorialContributors)
{
	for(CSignal* signal : combinatorialContributors)
	{
		if(std::find(_contributors.begin(), _contributors.end(), signal) == _contributors.end())
		{
			_contributors.push_back(signal);
		}
	}
	_clock = NULL;
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

bool CSignal::isUnconcatenated() const
{
	return _isUnconcatenated;
}

void CSignal::setIsUnconcatenated(bool isUnconcatenated)
{
	_isUnconcatenated = isUnconcatenated;
}

const std::string& CSignal::getUnconcatenatedName() const
{
	return _unconcatenatedName;
}

void CSignal::setUnconcatenatedName(const std::string& unconcatenatedName)
{
	_unconcatenatedName = unconcatenatedName;
}

int CSignal::getUnconcatenationIndex() const
{
	return _unconcatenationIndex;
}

void CSignal::setUnconcatenationIndex(int unconcatenationIndex)
{
	_unconcatenationIndex = unconcatenationIndex;
}

void CSignal::dump()
{
	CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Signal: %s", _name.c_str());
	printf("\ttype: %s\n", _type.c_str());
	printf("\t_isPort: %d\n", _isPort);
	printf("\t_isInput: %d\n", _isInput);
	printf("\t_isOutput: %d\n", _isOutput);
	printf("\t_isUserDefined: %d\n", _isUserDefined);
	printf("\t_isClock: %d\n", _isClock);

	printf("\tClock: %s\n", _clock ? _clock->getName().c_str() : NULL);

	printf("\tRHS assignment: %s\n",_assignmentStatementRHS.c_str());

	printf("\tContributors:\n\t\t");
	for(const CSignal* contributor : _contributors)
	{
		printf("%s, ",contributor->getName().c_str());
	}
	printf("\n");
}

} /* namespace vhdl */
