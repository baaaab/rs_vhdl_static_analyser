#ifndef SRC_PARSER_CENTITY_H_
#define SRC_PARSER_CENTITY_H_

#include <map>
#include <string>
#include <vector>

#include "CPortMap.h"
#include "CSignal.h"

namespace vhdl
{

class CEntity
{
public:
	CEntity(const char* name);
	virtual ~CEntity();

	void addPort(const char* name, const char* direction, const char* type, const char* synthFile, uint32_t synthline);
	void addSignal(const char* name, const char* type, const char* synthFile, uint32_t synthline);

	void addConstant(const char* name, const char* type, const char* value, const char* synthFile, uint32_t synthline);
	void addSubType(const char* name, const char* type, const char* synthFile, uint32_t synthline);

	const std::string& getName() const;
	const std::vector<CSignal>& getSignals() const;

	const CSignal* findSignalByName(const char* name) const;
	CSignal* findSignalByName(const char* name);
	bool isConstant(const char* name) const;

	std::vector<CSignal*> getContributorsFromStatement(const char* statement);

	void addEntityInstance(const CPortMap& instance);
	const std::vector<CPortMap>& getChildEntityPortMaps() const;

private:
	std::string _name;

	std::vector<CSignal> _signals;

	// we don't care about the values for now, so just store the names
	std::vector<std::string> _constants;

	// key:name, value: definition
	std::map<std::string, std::string> _subTypes;

	std::vector<CPortMap> _entityInstances;

};

} /* namespace vhdl */

#endif /* SRC_PARSER_CENTITY_H_ */
