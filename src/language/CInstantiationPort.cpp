#include "CInstantiationPort.h"

namespace vhdl
{

CInstantiationPort::CInstantiationPort(CSignal* parentEntitySignalName, const char* childEntityPortName) :
		_parentEntitySignalName(parentEntitySignalName),
		_childEntityPortName(childEntityPortName)
{

}

CInstantiationPort::~CInstantiationPort()
{

}

const std::string& CInstantiationPort::getChildEntityPortName() const
{
	return _childEntityPortName;
}

const CSignal* CInstantiationPort::getParentEntitySignalName() const
{
	return _parentEntitySignalName;
}

} /* namespace vhdl */
