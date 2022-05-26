#ifndef SRC_ELABORATOR_CNETLIST_H_
#define SRC_ELABORATOR_CNETLIST_H_

#include <vector>

#include "CSignalInstantiation.h"

namespace vhdl
{
class CEntity;

class CNetList
{
public:
	CNetList(const CEntity* architecture);
	virtual ~CNetList();

	std::vector<CSignalInstantiation*> findBySignal(const CEntityInstance* entityInstance, const CSignal* signal);

	// caller should not modify the vector (modifying members is ok)
	std::vector<CSignalInstantiation>& getNets();
	const std::vector<CSignalInstantiation>& getNets() const;

	void addNet(const CSignalInstantiation& net);

	CEntityInstance* getTopEntity();

private:
	std::vector<CSignalInstantiation> _netlist;

	CEntityInstance* _topEntity;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CNETLIST_H_ */
