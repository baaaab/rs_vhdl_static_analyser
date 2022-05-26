#include "CDotGraphCreator.h"

#include <algorithm>
#include <iterator>
#include <string>

#include "../elaborator/CEntityInstance.h"
#include "../elaborator/CEntitySignalPair.h"
#include "../elaborator/CNetList.h"
#include "../language/CEntity.h"
#include "../language/CSignal.h"
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

	fprintf(_fh, "}\n");
}

void CDotGraphCreator::createDriverDefinitionsRecursive(int depth, const CSignalInstantiation* drivenSignal, const CSignalInstantiation* driverToElaborate, std::vector<const CSignalInstantiation*>& definedNodes, std::vector<const CSignalInstantiation*> recursedNodes)
{
	// only need to go over it once
	recursedNodes.push_back(driverToElaborate);

	if(depth != 0 && (!_userDefinedSignalsOnly || driverToElaborate->isUserDefined()))
	{
		std::string drivenName = drivenSignal->generateUniqueIdentifier();
		std::string driverName = driverToElaborate->generateUniqueIdentifier();

		bool needToDefineDriven = std::find(definedNodes.begin(), definedNodes.end(), drivenSignal) == definedNodes.end();
		bool needToDefineDriver = std::find(definedNodes.begin(), definedNodes.end(), driverToElaborate) == definedNodes.end();

		if(needToDefineDriver)
		{
			const char* shape = driverToElaborate->isClocked() ? "rect" : "ellipse";
			fprintf(_fh, "\t\"%s\" [shape=%s];\n", driverName.c_str(), shape);
			definedNodes.push_back(driverToElaborate);
		}

		if(needToDefineDriven)
		{
			const char* shape = drivenSignal->isClocked() ? "rect" : "ellipse";
			fprintf(_fh, "\t\"%s\" [shape=%s];\n", drivenName.c_str(), shape);
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
		for(const CSignalInstantiation* nextDriver : driverToElaborate->getDirectDrivers())
		{
			bool alreadyRecursed = std::find(recursedNodes.begin(), recursedNodes.end(), nextDriver) != recursedNodes.end();
			if(!alreadyRecursed)
			{
				createDriverDefinitionsRecursive(depth+1, drivenSignal, nextDriver, definedNodes, recursedNodes);
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
