#include "CDotGraphCreator.h"

#include <algorithm>
#include <string>
#include <utility>
#include <vector>

#include "../elaborator/CEntitySignalPair.h"
#include "../elaborator/CNetList.h"
#include "../language/CSignal.h"
#include "../output/CLogger.h"
#include "../output/ELogLevel.h"

namespace vhdl
{

CDotGraphCreator::CDotGraphCreator(const char* outputFileName, const std::vector<std::string>& signalNamesToIgnore) :
		_userDefinedSignalsOnly(false),
		_signalNamesToIgnore(signalNamesToIgnore)
{
	_fh = fopen(outputFileName, "w");
	if(!_fh)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Cannot open output file: %s", outputFileName);
	}
}

CDotGraphCreator::~CDotGraphCreator()
{
	fclose(_fh);
}

void CDotGraphCreator::createDotGraph(const CNetList* netlist)
{
	fprintf(_fh, "digraph bob{\n");
	fprintf(_fh, "\trankdir = TB;\n");

	std::set<const CSignalInstantiation*> definedNodes;
	std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>> definedPaths;

	for(const CSignalInstantiation& si : netlist->getNets())
	{
		std::set<const CSignalInstantiation*> recursedNodes;
		bool isUserDefined = !_userDefinedSignalsOnly || si.isUserDefined();

		if(isUserDefined)
		{
			//this node needs to appear, we need to find its (userDefined) drivers
			createDriverDefinitionsRecursive(0, &si, &si, definedNodes, definedPaths, recursedNodes);
		}
	}

	for(auto& entry : _netRanks)
	{
		if(entry.first != 0)
		{
			fprintf(_fh, "\t{ rank=same; ");
			for(const CSignalInstantiation* si : entry.second)
			{
				if(si->isClocked())
				{
					fprintf(_fh, "\"%s\"; ", si->generateUniqueIdentifier().c_str());
				}
			}
			fprintf(_fh, "} # %d\n", entry.first);
		}
	}

	fprintf(_fh, "}\n");
}

void CDotGraphCreator::createDriverDefinitionsRecursive(int depth, const CSignalInstantiation* drivenSignal, const CSignalInstantiation* driverToElaborate, std::set<const CSignalInstantiation*>& definedNodes, std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>>& definedPaths, std::set<const CSignalInstantiation*>& recursedNodes)
{
	// only need to go over it once
	recursedNodes.insert(driverToElaborate);

	std::set<int> allRanks = drivenSignal->calculateNumberofRegisterStages();
	if(allRanks.empty())
	{
		allRanks.insert(0);
	}
	int rank = *std::min_element(allRanks.begin(), allRanks.end());

	_netRanks[rank].insert(drivenSignal);

	bool ignore = false;
	for(const std::string& signalNameToIgnore : _signalNamesToIgnore)
	{
		for(const CEntitySignalPair& definition : driverToElaborate->getDefinitions())
		{
			if(definition.getSignal()->getName() == signalNameToIgnore)
			{
				ignore = true;
				break;
			}
		}
		for(const CEntitySignalPair& definition : drivenSignal->getDefinitions())
		{
			if(definition.getSignal()->getName() == signalNameToIgnore)
			{
				ignore = true;
				break;
			}
		}
	}

	if(ignore)
	{
		return;
	}

	std::pair<const CSignalInstantiation*, const CSignalInstantiation*> path(drivenSignal, driverToElaborate);
	if(depth != 0 && (!_userDefinedSignalsOnly || driverToElaborate->isUserDefined()) && definedPaths.count(path) == 0)
	{
		std::string drivenName = drivenSignal->generateUniqueIdentifier();
		std::string driverName = driverToElaborate->generateUniqueIdentifier();

		bool needToDefineDriven = std::find(definedNodes.begin(), definedNodes.end(), drivenSignal) == definedNodes.end();
		bool needToDefineDriver = std::find(definedNodes.begin(), definedNodes.end(), driverToElaborate) == definedNodes.end();

		if(needToDefineDriver)
		{
			const char* shape = driverToElaborate->isClocked() ? "rect" : "ellipse";
			const char* colour = driverToElaborate->isClocked() ? "blue" : "red";
			fprintf(_fh, "\t\"%s\" [shape=%s,color=%s];\n", driverName.c_str(), shape, colour);
			definedNodes.insert(driverToElaborate);
		}

		if(needToDefineDriven)
		{
			const char* shape = drivenSignal->isClocked() ? "rect" : "ellipse";
			const char* colour = drivenSignal->isClocked() ? "blue" : "red";
			fprintf(_fh, "\t\"%s\" [shape=%s,color=%s];\n", drivenName.c_str(), shape, colour);
			definedNodes.insert(drivenSignal);
		}

		fprintf(_fh, "\t\"%s\" -> \"%s\";\n", driverName.c_str(), drivenName.c_str());

		definedPaths.insert(path);
	}

	if(!_userDefinedSignalsOnly && depth > 0)
	{
		return;
	}

	if(depth == 0 || !driverToElaborate->isClocked())
	{
		if(drivenSignal == driverToElaborate)
		{
			++depth;
		}

		for(const CSignalInstantiation* nextDriver : driverToElaborate->getDirectDrivers())
		{
			const CSignalInstantiation* nextDrivenSignal = (_userDefinedSignalsOnly && driverToElaborate->isUserDefined()) ? driverToElaborate : drivenSignal;
			bool alreadyRecursed = std::find(recursedNodes.begin(), recursedNodes.end(), nextDriver) != recursedNodes.end();
			if(!alreadyRecursed || (nextDriver == drivenSignal && depth < 2))
			{
				createDriverDefinitionsRecursive(depth, nextDrivenSignal, nextDriver, definedNodes, definedPaths, recursedNodes);
			}
		}
	}
}

bool CDotGraphCreator::isUserDefinedSignalsOnly() const
{
	return _userDefinedSignalsOnly;
}

void CDotGraphCreator::setUserDefinedSignalsOnly(bool userDefinedSignalsOnly)
{
	_userDefinedSignalsOnly = userDefinedSignalsOnly;
}

} /* namespace vhdl */
