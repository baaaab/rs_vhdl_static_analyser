#ifndef SRC_LANGUAGE_CENTITYINSTANCE_H_
#define SRC_LANGUAGE_CENTITYINSTANCE_H_

#include <string>
#include <vector>

#include "CInstantiationPort.h"

namespace vhdl
{
class CEntity;

class CEntityInstance
{
public:
	CEntityInstance(const char* instanceName);
	virtual ~CEntityInstance();

	const std::string& getInstanceName() const;
	void setEntity(CEntity* entity);
	void addPortMapping(CSignal* driver, const char* driven);

	const CEntity* getEntity() const;

	// list may not cover all ports if any were open or wired to constants
	const std::vector<CInstantiationPort>& getPortMappings() const;

private:

	std::string _instanceName;
	CEntity* _entity;
	std::vector<CInstantiationPort> _portMappings;
};

} /* namespace vhdl */

#endif /* SRC_LANGUAGE_CENTITYINSTANCE_H_ */
