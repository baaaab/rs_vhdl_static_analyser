#ifndef SRC_ELABORATOR_CSIGNALINSTANTIATION_H_
#define SRC_ELABORATOR_CSIGNALINSTANTIATION_H_

#include <string>
#include <vector>
#include <set>

#include "CEntitySignalPair.h"

namespace vhdl
{
class CEntityInstance;
class CSignal;

class CSignalInstantiation
{
public:
	CSignalInstantiation();
	virtual ~CSignalInstantiation();

	const std::vector<CEntitySignalPair>& getDefinitions() const;
	const CSignalInstantiation* getClock() const;
	const std::vector<CSignalInstantiation*>& getDirectDrivers() const;

	void addDefinition(const CEntityInstance* entity, const CSignal* signal);
	void addDirectDriver(CSignalInstantiation* signalInstance);
	void setClock(const CSignalInstantiation* clockSignalInstance);

	std::string generateUniqueIdentifier() const;

	// is any definition userdefined (if there are multiple definitions one at least will be user defined)
	bool isUserDefined() const;

	bool isClocked() const;

	std::set<int> calculateNumberofRegisterStages() const;

	static std::set<int> CountNumberOfRegisterStagesToInput(const CSignalInstantiation* signal, const CSignalInstantiation* clock,
	    std::set<std::pair<const CSignalInstantiation*, const CSignalInstantiation*>>& followedPaths);

private:
	std::vector<CEntitySignalPair> _definitions;

	// these drivers may have their own drivers too
	std::vector<CSignalInstantiation*> _directDrivers;

	// may be NULL
	const CSignalInstantiation* _clock;

	static const CSignalInstantiation* GetDriverClockRecursive(const CSignalInstantiation* signal, std::set<const CSignalInstantiation*>& checkedSignals);

};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CSIGNALINSTANTIATION_H_ */
