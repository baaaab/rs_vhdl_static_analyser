#include "CInstantiationPort.h"

namespace vhdl
{

CInstantiationPort::CInstantiationPort(const CSignal* parentEntitySignal, const char* childEntityPortName) :
		_parentEntitySignal(parentEntitySignal),
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

const CSignal* CInstantiationPort::getParentEntitySignal() const
{
	return _parentEntitySignal;
}

void CInstantiationPort::setParentEntitySignal(const CSignal* parentEntitySignal)
{
	_parentEntitySignal = parentEntitySignal;
}

} /* namespace vhdl */
