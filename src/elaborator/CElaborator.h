#ifndef SRC_ELABORATOR_CELABORATOR_H_
#define SRC_ELABORATOR_CELABORATOR_H_

#include <string>

namespace vhdl
{
class CEntityInstance;
class CNetList;
class CPortMap;
class CEntity;
class CParser;

class CElaborator
{
public:
	CElaborator(CParser* parser);
	virtual ~CElaborator();

	void printUnassignedSignals();
	void elaborateSignalsFromPath(const char* entityPath);



private:
	void elaborateSignalsFromEntity(CEntityInstance* entityInstance, int recursionDepth = 0);
	void elaborateNetlistDrivers();

public:
	void printNetlist();
	const CNetList* getNetlist() const;

private:
	void printSignalIfUnprinted(const std::string& signalName, bool& printed);

	CParser* _parser;

	CNetList* _netlist;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CELABORATOR_H_ */
