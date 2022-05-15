#ifndef SRC_ELABORATOR_CSIGNALINSTANTIATION_H_
#define SRC_ELABORATOR_CSIGNALINSTANTIATION_H_

#include <utility>
#include <vector>

#include "../language/CEntity.h"
#include "../language/CSignal.h"

namespace vhdl
{

class CSignalInstantiation
{
public:
	CSignalInstantiation();
	virtual ~CSignalInstantiation();

private:
	std::vector<std::pair<CEntity*, CSignal*>> definitions;
	std::vector<CSignalInstantiation*> _drivers;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALINSTANTIATION_H_ */
