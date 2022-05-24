#include "CEntitySignalPair.h"

namespace vhdl
{

CEntitySignalPair::CEntitySignalPair(const CEntityInstance* entity, const CSignal* signal) :
		_entity(entity),
		_signal(signal)
{

}

CEntitySignalPair::~CEntitySignalPair()
{

}

const CEntityInstance* CEntitySignalPair::getEntityInstance() const
{
	return _entity;
}

const CSignal* CEntitySignalPair::getSignal() const
{
	return _signal;
}

} /* namespace vhdl */
