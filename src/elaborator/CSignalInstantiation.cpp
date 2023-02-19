#include "CSignalInstantiation.h"

#include <utility>

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

const CSignalInstantiation* CSignalInstantiation::getClock() const
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
	bool isUserDefined = _definitions.front().getSignal()->isUserDefined();
	if(!isUserDefined)
	{
		for(const CEntitySignalPair& esp : _definitions)
		{
			if(esp.getSignal()->isUserDefined())
			{
				uniqueIdentifier = esp.getSignal()->getName();
				entityInstance = esp.getEntityInstance();
				break;
			}
		}
	}

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
		if(definition.getSignal()->getClock())
		{
			return true;
		}
	}
	return false;
}

std::set<int> CSignalInstantiation::calculateNumberofRegisterStages(const std::vector<std::string>& signalsToIgnore) const
{
	std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>> followedPaths;
	std::set<const CSignalInstantiation*> clockCheckList;

	// we need to figure out what clock domain we are on
	const CSignalInstantiation* clock = GetDriverClockRecursive(this, clockCheckList);

	// loop through all non-self drivers, add one for each clocked, do not follow the same path twice
	std::set<int> allPathLengths = CountNumberOfRegisterStagesToInput(this, clock, followedPaths, signalsToIgnore);

	return allPathLengths;
}

std::set<int> CSignalInstantiation::CountNumberOfRegisterStagesToInput(const CSignalInstantiation* signal, const CSignalInstantiation* clock,
    std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>>& followedPaths, const std::vector<std::string>& signalsToIgnore)
{
	int numRegisterStages = 0;
	if(signal->isClocked())
	{
		if(signal->getClock() != clock)
		{
			// wrong clock, ignore this path
			return {};
		}
		numRegisterStages = 1;
	}

	const CSignal* firstDefSignal = signal->getDefinitions()[0].getSignal();

	if(signal->getDirectDrivers().empty() && firstDefSignal->isPort() && firstDefSignal->isInput())
	{
		return {numRegisterStages};
	}

	std::set<int> pathLengths;

	for(const CSignalInstantiation* driver : signal->getDirectDrivers())
	{
		bool ignoreDriver = false;
		for(const CEntitySignalPair& esp : driver->getDefinitions())
		{
			for(const std::string& signalToIgnore : signalsToIgnore)
			{
				if(signalToIgnore == esp.getSignal()->getName())
				{
					ignoreDriver = true;
					break;
				}
			}
		}
		if(!ignoreDriver)
		{
			std::pair<const CSignalInstantiation*, const CSignalInstantiation*> path(signal, driver);
			if(followedPaths.count(path) == 0)
			{
				followedPaths.insert(path);
				std::set<int> derivativePathLength = CountNumberOfRegisterStagesToInput(driver, clock, followedPaths, signalsToIgnore);
				pathLengths.insert(derivativePathLength.begin(), derivativePathLength.end());
			}
		}
	}

	std::set<int> copy;

	for(const int& i : pathLengths)
	{
		copy.insert(i+numRegisterStages);
	}

	return copy;
}

const CSignalInstantiation* CSignalInstantiation::GetDriverClockRecursive(const CSignalInstantiation* signal, std::set<const CSignalInstantiation*>& checkedSignals)
{
	if(signal->getClock())
	{
		return signal->getClock();
	}

	for(CSignalInstantiation* driver : signal->getDirectDrivers())
	{
		if(checkedSignals.count(driver) == 0)
		{
			checkedSignals.insert(driver);
			const CSignalInstantiation* driverClock = GetDriverClockRecursive(driver,  checkedSignals);
			if(driverClock)
			{
				return driverClock;
			}
		}
	}
	return NULL;
}

} /* namespace vhdl */
