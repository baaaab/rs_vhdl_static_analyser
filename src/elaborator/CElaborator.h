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
	void elaborateSignalsFromEntity(CEntityInstance* entityInstance, int recursionDepth = 0);

	void printNetlist();

private:
	void printSignalIfUnprinted(const std::string& signalName, bool& printed);

	CParser* _parser;

	CNetList* _netlist;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CELABORATOR_H_ */
