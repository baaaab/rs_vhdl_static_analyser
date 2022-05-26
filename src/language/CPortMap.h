#ifndef SRC_LANGUAGE_CPORTMAP_H_
#define SRC_LANGUAGE_CPORTMAP_H_

#include <string>
#include <vector>

#include "CInstantiationPort.h"

namespace vhdl
{
class CEntity;

/*
 * This class represents an instantion of an entity in an architecture.
 */

class CPortMap
{
public:
	CPortMap(const char* instanceName);
	virtual ~CPortMap();

	const std::string& getInstanceName() const;
	void setEntity(const CEntity* entity);
	void addPortMapping(CSignal* driver, const char* driven);

	const CEntity* getEntity() const;

	// list may not cover all ports if any were open or wired to constants
	const std::vector<CInstantiationPort>& getPortMappings() const;

	void replaceSignal(CSignal* find, CSignal* replace);

private:

	std::string _instanceName;
	const CEntity* _entity;
	std::vector<CInstantiationPort> _portMappings;
};

} /* namespace vhdl */

#endif /* SRC_LANGUAGE_CPORTMAP_H_ */
