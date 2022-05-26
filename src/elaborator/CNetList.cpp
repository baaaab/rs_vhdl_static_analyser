#include "CNetList.h"

#include <stddef.h>

#include "CEntityInstance.h"
#include "CEntitySignalPair.h"

namespace vhdl
{

CNetList::CNetList(const CEntity* architecture) :
		_topEntity(NULL)
{
	_topEntity = new CEntityInstance("[top]", architecture, NULL);
}

CNetList::~CNetList()
{
	delete _topEntity;
}

std::vector<CSignalInstantiation*> CNetList::findBySignal(const CEntityInstance* entityInstance, const CSignal* signal)
{
	std::vector<CSignalInstantiation*> ret;
	for(CSignalInstantiation& net : _netlist)
	{
		for(const CEntitySignalPair& sp : net.getDefinitions())
		{
			if(sp.getEntityInstance() == entityInstance && sp.getSignal() == signal)
			{
				ret.push_back(&net);
			}
		}
	}
	return ret;
}

std::vector<CSignalInstantiation>& CNetList::getNets()
{
	return _netlist;
}

const std::vector<CSignalInstantiation>& CNetList::getNets() const
{
	return _netlist;
}

void CNetList::addNet(const CSignalInstantiation& net)
{
	_netlist.push_back(net);
}

CEntityInstance* CNetList::getTopEntity()
{
	return _topEntity;
}

} /* namespace vhdl */
