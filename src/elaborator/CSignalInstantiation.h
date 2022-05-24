#ifndef SRC_ELABORATOR_CSIGNALINSTANTIATION_H_
#define SRC_ELABORATOR_CSIGNALINSTANTIATION_H_

#include <string>
#include <vector>

#include "CEntitySignalPair.h"

namespace vhdl
{
class CEntityInstance;
class CSignal;

class CSignalInstantiation
{
public:
	CSignalInstantiation();
	virtual ~CSignalInstantiation();

	const std::vector<CEntitySignalPair>& getDefinitions() const;
	void addDefinition(const CEntityInstance* entity, const CSignal* signal);

private:
	std::vector<CEntitySignalPair> _definitions;

};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALINSTANTIATION_H_ */
