#ifndef SRC_DOT_CDOTGRAPHCREATOR_H_
#define SRC_DOT_CDOTGRAPHCREATOR_H_

#include <cstdio>
#include <map>
#include <set>
#include <set>

#include "../elaborator/CSignalInstantiation.h"

namespace vhdl
{
class CNetList;

class CDotGraphCreator
{
public:
	CDotGraphCreator(const char* outputFileName, const std::vector<std::string>& signalNamesToIgnore);
	virtual ~CDotGraphCreator();

	void createDotGraph(const CNetList* netlist);

	bool isUserDefinedSignalsOnly() const;
	void setUserDefinedSignalsOnly(bool userDefinedSignalsOnly);

private:
	FILE* _fh;
	bool _userDefinedSignalsOnly;
	std::map<int, std::set<const CSignalInstantiation*>> _netRanks;

	std::vector<std::string> _signalNamesToIgnore;

	void createDriverDefinitionsRecursive(int depth, const CSignalInstantiation* drivenSignal, const CSignalInstantiation* driverToElaborate, std::set<const CSignalInstantiation*>& definedNodes, std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>>& definedPaths, std::set<const CSignalInstantiation*>& recursedNodes);
};

} /* namespace vhdl */

#endif /* SRC_DOT_CDOTGRAPHCREATOR_H_ */
