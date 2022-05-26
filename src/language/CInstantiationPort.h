#ifndef SRC_LANGUAGE_CINSTANTIATIONPORT_H_
#define SRC_LANGUAGE_CINSTANTIATIONPORT_H_

#include <string>

namespace vhdl
{
class CSignal;

class CInstantiationPort
{
public:
	CInstantiationPort(const CSignal* parentEntitySignal, const char* childEntityPortName);
	virtual ~CInstantiationPort();

	const std::string& getChildEntityPortName() const;
	const CSignal* getParentEntitySignal() const;
	void setParentEntitySignal(const CSignal* parentEntitySignal);

private:
	const CSignal* _parentEntitySignal;
	std::string _childEntityPortName;
};

} /* namespace vhdl */

#endif /* SRC_LANGUAGE_CINSTANTIATIONPORT_H_ */
