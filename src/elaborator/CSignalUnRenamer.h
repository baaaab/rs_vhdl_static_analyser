#ifndef SRC_ELABORATOR_CSIGNALUNRENAMER_H_
#define SRC_ELABORATOR_CSIGNALUNRENAMER_H_

#include <vector>

#include "../language/CPortMap.h"
#include "../language/CSignal.h"

namespace vhdl
{
class CEntity;

class CSignalUnRenamer
{
public:
	CSignalUnRenamer();
	virtual ~CSignalUnRenamer();

	void simplifyEntityArchitecture(std::vector<CSignal*>& signals, std::vector<CPortMap>& entityInstances);

	static void ReplaceElementInVector(std::vector<CSignal*>& haystack, CSignal* needle, CSignal* replace);
	static bool RhsAssignmentStdStringReplace(std::string& str, const std::string& from, const std::string& to);
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALUNRENAMER_H_ */
