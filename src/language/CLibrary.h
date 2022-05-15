#ifndef SRC_LANGUAGE_CLIBRARY_H_
#define SRC_LANGUAGE_CLIBRARY_H_

#include <string>
#include <vector>

#include "CEntity.h"

namespace vhdl
{

class CLibrary
{
public:
	CLibrary();
	virtual ~CLibrary();

private:
	std::string _name;
	std::vector<CEntity> _entities;

};

} /* namespace vhdl */

#endif /* SRC_LANGUAGE_CLIBRARY_H_ */
