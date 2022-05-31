#include "CDotGraphCreator.h"

#include <algorithm>
#include <iterator>
#include <string>

#include "../elaborator/CNetList.h"
#include "../output/CLogger.h"
#include "../output/ELogLevel.h"

namespace vhdl
{

CDotGraphCreator::CDotGraphCreator(const char* outputFileName) :
		_userDefinedSignalsOnly(false)
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

	std::vector<const CSignalInstantiation*> definedNodes;

	for(const CSignalInstantiation& si : netlist->getNets())
	{
		std::vector<const CSignalInstantiation*> recursedNodes;
		bool isUserDefined = !_userDefinedSignalsOnly || si.isUserDefined();

		if(isUserDefined)
		{
			//this node needs to appear, we need to find its (userDefined) drivers
			createDriverDefinitionsRecursive(0, &si, &si, definedNodes, recursedNodes);
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

void CDotGraphCreator::createDriverDefinitionsRecursive(int depth, const CSignalInstantiation* drivenSignal, const CSignalInstantiation* driverToElaborate, std::vector<const CSignalInstantiation*>& definedNodes, std::vector<const CSignalInstantiation*> recursedNodes)
{
	// only need to go over it once
	recursedNodes.push_back(driverToElaborate);

	std::set<int> allRanks = drivenSignal->calculateNumberofRegisterStages();
	if(allRanks.empty())
	{
		allRanks.insert(0);
	}
	int rank = *std::min_element(allRanks.begin(), allRanks.end());

	_netRanks[rank].insert(drivenSignal);

	if(depth != 0 && (!_userDefinedSignalsOnly || driverToElaborate->isUserDefined()))
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
			definedNodes.push_back(driverToElaborate);
		}

		if(needToDefineDriven)
		{
			const char* shape = drivenSignal->isClocked() ? "rect" : "ellipse";
			const char* colour = drivenSignal->isClocked() ? "blue" : "red";
			fprintf(_fh, "\t\"%s\" [shape=%s,color=%s];\n", drivenName.c_str(), shape, colour);
			definedNodes.push_back(drivenSignal);
		}

		fprintf(_fh, "\t\"%s\" -> \"%s\";\n", driverName.c_str(), drivenName.c_str());
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
			bool alreadyRecursed = std::find(recursedNodes.begin(), recursedNodes.end(), nextDriver) != recursedNodes.end();
			if(!alreadyRecursed || (nextDriver == drivenSignal && depth < 2))
			{
				createDriverDefinitionsRecursive(depth, drivenSignal, nextDriver, definedNodes, recursedNodes);
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
