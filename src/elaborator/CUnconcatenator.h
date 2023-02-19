#ifndef SRC_ELABORATOR_CUNCONCATENATOR_H_
#define SRC_ELABORATOR_CUNCONCATENATOR_H_

#include <vector>
#include <cstdint>

#include "../language/CPortMap.h"
#include "../language/CSignal.h"

namespace vhdl
{

class CUnconcatenator
{
public:
	CUnconcatenator();
	virtual ~CUnconcatenator();

	void simplifyEntityArchitecture(std::vector<CSignal*>& signals, std::vector<CPortMap>& entityInstances);

private:
	// but is not already in said array
	bool doesSignalDependOnOneOfTheseOtherSignalsFully(CSignal* signal, std::vector<CSignal*>& candidateSignals);
	bool doesSignalIndirectlyDependUponItsSelf(const CSignal* signalOfInterest, const CSignal* transitiveSignal, std::vector<const CSignal*>& checkedDependencies) const;
	bool isSignalOnlyReferencedInASlicedManner(const CSignal* signalOfInterest, std::vector<CSignal*>& allSignals, uint32_t elementSize) const;

	void replaceSignalsWithUnconcatenatedEquivalents(CSignal* concatenatedSignal, CSignal* slicedSignal, const std::vector<CSignal*>& signalsThatWillNeedReplacing, const std::string& replacementType, std::vector<CSignal*>& entitySignals, std::vector<CPortMap>& entityInstances);

	static bool ExtractSliceRangeFromAssignment(const char* assignmentRhs, const CSignal* signalOfInterest, uint32_t& upper, uint32_t& lower);
	static bool ExtractSliceRangeFromType(const char* type, uint32_t& upper, uint32_t& lower);
	static bool ParseSliceRange(const char* type, uint32_t& upper, uint32_t& lower);

	CSignal* findUnconcatenatedContributorSignal(std::vector<CSignal*>& signals, CSignal* concatenatedSignal, int index);

	bool isConstant(const char* signal);
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CUNCONCATENATOR_H_ */
