#include "CSignalInstantiation.h"

#include "../language/CSignal.h"
#include "CEntityInstance.h"

namespace vhdl
{

CSignalInstantiation::CSignalInstantiation() :
		_clock(NULL)
{

}

CSignalInstantiation::~CSignalInstantiation()
{

}

const std::vector<CEntitySignalPair>& CSignalInstantiation::getDefinitions() const
{
	return _definitions;
}

const CSignalInstantiation* CSignalInstantiation::getClock()
{
	return _clock;
}

const std::vector<CSignalInstantiation*>& CSignalInstantiation::getDirectDrivers() const
{
	return _directDrivers;
}

void CSignalInstantiation::addDefinition(const CEntityInstance* entity, const CSignal* signal)
{
	_definitions.emplace_back(entity, signal);
}

void CSignalInstantiation::addDirectDriver(CSignalInstantiation* signalInstance)
{
	_directDrivers.push_back(signalInstance);
}

void CSignalInstantiation::setClock(const CSignalInstantiation* clockSignalInstance)
{
	_clock = clockSignalInstance;
}

std::string CSignalInstantiation::generateUniqueIdentifier() const
{
	std::string uniqueIdentifier = _definitions.front().getSignal()->getName();

	const CEntityInstance* entityInstance = _definitions.front().getEntityInstance();

	while(entityInstance->getParent() != NULL)
	{
		uniqueIdentifier = entityInstance->getInstanceName() + "/" + uniqueIdentifier;
		entityInstance = entityInstance->getParent();
	}

	return uniqueIdentifier;
}

bool CSignalInstantiation::isUserDefined() const
{
	for(const CEntitySignalPair& definition : _definitions)
	{
		if(definition.getSignal()->isUserDefined())
		{
			return true;
		}
	}
	return false;
}

bool CSignalInstantiation::isClocked() const
{
	for(const CEntitySignalPair& definition : _definitions)
	{
		if(!definition.getSignal()->getClockedContributors().empty())
		{
			return true;
		}
	}
	return false;
}

} /* namespace vhdl */
