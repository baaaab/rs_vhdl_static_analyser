#include "CEntityInstance.h"

namespace vhdl
{

CEntityInstance::CEntityInstance(const char* instanceName) :
		_instanceName(instanceName),
		_entity(nullptr)
{

}

CEntityInstance::~CEntityInstance()
{

}

const std::string& CEntityInstance::getInstanceName() const
{
	return _instanceName;
}

void CEntityInstance::setEntity(CEntity* entity)
{
	_entity = entity;
}

void CEntityInstance::addPortMapping(CSignal* driver, const char* driven)
{
	_portMappings.emplace_back(driver, driven);
}

const CEntity* CEntityInstance::getEntity() const
{
	return _entity;
}

const std::vector<CInstantiationPort>& CEntityInstance::getPortMappings() const
{
	return _portMappings;
}

} /* namespace vhdl */
