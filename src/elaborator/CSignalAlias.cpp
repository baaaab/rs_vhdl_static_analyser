#include "CSignalAlias.h"

namespace vhdl
{

CSignalAlias::CSignalAlias(CSignal* driver, CSignal* driven) :
		_driver(driver),
		_driven(driven)
{

}

CSignalAlias::~CSignalAlias()
{

}

const CSignal* CSignalAlias::getDriven() const
{
	return _driven;
}

const CSignal* CSignalAlias::getDriver() const
{
	return _driver;
}

} /* namespace vhdl */
