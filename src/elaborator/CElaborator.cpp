#include "CElaborator.h"

#include <stdlib.h>
#include <string.h>
#include <cstdio>
#include <utility>
#include <vector>

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
			printf("NOT Adding to netlist: %s.%s (%d, %d)\n", entityInstance->getInstanceName().c_str(), signal.getName().c_str(), signal.isPort(), isTopEntity);
		}
		else
		{
			printf("Adding to netlist: %s.%s\n", entityInstance->getInstanceName().c_str(), signal.getName().c_str());

			CSignalInstantiation si;
			si.addDefinition(entityInstance, &signal);
			_netlist->addNet(si);
		}
	}

	// probably needs some error handling when something is not found
	for(const CPortMap& portMap : entityInstance->getArchitecture()->getChildEntityPortMaps())
	{
		printf("[%d] Inspecting entity: %s\n", recursionDepth, portMap.getEntity()->getName().c_str());

		CEntityInstance* childEntity = entityInstance->addChildEntity(portMap.getInstanceName().c_str(), portMap.getEntity());

		for(const CInstantiationPort& ip : portMap.getPortMappings())
		{
			if(ip.getParentEntitySignal())
			{
				printf("\tInspecting port mapping: %s -> %s\n", ip.getParentEntitySignal()->getName().c_str(), ip.getChildEntityPortName().c_str());
				for(CSignalInstantiation& si : _netlist->getNets())
				{
					for(const CEntitySignalPair& parentNetDefinition : si.getDefinitions())
					{
						if(parentNetDefinition.getEntityInstance() == entityInstance && parentNetDefinition.getSignal()->getName() == ip.getParentEntitySignal()->getName())
						{
							printf("\t\tInspecting netlist entry: %s.%s\n", parentNetDefinition.getEntityInstance()->getArchitecture()->getName().c_str(), parentNetDefinition.getSignal()->getName().c_str());
							for(const CSignal& childSignal : portMap.getEntity()->getSignals())
							{
								printf("\t\t\tInspecting child signal: %s\n", childSignal.getName().c_str());
								if(childSignal.isPort() && childSignal.getName() == ip.getChildEntityPortName())
								{
									printf("\t\t\t\tAdding definition\n");
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

void CElaborator::printNetlist()
{
	for(const CSignalInstantiation& si : _netlist->getNets())
	{
		printf("Signal:\n");
		for(const CEntitySignalPair& parentNetDefinition : si.getDefinitions())
		{
			if(parentNetDefinition.getEntityInstance())
			{
				printf("\t%70s (%20s) : %20s\n", parentNetDefinition.getEntityInstance()->getArchitecture()->getName().c_str(), parentNetDefinition.getEntityInstance()->getInstanceName().c_str(), parentNetDefinition.getSignal()->getName().c_str());
			}
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

} /* namespace vhdl */
