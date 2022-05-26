#include "CParser.h"

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <cstdio>
#include <iterator>
#include <unistd.h>
#include <unordered_set>

#include "../language/CEntity.h"
#include "../output/CLogger.h"

namespace vhdl
{

CParser::CParser() :
		_topPortMap(nullptr)
{

}

CParser::~CParser()
{
	delete _topPortMap;

	for(CEntity* entity : _entities)
	{
		delete entity;
	}
	_entities.clear();
}

void CParser::parse(const std::string& filename)
{
	if(!_entities.empty())
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "parse() should only be called once");
		throw 1;
	}

	_sourceFileName = filename;
	_lines = readLines(filename);

	for(std::vector<std::string>::iterator itr = _lines.begin(); itr != _lines.end();)
	{
		//CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%s:[%zu] %s", _sourceFileName.c_str(), getLineNumberFromIterator(itr), itr->c_str());

		parseBlock(itr);
	}

	_topPortMap = new CPortMap("");
	_topPortMap->setEntity(findToplevelEntity());
}

std::vector<CEntity*>& CParser::getEntities()
{
	return _entities;
}

const CPortMap* CParser::getTopPortMap() const
{
	return _topPortMap;
}

void CParser::parseBlock(std::vector<std::string>::iterator& itr)
{
	const char* ptr = itr->c_str();

	if(*ptr == 0)
	{
		// empty line
		++itr;
	}
	else if(strstr(ptr, "library") == ptr)
	{
		parseLibrary(itr);
	}
	else if(strstr(ptr, "use") == ptr)
	{
		parseUse(itr);
	}
	else if(strstr(ptr, "entity") == ptr)
	{
		parseEntity(itr);
	}
	else if(strstr(ptr, "architecture") == ptr)
	{
		parseArchitecture(itr);
	}
	else
	{
		exit(1);
	}
}

std::vector<std::string> CParser::readLines(const std::string& filename)
{
	std::vector<std::string> lines;

	FILE* fh = fopen(filename.c_str(), "r");
	if(!fh)
	{
		//error
		throw 1;
	}

	size_t lineBufferSize = 1024;
	char* lineBuffer = (char*)malloc(lineBufferSize);

	ssize_t lineBytes = 0;

	while((lineBytes = getline(&lineBuffer, &lineBufferSize, fh)) != -1)
	{
		if(lineBytes >= 2)
		{
			lines.emplace_back(lineBuffer, lineBuffer + lineBytes - 1);
		}
		else
		{
			lines.emplace_back("");
		}
	}

	return lines;
}

void CParser::parseLibrary(std::vector<std::string>::iterator& itr)
{
	const char* prefix = "library ";
	const char* ptr = strstr(itr->c_str(), prefix);

	if(ptr == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Missing library in library string");
		error(ELogLevel::FATAL, itr);
	}

	ptr += strlen(prefix);

	char libraryName[256] = {0};

	for(uint32_t i=0; i< sizeof(libraryName) && ptr[i] != ';'; i++)
	{
		libraryName[i] = ptr[i];
	}

	_currentLibrary = libraryName;

	++itr;
}

void CParser::parseUse(std::vector<std::string>::iterator& itr)
{
	// we can probably ignore this

	++itr;
}

void CParser::parseEntity(std::vector<std::string>::iterator& itr)
{
	const char* prefix = "entity ";
	const char* ptr = strstr(itr->c_str(), prefix);

	if(ptr == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Missing entity in entity definition");
		error(ELogLevel::FATAL, itr);
	}

	ptr += strlen(prefix);

	char entityName[256] = {0};

	for(uint32_t i=0; i< sizeof(entityName) && ptr[i] != ' '; i++)
	{
		entityName[i] = ptr[i];
	}

	// skip rest of line
	++itr;

	// port map
	if(strstr("  port (", itr->c_str()) == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected port");
		error(ELogLevel::FATAL, itr);
	}

	++itr;

	CEntity* entity = new CEntity(entityName);

	bool closeBracketOnFinalPortLine = false;

	// expect list of ports
	while(1)
	{
		char* copy = strdup(itr->c_str());
		char* line = copy;
		while(*line == ' ' || *line == '\t')
		{
			line++;
		}

		char* state = NULL;
		// there might not be a space brefore the colon
		char* portName = strtok_r(line, ":", &state);
		char* direction = strtok_r(NULL, " ", &state);
		char* type = strtok_r(NULL, "", &state);

		if(portName == NULL || direction == NULL || type == NULL)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Error parsing ports in entity: '%s'", entityName);
			error(ELogLevel::FATAL, itr);
		}

		char* trim = portName;
		while(*trim)
		{
			if(*trim == ' ')
			{
				*trim = 0;
				break;
			}
			trim++;
		}

		int openBracketCount = 0;
		int closeBracketCount = 0;
		char* cc = type;
		while(*cc)
		{
			if(*cc == '(')
			{
				openBracketCount++;
			}
			else if(*cc == ')')
			{
				closeBracketCount++;
			}
			cc++;
		}

		bool isFinalPort = false;
		int length = strlen(type);
		if(closeBracketCount > openBracketCount && type[length-2] == ')' && type[length-1] == ';')
		{
			closeBracketOnFinalPortLine = true;
			isFinalPort = true;
			type[length-2] = 0;
		}
		else if(type[length-1] == ';')
		{
			type[length-1] = 0;
		}
		else
		{
			isFinalPort = true;
		}

		entity->addPort(portName, direction, type, _sourceFileName.c_str(), getLineNumberFromIterator(itr));

		//CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%s : %s %s", portName, direction, type);

		++itr;

		free(copy);

		if(isFinalPort)
		{
			break;
		}
	}

	if(!closeBracketOnFinalPortLine)
	{
		// close port map
		if(strcmp("  );", itr->c_str()) != 0)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected close of port list");
			error(ELogLevel::FATAL, itr);
		}

		++ itr;
	}

	// end entity
	char endEntityLine[256];
	snprintf(endEntityLine, sizeof(endEntityLine), "end %s;", entityName);
	char endEntityLineAlt[256];
	snprintf(endEntityLineAlt, sizeof(endEntityLineAlt), "end entity %s;", entityName);
	if(strcmp(endEntityLine, itr->c_str()) != 0 && strcmp(endEntityLineAlt, itr->c_str()) != 0)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected close of entity");
		error(ELogLevel::FATAL, itr);
	}

	++itr;

	_entities.push_back(entity);
}

void CParser::parseArchitecture(std::vector<std::string>::iterator& itr)
{
	CEntity* entity = NULL;
	for(CEntity* possibleEntity : _entities)
	{
		char architectureLine[256];
		snprintf(architectureLine, sizeof(architectureLine), "architecture rtl of %s is", possibleEntity->getName().c_str());
		if(strcmp(architectureLine, itr->c_str()) == 0)
		{
			entity = possibleEntity;
			break;
		}
	}

	if(entity == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unseen entity in architecture line");
		error(ELogLevel::FATAL, itr);
	}

	++itr;

	parseSignals(itr, entity);

	// begin
	++itr;

	while(strcmp("end rtl;", itr->c_str()) != 0)
	{
		// handle assignment, comment, process or entity instantiation, with/select
		char* copy = strdup(itr->c_str());
		char* line = copy;
		while(*line == ' ' || *line == '\t')
		{
			line++;
		}

		char* state = NULL;
		char* firstWord = strtok_r(line, " ", &state);

		//CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "First word = '%s'", firstWord);

		if(firstWord == NULL)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: FUUUUUUCK");
			error(ELogLevel::FATAL, itr);
		}

		if(strcmp(firstWord, "process") == 0)
		{
			parseProcess(itr, entity);
		}
		else if(strcmp(firstWord, "with") == 0)
		{
			parseWithSelect(itr, entity);
		}
		else
		{
			char* signalNameCopy = strdup(firstWord);
			char* signalNameCopyPtr = signalNameCopy;
			while(*signalNameCopyPtr)
			{
				if(*signalNameCopyPtr == '.')
				{
					*signalNameCopyPtr = 0;
					break;
				}
				signalNameCopyPtr++;
			}
			const CSignal* signal = entity->findSignalByName(signalNameCopy);
			if(signal != NULL)
			{
				parseAssignment(itr, entity);
			}
			else
			{
				// probably an entity instantiation
				parseInstantiation(itr, entity);
			}
			free(signalNameCopy);
		}

		free(copy);
	}

	//end rtl
	++itr;

	entity->simplify();
}

void CParser::parseSignals(std::vector<std::string>::iterator& itr, CEntity* entity)
{
	// handle signal, constant, subtype
	while(strcmp("begin", itr->c_str()) != 0)
	{
		char* copy = strdup(itr->c_str());
		char* line = copy;
		while(*line == ' ' || *line == '\t')
		{
			line++;
		}

		char* state = NULL;
		char* lineType = strtok_r(line, " ", &state);

		if(lineType == NULL)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Error parsing signals list in architecture of entity:", entity->getName().c_str());
			error(ELogLevel::FATAL, itr);
		}

		if(strcmp(lineType, "signal") == 0)
		{
			// signal shreg : std_logic_vector (3 downto 0);
			// signal wrap_reset: std_logic;
			char* signalName = strtok_r(NULL, " ", &state);
			char* colon = NULL;
			int strlenSignalName = strlen(signalName);
			if(signalName && signalName[strlenSignalName-1] == ':')
			{
				signalName[strlenSignalName-1] = 0;
				// must be non null
				colon = signalName;
			}
			else
			{
				colon = strtok_r(NULL, " ", &state);
			}
			char* type = strtok_r(NULL, "", &state);

			if(signalName == NULL || colon == NULL || type == NULL)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected signal format");
				error(ELogLevel::FATAL, itr);
			}

			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%s : %s", signalName, type);

			entity->addSignal(signalName, type, _sourceFileName.c_str(), getLineNumberFromIterator(itr));
		}
		else if(strcmp(lineType, "constant") == 0)
		{
			//constant n194_o : std_logic := '1';
			char* constantName = strtok_r(NULL, " ", &state);
			char* colon = strtok_r(NULL, " ", &state);
			char* type = strtok_r(NULL, " ", &state);
			char* assignmentOperator = strtok_r(NULL, " ", &state);
			char* value = strtok_r(NULL, ";", &state);

			if(constantName == NULL || colon == NULL || type == NULL || assignmentOperator == NULL || value == NULL)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected constant format");
				error(ELogLevel::FATAL, itr);
			}

			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%s : %s := %s", constantName, type, value);

			entity->addConstant(constantName, type, value, _sourceFileName.c_str(), getLineNumberFromIterator(itr));
		}
		else if(strcmp(lineType, "subtype") == 0)
		{
			//subtype typwrap_din_q is std_logic_vector (7 downto 0);
			char* subTypeName = strtok_r(NULL, " ", &state);
			char* is = strtok_r(NULL, " ", &state);
			char* type = strtok_r(NULL, ";", &state);

			if(subTypeName == NULL || is == NULL || type == NULL)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected subtype format");
				error(ELogLevel::FATAL, itr);
			}

			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "%s is %s", subTypeName, type);

			entity->addSubType(subTypeName, type, _sourceFileName.c_str(), getLineNumberFromIterator(itr));
		}
		else
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected entry in %s architecture definitions", entity->getName().c_str());
			error(ELogLevel::FATAL, itr);
		}

		++itr;

		free(copy);
	}

	for(const CSignal* signal : entity->getSignals())
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "'%s'", signal->getName().c_str());
	}
}

CSignal* CParser::parseAssignment(std::vector<std::string>::iterator& itr, CEntity* entity, CSignal* clockSignal, std::vector<CSignal*> additionalContributors)
{
	// q <= n304_o;
	// n35_o <= std_logic_vector (unsigned (ram_wr_addr) + unsigned'("000000001"));
	// 38_o <= n36_o when wrap_reset = '0' else "000000000";
	// n147_o <= ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
	// n3_o <= n147_o (15 downto 8);
	// dout.valid <= wrap_dout_valid;
	// n177_o <= std_logic_vector (resize (signed (din_q_rr), 16));  --  sext

	char* copy = strdup(itr->c_str());
	char* line = copy;
	while(*line == ' ' || *line == '\t')
	{
		line++;
	}

	char* state = NULL;
	char* lhs = strtok_r(line, " ", &state);
	char* assignmentOperator = strtok_r(NULL, " ", &state);

	if(assignmentOperator == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected assignment statement");
		error(ELogLevel::FATAL, itr);
	}

	if(assignmentOperator[0] == '(')
	{
		// we are using array notation
		char* arrayNotation = strdup(itr->c_str());
		char* state2 = NULL;
		char* lhs2 = strtok_r(arrayNotation, " ", &state2);
		char* remainder = strtok_r(NULL, "", &state2);

		char* assignmentOperator2 = strstr(remainder, ":=");
		if(assignmentOperator2 == NULL)
		{
			assignmentOperator2 = strstr(remainder, "<=");
		}

		if(assignmentOperator2 == NULL)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Assignment operator missing in assignment statement");
			error(ELogLevel::FATAL, itr);
		}

		*assignmentOperator2 = 0;

		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Parsing array assignment: '%s', lhs2 = '%s'", remainder, lhs2);

		std::vector<CSignal*> contributorsFromArrayNotation = entity->getContributorsFromStatement(remainder);
		// store these  array additional contributors with the others
		additionalContributors.insert(additionalContributors.end(), contributorsFromArrayNotation.begin(), contributorsFromArrayNotation.end());

		// now we need to update the original strtok_r
		while(strcmp(assignmentOperator, "<=") != 0 && strcmp(assignmentOperator, ":=") != 0)
		{
			assignmentOperator = strtok_r(NULL, " ", &state);
		}

		free(arrayNotation);
	}
	else
	{
		if(strcmp(assignmentOperator, "<=") == 0)
		{
			// valid anywhere
		}
		else if(strcmp(assignmentOperator, ":=") == 0)
		{
			if(clockSignal == NULL)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Using ':=' operator in unclocked statement");
				error(ELogLevel::FATAL, itr);
			}
		}
		else
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected assignment operator: '%s'", assignmentOperator);
			error(ELogLevel::FATAL, itr);
		}
	}

	char* rhs = strtok_r(NULL, ";", &state);

	if(lhs == NULL || assignmentOperator == NULL || rhs == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected assignment in %s", entity->getName().c_str());
		error(ELogLevel::FATAL, itr);
	}

	char* dotPtr = strstr(lhs, ".");
	if(dotPtr != NULL)
	{
		// this is a record assignment. We really could do with an extra stage that converts records into their components
		// for now ignore it, whats the worst that could happen?
		// Well we could miss bugs, but whatever
		*dotPtr = 0;
	}

	CSignal* signal = entity->findSignalByName(lhs);

	if(signal == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: LHS signal of assignment: '%s' not found in %s", lhs, entity->getName().c_str());
		error(ELogLevel::FATAL, itr);
	}

	CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Assignment: LHS: '%s', RHS: '%s'", lhs, rhs);

	std::vector<CSignal*> contributors = entity->getContributorsFromStatement(rhs);
	contributors.insert(contributors.end(), additionalContributors.begin(), additionalContributors.end());

	if(clockSignal)
	{
		signal->setClockedContributors(clockSignal, contributors);
	}
	else
	{
		signal->setCombinatorialContributors(contributors);
	}
	signal->setAssignmentStatementRhs(rhs);

	CSourceLocation sourceLocation;
	sourceLocation.setFromFileAndline(_sourceFileName, getLineNumberFromIterator(itr));
	signal->setSynthAssignment(sourceLocation);

	free(copy);

	++itr;

	// we might expect a comment here
	const char* ptr = itr->c_str();
	while(*ptr == ' ' || *ptr == '\t')
	{
		ptr++;
	}

	if(ptr[0] == '-' && ptr[1] == '-')
	{
		//CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Handling comment: '%s'", ptr);
		if(sourceLocation.setFromComment(ptr))
		{
			signal->setSourceAssignment(sourceLocation);
			++itr;
		}
	}

	return signal;
}

void CParser::parseProcess(std::vector<std::string>::iterator& itr, CEntity* entity)
{
	/*
	process (clk)
  begin
    if rising_edge (clk) then
      n159_q <= din_i;
    end if;
  end process;
  -- entities/abs_square.vhd:43:5
	 */

	/*
	process (clkb, clka, clkb, clka) is
    type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
  begin
    if rising_edge (clkb) and (enb = '1') then
      n293_data <= ram(to_integer (unsigned (addrb)));
    end if;
    if rising_edge (clka) and (ena = '1') then
      n294_data <= ram(to_integer (unsigned (addra)));
    end if;
    if rising_edge (clkb) and (n275_o = '1') then
      ram (to_integer (unsigned (addrb))) := dib;
    end if;
    if rising_edge (clka) and (n256_o = '1') then
      ram (to_integer (unsigned (addra))) := dia;
    end if;
  end process;
  -- entities/async_dpram.vhd:56:5
  -- entities/async_dpram.vhd:45:5
  -- entities/async_dpram.vhd:60:15
  -- entities/async_dpram.vhd:49:15
	 */

	const char* prefix = "process (";
	const char* ptr = strstr(itr->c_str(), prefix);

	if(ptr == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Missing process in process definition");
		error(ELogLevel::FATAL, itr);
	}

	std::unordered_set<CSignal*> clocks;

	ptr += strlen(prefix);

	while(1)
	{
		char clockSignalName[256] = {0};
		char* dstPtr = clockSignalName;
		while(*ptr != ',' && *ptr != ')')
		{
			*dstPtr = *ptr;
			ptr++;
			dstPtr++;
		}
		CSignal* clockSignal = entity->findSignalByName(clockSignalName);
		if(!clockSignal)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Found undefined clock signal: '%s' in process sensitivity list", clockSignalName);
			error(ELogLevel::FATAL, itr);
		}
		clockSignal->setIsClock(true);
		clocks.insert(clockSignal);

		if(*ptr == ')')
		{
			break;
		}
		while(*ptr == ',' || *ptr == ' ')
		{
			ptr++;
		}
	}

	for(CSignal* clock : clocks)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Found clock signal: '%s'", clock->getName().c_str());
	}

	++itr;

	std::vector<std::string> variables = parseProcessDefinitions(itr, entity);
	std::vector<CSignal*> assignedSignals;



	if(strcmp(itr->c_str(), "  begin") != 0)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected begin statement in process");
		error(ELogLevel::FATAL, itr);
	}
	++itr;

	while(strstr(itr->c_str(), "end process;") == NULL)
	{
		// we expect one or more if rising_edge(
		// possibly with additional conditional expressions
		ptr = itr->c_str();
		while(*ptr == ' ' || *ptr == '\t')
		{
			ptr++;
		}
		const char* prefix = "if rising_edge (";
		if(strstr(ptr, prefix) != ptr)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected 'if rising_edge(' in process");
			error(ELogLevel::FATAL, itr);
		}

		ptr += strlen(prefix);

		char clockSignalName[256] = {0};
		char* dstPtr = clockSignalName;
		while(*ptr != ')' && *ptr)
		{
			*dstPtr = *ptr;
			ptr++;
			dstPtr++;
		}

		CSignal* clockSignal = nullptr;
		for(CSignal* possibleClockSignal : clocks)
		{
			if(possibleClockSignal->getName() == clockSignalName)
			{
				clockSignal = possibleClockSignal;
				break;
			}
		}

		if(clockSignal == nullptr)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Found clock signal in rising_edge statement that was not in the sensitivity list: '%s'", clockSignalName);
			error(ELogLevel::FATAL, itr);
		}

		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Parsing if rising_edge() statement: '%s'", ptr);
		std::vector<CSignal*> clockedContibutorsFromIfStatement = entity->getContributorsFromStatement(ptr);

		++itr;

		// now parse a bunch of assignments
		while(1)
		{
			ptr = itr->c_str();
			while(*ptr == ' ' || *ptr == '\t')
			{
				ptr++;
			}
			const char* prefix = "end if;";
			if(strstr(ptr, prefix) == ptr)
			{
				++itr;
				break;
			}
			else
			{
				CSignal* lhs = parseAssignment(itr, entity, clockSignal, clockedContibutorsFromIfStatement);
				assignedSignals.push_back(lhs);
			}
		}
	}

	// end process;
	++itr;

	uint32_t assignmentIndex = 0;

	// we may now have a series of comments
	while(1)
	{
		ptr = itr->c_str();
		while(*ptr == ' ' || *ptr == '\t')
		{
			ptr++;
		}
		if(ptr[0] == '-' && ptr[1] == '-')
		{
			if(assignmentIndex < assignedSignals.size())
			{
				CSignal* signal = assignedSignals[assignmentIndex];
				CSourceLocation sourceLocation;
				if(sourceLocation.setFromComment(ptr))
				{
					signal->setSourceAssignment(sourceLocation);
					++itr;
					assignmentIndex++;
				}
				else
				{
					break;
				}
			}
			else
			{
				break;
			}
		}
		else
		{
			break;
		}
	}



}

void CParser::parseWithSelect(std::vector<std::string>::iterator& itr, CEntity* entity)
{
	/*
	with n127_o select n130_o <=
    threshold_reg when "10",
    "0000101100001011" when "01",
    "XXXXXXXXXXXXXXXX" when others;
	 */

	/*
	with n132_o select n133_o <=
    wrap_reg_wr_data when '1',
    threshold_reg when others;
	 */

	// aka: if n132_o = ? then n133_o <= x;
	const char* ptr = itr->c_str();
	while(*ptr == ' ' || *ptr == '\t')
	{
		ptr++;
	}

	char* copy = strdup(ptr);

	char* state = NULL;
	char* with = strtok_r(copy, " ", &state);
	char* readValue = strtok_r(NULL, " ", &state);
	char* select = strtok_r(NULL, " ", &state);
	char* writeValue = strtok_r(NULL, " ", &state);
	char* assign = strtok_r(NULL, "", &state);

	if(with == NULL || readValue == NULL || select == NULL || writeValue == NULL || assign == NULL ||
			strcmp(with, "with") != 0 || strcmp(select, "select") != 0)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Could not parse with/select statement");
		error(ELogLevel::FATAL, itr);
	}

	CSignal* readSignal = entity->findSignalByName(readValue);
	CSignal* writeSignal = entity->findSignalByName(writeValue);

	if(readSignal == NULL || writeSignal == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: with/select statement refers to unfound signals: '%s' = %p, '%s' = %p", readValue, readSignal, writeValue, writeSignal);
		error(ELogLevel::FATAL, itr);
	}

	free(copy);
	copy = NULL;
	++itr;

	CSourceLocation synthAssignmentLocation;
	synthAssignmentLocation.setFromFileAndline(_sourceFileName, getLineNumberFromIterator(itr));

	std::vector<CSignal*> allContributors;
	allContributors.push_back(readSignal);

	bool endFound = false;

	while(!endFound)
	{
		ptr = itr->c_str();
		while(*ptr == ' ' || *ptr == '\t')
		{
			ptr++;
		}

		copy = strdup(ptr);

		state = NULL;
		char* rhs = strtok_r(copy, " ", &state);
		/*char* when = */strtok_r(NULL, " ", &state);
		char* constant = strtok_r(NULL, "", &state);
		char* finalCharacter = constant + strlen(constant)-1;
		if(*finalCharacter == ';')
		{
			endFound = true;
		}
		*finalCharacter = 0;
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Parsing with/select, driven signal: '%s', value: '%s'", writeSignal->getName().c_str(), rhs);
		std::vector<CSignal*> contributors = entity->getContributorsFromStatement(rhs);
		allContributors.insert(allContributors.end(), contributors.begin(), contributors.end());
		++itr;
		free(copy);
	}

	writeSignal->setCombinatorialContributors(allContributors);
	writeSignal->setSynthAssignment(synthAssignmentLocation);

	// we expect a comment next
	ptr = itr->c_str();
	while(*ptr == ' ' || *ptr == '\t')
	{
		ptr++;
	}

	if(ptr[0] == '-' && ptr[1] == '-')
	{
		CSourceLocation sourceAssignmentLocation;
		sourceAssignmentLocation.setFromComment(ptr);
		writeSignal->setSourceAssignment(sourceAssignmentLocation);
		++itr;
	}
}

void CParser::parseInstantiation(std::vector<std::string>::iterator& itr, CEntity* parentEntity)
{
	/*
	dv : entity work.delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 port map (
	    clk => wrap_clk,
	    clken => n26_o,
	    d => abs_pow,
	    q => dv_q);
	  -- entities/delay_vector.vhd:34:15
	*/

	const char* ptr = itr->c_str();
	while(*ptr == ' ' || *ptr == '\t')
	{
		ptr++;
	}

	char* copy = strdup(ptr);

	char* state = NULL;
	char* instanceName = strtok_r(copy, " ", &state);
	char* colon = strtok_r(NULL, " ", &state);
	char* maybeEntity = strtok_r(NULL, " ", &state);
	if(instanceName == NULL || colon == NULL || strcmp(colon, ":") != 0 || maybeEntity == NULL)
	{
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: could not parse entity instantiation");
		error(ELogLevel::FATAL, itr);
	}
	else
	{
		if(strcmp(maybeEntity, "entity") != 0)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expecting instantiation of the form name : entity work.some_comp");
			error(ELogLevel::FATAL, itr);
		}
		else
		{
			char* libraryName = strtok_r(NULL, ".", &state);
			if(libraryName == NULL)
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expecting instantiation of the form name : entity work.some_comp");
				error(ELogLevel::FATAL, itr);
			}
			else
			{
				if(strcmp(libraryName, "work") != 0)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expecting all entities to be part of 'work'");
					error(ELogLevel::FATAL, itr);
				}
				else
				{
					CPortMap entityInstance(instanceName);

					char* entityName = strtok_r(NULL, " ", &state);
					char* portMap = strtok_r(NULL, "", &state);
					CEntity* entityPtr = NULL;
					if(entityName != NULL)
					{
						for(CEntity* entity : _entities)
						{
							if(entity->getName() == entityName)
							{

								entityPtr = entity;
								break;
							}
						}
						if(entityPtr == NULL)
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Undefined entity : '%s' instantiated", entityName);
							error(ELogLevel::FATAL, itr);
						}
						entityInstance.setEntity(entityPtr);
					}
					if(portMap == NULL || strcmp(portMap, "port map (") != 0)
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected port map");
						error(ELogLevel::FATAL, itr);
					}

					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Found entity instantiation '%s' of type: '%s'", instanceName, entityName);

					free(copy);
					++itr;

					bool endOfPartMapSeen = false;

					// now read the port map
					while(!endOfPartMapSeen)
					{
						ptr = itr->c_str();
						while(*ptr == ' ' || *ptr == '\t')
						{
							ptr++;
						}

						char portName[256] = {0};
						char localSignalName[256] = {0};

						char* dstPtr = portName;
						while(*ptr && *ptr != ' ')
						{
							*dstPtr = *ptr;
							dstPtr++;
							ptr++;
						}

						const char* mapOperator = " => ";
						if(strstr(ptr, mapOperator) != ptr)
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Expected ' => ' in each line of the port map");
							error(ELogLevel::FATAL, itr);
						}

						ptr += strlen(mapOperator);

						dstPtr = localSignalName;
						while(*ptr && *ptr != ',' && *ptr != ')')
						{
							*dstPtr = *ptr;
							dstPtr++;
							ptr++;
						}

						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "'%s' => '%s'", portName, localSignalName);

						if(*ptr == ')')
						{
							endOfPartMapSeen = true;
						}

						CSignal* localSignal = parentEntity->findSignalByName(localSignalName);
						if(localSignal == NULL)
						{
							if(strcmp(localSignalName, "open") == 0 || parentEntity->isConstant(localSignalName))
							{
								// do nothing (maybe?)
							}
							else
							{
								CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Undefined signal in port map: '%s'", localSignalName);
								error(ELogLevel::FATAL, itr);
							}
						}
						entityInstance.addPortMapping(localSignal, portName);

						++itr;
					}

					// there may be a comment at the end, skip it
					ptr = itr->c_str();
					while(*ptr == ' ' || *ptr == '\t')
					{
						ptr++;
					}

					if(ptr[0] == '-' && ptr[1] == '-')
					{
						++itr;
					}

					parentEntity->addEntityInstance(entityInstance);
				}
			}
		}
	}
}

std::vector<std::string> CParser::parseProcessDefinitions(std::vector<std::string>::iterator& itr, CEntity* entity)
{
	/*
	  type ram_type is array (0 to 511)
      of std_logic_vector (32 downto 0);
    variable ram : ram_type := (others => (others => 'X'));
	 */
	// most of the time this will return nothing
	std::vector<std::string> variables;

	// handle variable, type
	while(strcmp("  begin", itr->c_str()) != 0)
	{
		char* copy = strdup(itr->c_str());
		char* line = copy;
		while(*line == ' ' || *line == '\t')
		{
			line++;
		}

		char* state = NULL;
		char* lineType = strtok_r(line, " ", &state);

		if(lineType == NULL)
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL, "Parse Error: Unexpected blank line in process definitions");
			error(ELogLevel::FATAL, itr);
		}

		if(strcmp(lineType, "type") == 0)
		{
			// we don't handle the type, just skip it
			while(strchr(itr->c_str(), ';') == NULL)
			{
				++itr;
			}
		}
		else if(strcmp(lineType, "variable") == 0)
		{
			char* name = strtok_r(NULL, " ", &state);
			char* colon = strtok_r(NULL, " ", &state);
			char* type = strtok_r(NULL, " ", &state);
			if(colon && name && type)
			{
				variables.push_back(name);
				// this is a variable, not a signal, but close enough...
				entity->addSignal(name, type, _sourceFileName.c_str(), getLineNumberFromIterator(itr));
			}
		}

		free(copy);

		++itr;
	}

	return variables;
}

void CParser::error(ELogLevel level, std::vector<std::string>::iterator& itr)
{
	printf("%s: %s on line: %u:\n\t%s\n", CLogger::LogLevelToString(level), _sourceFileName.c_str(), getLineNumberFromIterator(itr), itr->c_str());
	throw 1;
}

uint32_t CParser::getLineNumberFromIterator(std::vector<std::string>::iterator& itr)
{
	return std::distance(_lines.begin(), itr)+1;
}


const CEntity* CParser::findToplevelEntity() const
{
	// good enough for now
	return _entities.front();
}


} /* namespace vhdl */
