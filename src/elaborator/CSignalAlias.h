#ifndef SRC_ELABORATOR_CSIGNALALIAS_H_
#define SRC_ELABORATOR_CSIGNALALIAS_H_

namespace vhdl
{
class CSignal;

class CSignalAlias
{
public:
	CSignalAlias(CSignal* driver, CSignal* driven);
	virtual ~CSignalAlias();

	const CSignal* getDriven() const;
	const CSignal* getDriver() const;

private:
	CSignal* _driver;
	CSignal* _driven;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALALIAS_H_ */
