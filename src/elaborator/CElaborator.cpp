#include "CElaborator.h"

#include <vector>

#include "../parser/CParser.h"

namespace vhdl
{

CElaborator::CElaborator(CParser* parser) :
		_parser(parser)
{

}

CElaborator::~CElaborator()
{

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

void CElaborator::elaborateSignals(const char* entityPath)
{
	/*
	 * start at top level
	 */
}

void CElaborator::printSignalIfUnprinted(const std::string& signalName, bool& printed)
{
	if(!printed)
	{
		printf("\tsignal: %s\n", signalName.c_str());
		printed = true;
	}
}

CEntity* CElaborator::findToplevelEntity(const char* entityName)
{
	// good enough for now
	return _parser->getEntities().back();
}



} /* namespace vhdl */
