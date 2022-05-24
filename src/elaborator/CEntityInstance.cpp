#include "CEntityInstance.h"

namespace vhdl
{

CEntityInstance::CEntityInstance(const char* instanceName, const CEntity* architecture, const CEntityInstance* parent) :
		_instanceName(instanceName),
		_architecture(architecture),
		_parent(parent)
{

}

CEntityInstance::~CEntityInstance()
{
	for(CEntityInstance* c : _children)
	{
		delete c;
	}
}

const CEntity* CEntityInstance::getArchitecture() const
{
	return _architecture;
}

const CEntityInstance* CEntityInstance::getParent() const
{
	return _parent;
}

const std::string& CEntityInstance::getInstanceName() const
{
	return _instanceName;
}

CEntityInstance* CEntityInstance::addChildEntity(const char* instanceName, const CEntity* architecture)
{
	CEntityInstance* newEntry = new CEntityInstance(instanceName, architecture, this);
	_children.push_back(newEntry);
	return newEntry;
}

} /* namespace vhdl */
