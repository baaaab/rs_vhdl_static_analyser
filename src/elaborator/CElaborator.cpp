#include "CElaborator.h"

#include <stdlib.h>
#include <string.h>
#include <cstdio>
#include <utility>
#include <vector>
#include <set>

#include "../language/CEntity.h"
#include "../language/CInstantiationPort.h"
#include "../language/CPortMap.h"
#include "../language/CSignal.h"
#include "../output/CLogger.h"
#include "../output/ELogLevel.h"
#include "../parser/CParser.h"
#include "../parser/CSourceLocation.h"
#include "CEntityInstance.h"
#include "CEntitySignalPair.h"
#include "CNetList.h"
#include "CSignalInstantiation.h"

namespace vhdl
{

CElaborator::CElaborator(CParser* parser) :
		_parser(parser),
		_netlist(NULL)
{

}

CElaborator::~CElaborator()
{
	delete _netlist;
}

void CElaborator::printUnassignedSignals()
{
	for(CEntity* entity : _parser->getEntities())
	{
		printf("Checking entity: %s\n", entity->getName().c_str());
		for(const CSignal& signal : entity->getSignals())
		{
			bool printed = false;
			if(signal.getClock() == NULL)
			{
				if(signal.getCombinatorialContributors().empty())
				{
					if(!signal.isPort())
					{
						printSignalIfUnprinted(signal.getName(), printed);
						printf("\t\tNever assigned (unclocked)\n");
					}
				}
			}
			else if(signal.getClockedContributors().empty())
			{
				printSignalIfUnprinted(signal.getName(), printed);
				printf("\t\tNever assigned (clocked)\n");
			}

			if(!signal.isPort())
			{
				if(signal.getSourceAssignment().getFile().empty())
				{
					printSignalIfUnprinted(signal.getName(), printed);
					printf("\t\tNo Source assignment location\n");
				}

				if(signal.getSynthAssignment().getFile().empty())
				{
					printSignalIfUnprinted(signal.getName(), printed);
					printf("\t\tNo Synth assignment location\n");
				}
			}

			if(signal.getSynthDefinition().getFile().empty())
			{
				printSignalIfUnprinted(signal.getName(), printed);
				printf("\t\tNo Synth definition location\n");
			}
		}
	}
}

void CElaborator::elaborateSignalsFromPath(const char* entityPath)
{
	// start at top level
	const CPortMap* portMap = _parser->getTopPortMap();

	if(entityPath && *entityPath != 0)
	{
		char* copy = strdup(entityPath);
		char* state = NULL;
		bool first = true;

		while(1)
		{
			char* entityInstanceName = strtok_r(first ? copy : NULL, "/", &state);
			if(entityInstanceName == NULL)
			{
				break;
			}

			bool found = false;

			for(const CPortMap& pm : portMap->getEntity()->getChildEntityPortMaps())
			{
				if(pm.getInstanceName() == entityInstanceName)
				{
					found = true;
					portMap = &pm;
					break;
				}
			}

			if(!found)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Cannot find an entity at path: '%s'", entityPath);
				throw 1;
			}
		}
		free(copy);
	}

	// reset
	_netlist = new CNetList(portMap->getEntity());

	elaborateSignalsFromEntity(_netlist->getTopEntity());
	elaborateNetlistDrivers();
}

void CElaborator::elaborateSignalsFromEntity(CEntityInstance* entityInstance, int recursionDepth)
{
	if(recursionDepth >= 250)
	{
		// we should never get anywhere near this for a valid design
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Recursion limit reached iterating through entity instances");
		throw 1;
	}

	bool isTopEntity = _netlist->getNets().empty();

	// add all signals in this entity to netlist
	for(const CSignal& signal : entityInstance->getArchitecture()->getSignals())
	{
		if(signal.isPort() && !isTopEntity)
		{
			// we will have added this through a port mapping
		}
		else
		{
			CSignalInstantiation si;
			si.addDefinition(entityInstance, &signal);
			_netlist->addNet(si);
		}
	}

	// probably needs some error handling when something is not found
	for(const CPortMap& portMap : entityInstance->getArchitecture()->getChildEntityPortMaps())
	{
		CEntityInstance* childEntity = entityInstance->addChildEntity(portMap.getInstanceName().c_str(), portMap.getEntity());

		for(const CInstantiationPort& ip : portMap.getPortMappings())
		{
			if(ip.getParentEntitySignal())
			{
				for(CSignalInstantiation& si : _netlist->getNets())
				{
					for(const CEntitySignalPair& parentNetDefinition : si.getDefinitions())
					{
						if(parentNetDefinition.getEntityInstance() == entityInstance && parentNetDefinition.getSignal()->getName() == ip.getParentEntitySignal()->getName())
						{
							for(const CSignal& childSignal : portMap.getEntity()->getSignals())
							{
								if(childSignal.isPort() && childSignal.getName() == ip.getChildEntityPortName())
								{
									si.addDefinition(childEntity, &childSignal);
									break;
								}
							}
						}
					}
				}
			}
		}

		// loop through all entitiy instances and add them recursively
		elaborateSignalsFromEntity(childEntity, recursionDepth + 1);
	}
}

void CElaborator::elaborateNetlistDrivers()
{
	/*
	 * Add drivers to each element in netlist.
	 *
	 * Iterate through each CSignalInstantiation
	 * 	Find drivers from architecture(s)
	 * 	Find their CSignalInstantiation
	 * 	Add to the drivers array to simplify future design analysers
	 *
	 * 	we may benefit from a filter before this that deals with signal renaming, eg 'wrap_clk <= clk'
	 */
	for(CSignalInstantiation& si : _netlist->getNets())
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Analysing signalInstance");
		for(const CEntitySignalPair& esp : si.getDefinitions())
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Analysing signal: %s in entity(%p): %s", esp.getSignal()->getName().c_str(), esp.getEntityInstance(), esp.getEntityInstance()->getArchitecture()->getName().c_str());
			std::vector<CSignal*> contributors = esp.getSignal()->getClockedContributors();
			if(contributors.empty())
			{
				contributors = esp.getSignal()->getCombinatorialContributors();
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "NON clocked");
			}
			else
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Clocked");
				if(si.getClock() != NULL)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Signal: '%s' in instance: '%s' of entity: '%s' appears to be driven in two or more different clocked processes",
							esp.getSignal()->getName().c_str(),
							esp.getEntityInstance()->getInstanceName().c_str(),
							esp.getEntityInstance()->getArchitecture()->getName().c_str());
					throw 1;
				}
				else
				{
					std::vector<CSignalInstantiation*> clockSignals = _netlist->findBySignal(esp.getEntityInstance(), esp.getSignal()->getClock());
					if(clockSignals.size() != 1)
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Signal: '%s' in instance: '%s' of entity: '%s' cannot find clock signal used in process",
								esp.getSignal()->getName().c_str(),
								esp.getEntityInstance()->getInstanceName().c_str(),
								esp.getEntityInstance()->getArchitecture()->getName().c_str());
						throw 1;
					}
					si.setClock(clockSignals.front());
				}
			}

			// use a set to remove duplicates (although there shouldn't be any...)
			std::set<CSignalInstantiation*> elaboratedContributors;

			// all contributors should be in the same entity (but may be ports)
			for(CSignal* signal : contributors)
			{
				std::vector<CSignalInstantiation*> nodes = _netlist->findBySignal(esp.getEntityInstance(), signal);
				elaboratedContributors.insert(nodes.begin(), nodes.end());
			}
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%zu direct drivers", elaboratedContributors.size());
			for(CSignalInstantiation* esi : elaboratedContributors)
			{
				si.addDirectDriver(esi);
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "\t%s", esi->generateUniqueIdentifier().c_str());
			}
		}
	}
}

void CElaborator::printNetlist()
{
	for(const CSignalInstantiation& si : _netlist->getNets())
	{
		printf("Signal:\n");
		for(const CEntitySignalPair& netDefinition : si.getDefinitions())
		{
			if(netDefinition.getEntityInstance())
			{
				printf("\t%70s (%20s) : %20s - has %zu drivers\n", netDefinition.getEntityInstance()->getArchitecture()->getName().c_str(), netDefinition.getEntityInstance()->getInstanceName().c_str(), netDefinition.getSignal()->getName().c_str(), si.getDirectDrivers().size());
			}
		}
		for(const CSignalInstantiation* driver : si.getDirectDrivers())
		{
			printf("\t\t%s\n", driver->generateUniqueIdentifier().c_str());
		}
	}
}

void CElaborator::printSignalIfUnprinted(const std::string& signalName, bool& printed)
{
	if(!printed)
	{
		printf("\tsignal: %s\n", signalName.c_str());
		printed = true;
	}
}

const CNetList* CElaborator::getNetlist() const
{
	return _netlist;
}

} /* namespace vhdl */
