#include "CSignalInstantiation.h"

namespace vhdl
{

CSignalInstantiation::CSignalInstantiation()
{

}

CSignalInstantiation::~CSignalInstantiation()
{

}

const std::vector<CEntitySignalPair>& CSignalInstantiation::getDefinitions() const
{
	return _definitions;
}

void CSignalInstantiation::addDefinition(const CEntityInstance* entity, const CSignal* signal)
{
	_definitions.emplace_back(entity, signal);
}

} /* namespace vhdl */
