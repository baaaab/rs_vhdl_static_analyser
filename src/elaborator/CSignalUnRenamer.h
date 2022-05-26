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

private:
	void replaceElementInVector(std::vector<CSignal*>& haystack, CSignal* needle, CSignal* replace);
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALUNRENAMER_H_ */
