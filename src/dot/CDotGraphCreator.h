#ifndef SRC_DOT_CDOTGRAPHCREATOR_H_
#define SRC_DOT_CDOTGRAPHCREATOR_H_

#include <cstdio>
#include <vector>

#include "../elaborator/CSignalInstantiation.h"

namespace vhdl
{
class CNetList;

class CDotGraphCreator
{
public:
	CDotGraphCreator(const char* outputFileName);
	virtual ~CDotGraphCreator();

	void createDotGraph(const CNetList* netlist);

	bool isUserDefinedSignalsOnly() const;
	void setUserDefinedSignalsOnly(bool userDefinedSignalsOnly);

private:
	FILE* _fh;
	bool _userDefinedSignalsOnly;

	void createDriverDefinitionsRecursive(int depth, const CSignalInstantiation* drivenSignal, const CSignalInstantiation* driverToElaborate, std::vector<const CSignalInstantiation*>& definedNodes, std::vector<const CSignalInstantiation*> recursedNodes);
};

} /* namespace vhdl */

#endif /* SRC_DOT_CDOTGRAPHCREATOR_H_ */
