#ifndef SRC_PARSER_CPARSER_H_
#define SRC_PARSER_CPARSER_H_

#include <string>
#include <vector>

#include "../language/CEntity.h"
#include "../language/CSignal.h"
#include "../output/ELogLevel.h"

namespace vhdl
{

class CParser
{
public:
	CParser();
	virtual ~CParser();

	void parse(const std::string& filename);

	std::vector<CEntity*>& getEntities();

	const CPortMap* getTopPortMap() const;

private:

	void parseBlock(std::vector<std::string>::iterator& itr);
	std::vector<std::string> readLines(const std::string& filename);

	// toplevel parsers
	void parseLibrary(std::vector<std::string>::iterator& itr);
	void parseUse(std::vector<std::string>::iterator& itr);
	void parseEntity(std::vector<std::string>::iterator& itr);
	void parseArchitecture(std::vector<std::string>::iterator& itr);

	// architecture parsers
	void parseSignals(std::vector<std::string>::iterator& itr, CEntity* entity);
	// clockSignal may be null
	CSignal* parseAssignment(std::vector<std::string>::iterator& itr, CEntity* entity, CSignal* clockSignal = nullptr, std::vector<CSignal*> additionalContributors = {});
	void parseProcess(std::vector<std::string>::iterator& itr, CEntity* entity);
	void parseWithSelect(std::vector<std::string>::iterator& itr, CEntity* entity);
	void parseInstantiation(std::vector<std::string>::iterator& itr, CEntity* parentEntity);

	// process parsers
	std::vector<std::string> parseProcessDefinitions(std::vector<std::string>::iterator& itr, CEntity* entity);

	void error(ELogLevel level, std::vector<std::string>::iterator& itr);

	uint32_t getLineNumberFromIterator(std::vector<std::string>::iterator& itr);

	const CEntity* findToplevelEntity() const;

	std::vector<std::string> _lines;

	std::string _currentLibrary;
	std::string _sourceFileName;

	std::vector<CEntity*> _entities;

	CPortMap* _topPortMap;

};

} /* namespace vhdl */

#endif /* SRC_PARSER_CPARSER_H_ */
