#ifndef SRC_LANGUAGE_CINSTANTIATIONPORT_H_
#define SRC_LANGUAGE_CINSTANTIATIONPORT_H_

#include <string>

namespace vhdl
{
class CSignal;

class CInstantiationPort
{
public:
	CInstantiationPort(CSignal* parentEntitySignalName, const char* childEntityPortName);
	virtual ~CInstantiationPort();

	const std::string& getChildEntityPortName() const;
	const CSignal* getParentEntitySignal() const;

private:
	CSignal* _parentEntitySignalName;
	std::string _childEntityPortName;
};

} /* namespace vhdl */

#endif /* SRC_LANGUAGE_CINSTANTIATIONPORT_H_ */
