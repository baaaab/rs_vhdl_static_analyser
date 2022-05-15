#include "CEntity.h"

#include <stdlib.h>
#include <cstring>

#include "../output/CLogger.h"
#include "../output/ELogLevel.h"

namespace vhdl
{

CEntity::CEntity(const char* name) :
		_name(name)
{

}

CEntity::~CEntity()
{

}

void CEntity::addPort(const char* name, const char* direction, const char* type, const char* synthFile, uint32_t synthline)
{
	_signals.emplace_back(name, type, synthFile, synthline);
	CSignal& addedSignal = _signals.back();
	addedSignal.setIsPort(true);
	addedSignal.setIsUserDefined(true);
	if(strcmp(direction, "in") == 0)
	{
		addedSignal.setIsInput(true);
	}
	if(strcmp(direction, "out") == 0)
	{
		addedSignal.setIsOutput(true);
	}
	if(strcmp(direction, "inout") == 0)
	{
		addedSignal.setIsInput(true);
		addedSignal.setIsOutput(true);
	}
}

void CEntity::addSignal(const char* name, const char* type, const char* synthFile, uint32_t synthline)
{
	_signals.emplace_back(name, type, synthFile, synthline);
	CSignal& addedSignal = _signals.back();
	addedSignal.setIsPort(true);
	if(strstr(name, "wrap") == name)
	{
		addedSignal.setIsUserDefined(false);
	}
	else
	{
		const char* numberCheckPtr = NULL;
		if(name[0] == 'n')
		{
			numberCheckPtr = name+1;
		}
		else
		{
			const char* underScoreN = strstr(name, "_n");
			if(underScoreN)
			{
				numberCheckPtr = underScoreN + 2;
			}
		}
		if(numberCheckPtr != NULL)
		{
			uint32_t numberOfDigits = 0;
			while(*numberCheckPtr != 0 && *numberCheckPtr >= '0' && *numberCheckPtr <= '9')
			{
				numberOfDigits++;
				numberCheckPtr++;
			}
			if(numberOfDigits > 0)
			{
				addedSignal.setIsUserDefined(false);
			}
		}
	}
}

void CEntity::addConstant(const char* name, const char* type, const char* value, const char* synthFile, uint32_t synthline)
{
	// we ignore most of the arguments
	_constants.push_back(name);
}

void CEntity::addSubType(const char* name, const char* type, const char* synthFile, uint32_t synthline)
{
	// we ignore most of the arguments
	_subTypes[name] = type;
}

const std::string& CEntity::getName() const
{
	return _name;
}

const std::vector<CSignal>& CEntity::getSignals() const
{
	return _signals;
}

bool CEntity::isConstant(const char* name)
{
	for(const std::string& constant : _constants)
	{
		if(constant == name)
		{
			return true;
		}
	}
	return false;
}

CSignal* CEntity::findSignalByName(const char* name)
{
	for(CSignal& signal : _signals)
	{
		if(signal.getName() == name)
		{
			return &signal;
		}
	}
	return NULL;
}

std::vector<CSignal*> CEntity::getContributorsFromStatement(const char* statement)
{
	// n304_o;
	// std_logic_vector (unsigned (ram_wr_addr) + unsigned'("000000001"));
	// n36_o when wrap_reset = '0' else "000000000";
	// ram_out_pps_rr & ram_out_valid_rr & ram_out_q_rr & ram_out_i_rr;
	// n147_o (15 downto 8);
	// wrap_dout_valid;
	// std_logic_vector (resize (signed (din_q_rr), 16));  --  sext
	// n293_data <= ram(to_integer (unsigned (addrb)));

	const std::vector<std::string> reservedWords = {
			"std_logic_vector",
			"signed",
			"unsigned",
			"downto",
			"else",
			"then",
			"resize",
			"when",
			"to_integer",
			"and",
			"or",
			"xor",
			"not",
			"nand",
			"nor"
	};

	const char* delimiters = " ()+-&,*><;=";

	std::vector<CSignal*> contributors;

	char* copy = strdup(statement);

	char* state = NULL;
	bool first = true;

	while(1)
	{
		char* possibleContributor = strtok_r(first ? copy : NULL, delimiters, &state);
		first = false;
		if(possibleContributor == NULL)
		{
			break;
		}

		if(strstr(possibleContributor, "--") == possibleContributor)
		{
			// a comment
			break;
		}

		bool isReservedWord = false;
		for(const std::string& word : reservedWords)
		{
			if(word == possibleContributor)
			{
				isReservedWord = true;
				break;
			}
		}
		if(isReservedWord)
		{
			continue;
		}

		bool signalFound = false;
		for(CSignal& signal : _signals)
		{
			if(signal.getName() == possibleContributor)
			{
				contributors.push_back(&signal);
				signalFound = true;
				//CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Found contributor: '%s'", possibleContributor);
				break;
			}
			//printf("'%s' != '%s'\n", possibleContributor, signal.getName().c_str());
		}
		if(signalFound)
		{
			continue;
		}


		char startQuote = 0;
		bool allNumeric = true;
		char* ptr = possibleContributor;
		if(*ptr == '\'' || *ptr == '"')
		{
			startQuote = *ptr;
			ptr++;
		}
		while(*ptr && *ptr != startQuote)
		{
			if(*ptr < '0'|| *ptr > '9')
			{
				allNumeric = false;
			}
			ptr++;
		}
		if(*ptr == startQuote && allNumeric)
		{
			// this is a numeric constant, skip it
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Skipping constant: '%s'", possibleContributor);
		}
		else
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Unhandled statement contributor: '%s'", possibleContributor);
		}
	}

	free(copy);

	std::string contibutorsSerial = "";
	for(const CSignal* signal : contributors)
	{
		contibutorsSerial += ((contibutorsSerial.empty() ? "" : ", ") + signal->getName());
	}

	CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Contributors are: %s", contibutorsSerial.c_str());

	return contributors;
}

void CEntity::addEntityInstance(const CEntityInstance& instance)
{
	_entityInstances.push_back(instance);
}

} /* namespace vhdl */
