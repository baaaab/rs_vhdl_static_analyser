#ifndef SRC_ELABORATOR_CELABORATOR_H_
#define SRC_ELABORATOR_CELABORATOR_H_

#include <string>

namespace vhdl
{
class CEntity;
class CParser;

class CElaborator
{
public:
	CElaborator(CParser* parser);
	virtual ~CElaborator();

	void printUnassignedSignals();
	void elaborateSignals(const char* entityPath);

private:
	void printSignalIfUnprinted(const std::string& signalName, bool& printed);

	CEntity* findToplevelEntity(const char* entityName);

	CParser* _parser;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CELABORATOR_H_ */
