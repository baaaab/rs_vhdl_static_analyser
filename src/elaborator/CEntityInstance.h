#ifndef SRC_ELABORATOR_CENTITYINSTANCE_H_
#define SRC_ELABORATOR_CENTITYINSTANCE_H_

#include <string>
#include <vector>

namespace vhdl
{
class CPortMap;
class CEntity;

/*
 * This class represents a unique entity instantiation somewhere known in the elaborated design
 * There is overlap with CPortMap
 */

class CEntityInstance
{
public:
	// parent is owned by caller
	CEntityInstance(const char* instanceName, const CEntity* architecture, const CEntityInstance* parent);
	virtual ~CEntityInstance();

	const CEntity* getArchitecture() const;
	const CEntityInstance* getParent() const;
	const std::string& getInstanceName() const;

	CEntityInstance* addChildEntity(const char* instanceName, const CEntity* architecture);

private:
	std::string _instanceName;
	const CEntity* _architecture;
	const CEntityInstance* _parent;

	std::vector<CEntityInstance*> _children;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CENTITYINSTANCE_H_ */
