#include "CPortMap.h"

namespace vhdl
{

CPortMap::CPortMap(const char* instanceName) :
		_instanceName(instanceName),
		_entity(nullptr)
{

}

CPortMap::~CPortMap()
{

}

const std::string& CPortMap::getInstanceName() const
{
	return _instanceName;
}

void CPortMap::setEntity(const CEntity* entity)
{
	_entity = entity;
}

void CPortMap::addPortMapping(CSignal* driver, const char* driven)
{
	_portMappings.emplace_back(driver, driven);
}

const CEntity* CPortMap::getEntity() const
{
	return _entity;
}

const std::vector<CInstantiationPort>& CPortMap::getPortMappings() const
{
	return _portMappings;
}

void CPortMap::replaceSignal(CSignal* find, CSignal* replace)
{
	for(CInstantiationPort& ip : _portMappings)
	{
		if(ip.getParentEntitySignal() == find)
		{
			ip.setParentEntitySignal(replace);
		}
	}
}

} /* namespace vhdl */
