#include "CUnconcatenator.h"

#include <stdlib.h>
#include <algorithm>
#include <csignal>
#include <cstdio>
#include <cstring>
#include <iterator>
#include <map>
#include <set>
#include <string>
#include <utility>

#include "../output/CLogger.h"
#include "../output/ELogLevel.h"
#include "../parser/CSourceLocation.h"
#include "CSignalUnRenamer.h"

namespace vhdl
{

CUnconcatenator::CUnconcatenator()
{

}

CUnconcatenator::~CUnconcatenator()
{

}

void CUnconcatenator::simplifyEntityArchitecture(std::vector<CSignal*>& signals, std::vector<CPortMap>& entityInstances)
{
	/*
	 * GHDL replaces arrays with concatenations:
	 *
	 * original:
	 architecture archi of delay_vector is
	 type array_t is array(DELAY - 1 downto 0) of std_logic_vector(d'range);
	 signal shreg : array_t;
	 begin
	 process (clk) begin
	 if rising_edge(clk) then
	 if clken = '1' then
	 for i in 0 to DELAY-2 loop
	 shreg(i+1) <= shreg(i);
	 end loop;
	 shreg(0) <= d;
	 end if;
	 end if;
	 end process;

	 q <= shreg(DELAY - 1);

	 * GHDL synth:

	 architecture rtl of delay_vector_4_b2aa97e8911ab0960636412a10bb582b30f69335 is
	 signal shreg : std_logic_vector (63 downto 0);
	 signal n208_o : std_logic_vector (15 downto 0);
	 signal n209_o : std_logic_vector (15 downto 0);
	 signal n210_o : std_logic_vector (15 downto 0);
	 signal n211_o : std_logic_vector (63 downto 0);
	 signal n215_o : std_logic_vector (63 downto 0);
	 signal n216_q : std_logic_vector (63 downto 0);
	 signal n217_o : std_logic_vector (15 downto 0);
	 begin
	 q <= n217_o;
	 -- entities/delay_vector.vhd:21:10
	 shreg <= n216_q; -- (signal)
	 -- entities/delay_vector.vhd:28:30
	 n208_o <= shreg (15 downto 0);
	 -- entities/delay_vector.vhd:28:30
	 n209_o <= shreg (31 downto 16);
	 -- entities/delay_vector.vhd:28:30
	 n210_o <= shreg (47 downto 32);
	 -- entities/abs_square.vhd:66:3
	 n211_o <= n210_o & n209_o & n208_o & d;
	 -- entities/delay_vector.vhd:25:5
	 n215_o <= shreg when clken = '0' else n211_o;
	 -- entities/delay_vector.vhd:25:5
	 process (clk)
	 begin
	 if rising_edge (clk) then
	 n216_q <= n215_o;
	 end if;
	 end process;
	 -- entities/delay_vector.vhd:35:13
	 n217_o <= shreg (63 downto 48);
	 end rtl;

	 *
	 * We want to represent this as 4 register stages.
	 * This is basically intended for use with delab_bit and delay_vector
	 * New: Also for resolving other arrays too.
	 *
	 * This code will only work when using the syntax in the example above!
	 * It could be written better
	 *
	 * It also assumes all arrays are defined using (x downto 0) syntax, using `to` will lead to reversed indexes
	 */

	for (std::vector<CSignal*>::iterator itr = signals.begin(); itr != signals.end();)
	{
		bool vectorModified = false;
		CSignal* signal = *itr;

		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
											    "Considering Signal '%s'", signal->getName().c_str());

		const std::string& rhsAssignmentString = signal->getAssignmentStatementRhs();
		if (signal->getClock() == NULL && !rhsAssignmentString.empty())
		{
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
												    "\t unclocked and RHS assignment detected");

			// see if the RHS is a list of signals separated by ' & '
			std::vector<char*> componentSignalNames;

			char* copy = strdup(rhsAssignmentString.c_str());
			char* state = NULL;
			bool first = true;
			while (1)
			{
				char* signalName = strtok_r(first ? copy : NULL, " & ", &state);
				first = false;
				if (signalName == NULL)
				{
					break;
				}
				componentSignalNames.push_back(signalName);
			}

			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
												    "\t componentSignalNames.size() = %zu", componentSignalNames.size());

			if (componentSignalNames.size() > 1)
			{

				std::set<std::string> componentSignalTypes;
				bool allComponentSignalsLocatedOrConstant = true;
				for (const char* signalName : componentSignalNames)
				{
					bool signalFound = isConstant(signalName);
					if(!signalFound)
					{
						for (const CSignal* otherSignal : signals)
						{
							if (otherSignal->getName() == signalName)
							{
								signalFound = true;
								componentSignalTypes.insert(otherSignal->getType());
								break;
							}
						}
					}
					if (!signalFound)
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
					    "\t Missing signal : '%s'", signalName);
						allComponentSignalsLocatedOrConstant = false;
						break;
					}
				}

				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
									    "\t allComponentSignalsLocated = %d, componentSignalTypes.size() = %zu", allComponentSignalsLocatedOrConstant, componentSignalTypes.size());

				for(auto& type : componentSignalTypes)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
																			    "\t\t%s", type.c_str());
				}

				// make sure all components are signals, and they all have the same type
				if (allComponentSignalsLocatedOrConstant && componentSignalTypes.size() == 1)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
														    "\tallComponentSignalsLocatedOrConstant && componentSignalTypes.size() == 1");

					const char* stdLogicVectorLoc = strstr(signal->getType().c_str(), "std_logic_vector ");
					if (stdLogicVectorLoc == signal->getType().c_str())
					{
						// we need to propagate this up to a clocked assignment to be useful
						// this will involve replacing all signals that refer to our candidate without slicing it
						std::vector<CSignal*> signalsThatWillNeedReplacing;
						signalsThatWillNeedReplacing.push_back(signal);

						for (std::vector<CSignal*>::iterator itr2 = signals.begin(); itr2 != signals.end(); ++itr2)
						{
							if (doesSignalDependOnOneOfTheseOtherSignalsFully(*itr2, signalsThatWillNeedReplacing))
							{
								signalsThatWillNeedReplacing.push_back(*itr2);
								itr2 = signals.begin();
							}
						}

						if (!signalsThatWillNeedReplacing.empty())
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
																    "\t !signalsThatWillNeedReplacing.empty()");

							// we expect only one clocked assignment and we expect a circular dependency
							int numClockedAssignments = 0;
							CSignal* clockedAssignmentSignal = NULL;
							CSignal* slicedSignal = signal;
							for (CSignal* s : signalsThatWillNeedReplacing)
							{
								if (s->getClock())
								{
									numClockedAssignments++;
									clockedAssignmentSignal = s;
								}
								if (s->isUserDefined())
								{
									// this is not doing exactly what the names suggests, it may break in the future
									slicedSignal = s;
								}
							}

							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
																    "\tnumClockedAssignments = %u, slicedSignal = %p", numClockedAssignments, slicedSignal);

							if(slicedSignal)
							{
								if (numClockedAssignments == 1)
								{
									// go through clockedAssignmentSignal's transitive dependencies to see whether clockedAssignmentSignal appears in the list
									std::vector<const CSignal*> checkedSignals;
									if (doesSignalIndirectlyDependUponItsSelf(clockedAssignmentSignal, clockedAssignmentSignal, checkedSignals))
									{
										// this is a special case for delay_vector style signals, a more general case appears below
										CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
												"Signal %s of type %s assigned with '%s' is a candidate for unconcatenation (looks like a delay)", signal->getName().c_str(),
												signal->getType().c_str(), signal->getAssignmentStatementRhs().c_str());

										std::string otherRelatedSignalsSerialised;

										for (CSignal* s : signalsThatWillNeedReplacing)
										{
											otherRelatedSignalsSerialised += (otherRelatedSignalsSerialised.empty() ? "" : ", ") + s->getName();
										}

										CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "Related signals are: %s",
												otherRelatedSignalsSerialised.c_str());

										try
										{
											replaceSignalsWithUnconcatenatedEquivalents(signal, slicedSignal, signalsThatWillNeedReplacing,
													*componentSignalTypes.begin(), signals, entityInstances);

											// itr is invalidated, for simplicity just start from the beginning again
											itr = signals.begin();
											vectorModified = true;
										}
										catch(...)
										{

										}
									}
								}
								else if(numClockedAssignments == 0 && signal == slicedSignal) // this may depend on the unrenamer having run already
								{
									uint32_t sliceRangeUpper = 0;
									uint32_t sliceRangeLower = 0;
									ExtractSliceRangeFromType(componentSignalTypes.begin()->c_str(), sliceRangeUpper, sliceRangeLower);
									uint32_t typeSize = sliceRangeUpper + 1;

									if(isSignalOnlyReferencedInASlicedManner(slicedSignal, signals, typeSize))
									{
										CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO,
												"Signal %s of type %s assigned with '%s' is a candidate for unconcatenation (looks like an array)", signal->getName().c_str(),
												signal->getType().c_str(), signal->getAssignmentStatementRhs().c_str());

										std::string otherRelatedSignalsSerialised;

										for (CSignal* s : signalsThatWillNeedReplacing)
										{
											otherRelatedSignalsSerialised += (otherRelatedSignalsSerialised.empty() ? "" : ", ") + s->getName();
										}

										CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "Related signals are: %s",
												otherRelatedSignalsSerialised.c_str());

										try
										{
											replaceSignalsWithUnconcatenatedEquivalents(signal, slicedSignal, signalsThatWillNeedReplacing,
													*componentSignalTypes.begin(), signals, entityInstances);

											// itr is invalidated, for simplicity just start from the beginning again
											itr = signals.begin();
											vectorModified = true;
										}
										catch(...)
										{

										}
									}
								}
							}
						}
					}
				}
			}
			free(copy);
		}
		if (!vectorModified)
		{
			++itr;
		}
	}
}

bool CUnconcatenator::doesSignalDependOnOneOfTheseOtherSignalsFully(CSignal* signal, std::vector<CSignal*>& candidateSignals)
{
	if (std::find(candidateSignals.begin(), candidateSignals.end(), signal) != candidateSignals.end())
	{
		// already in the list, dont add again
		return false;
	}

	if (signal->getAssignmentStatementRhs().empty())
	{
		// cannot check dependencies
		return false;
	}

	if (signal->isPort())
	{
		// don't mess with ports
		return false;
	}

	const std::vector<CSignal*>& contributors = signal->getContributors();

	for (const CSignal* contributor : contributors)
	{
		for (CSignal* candidate : candidateSignals)
		{
			if (candidate == contributor)
			{
				// check the RHS assignment string to make sure that candidate is not followed by an open bracket
				const char* ptr = strstr(signal->getAssignmentStatementRhs().c_str(), candidate->getName().c_str());

				bool isSliced = false;

				/**printf("signalName = %s, contributor = %s, candidate = %s, RHS = '%s', ptr(pre) = %s, ",
				 signal->getName().c_str(),
				 contributor->getName().c_str(),
				 candidate->getName().c_str(), signal->getAssignmentStatementRhs().c_str(), ptr);*/

				if (ptr)
				{
					ptr += candidate->getName().length();
					if (ptr[0] && (ptr[0] == '(' || (ptr[0] == ' ' && ptr[1] == '(')))
					{
						isSliced = true;
					}
				}
				if (!isSliced)
				{
					return true;
				}
			}
		}
	}
	return false;
}

bool CUnconcatenator::doesSignalIndirectlyDependUponItsSelf(const CSignal* signalOfInterest, const CSignal* transitiveSignal,
    std::vector<const CSignal*>& checkedDependencies) const
{
	checkedDependencies.push_back(transitiveSignal);

	const std::vector<CSignal*> contributors = transitiveSignal->getContributors();

	for (const CSignal* nextSignal : contributors)
	{
		if (nextSignal == signalOfInterest)
		{
			return true;
		}
		else
		{
			if (std::find(checkedDependencies.begin(), checkedDependencies.end(), nextSignal) == checkedDependencies.end())
			{
				if (doesSignalIndirectlyDependUponItsSelf(signalOfInterest, nextSignal, checkedDependencies))
				{
					return true;
				}
			}
	}
	}
	return false;
}

bool CUnconcatenator::isSignalOnlyReferencedInASlicedManner(const CSignal* signalOfInterest, std::vector<CSignal*>& allSignals, uint32_t elementSize) const
{
	CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "signalOfInterest: %s",
						signalOfInterest->getName().c_str());
	for(const CSignal* otherSignal : allSignals)
	{
		if(otherSignal != signalOfInterest)
		{
			const std::string& rhsAssignment = otherSignal->getAssignmentStatementRhs();
			for(const CSignal* contributor : otherSignal->getContributors())
			{
				if(contributor == signalOfInterest)
				{
					if(rhsAssignment.empty())
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "otherSignal: %s empty assignment",
								otherSignal->getName().c_str());
						return false;
					}

					uint32_t upper = 0;
					uint32_t lower = 0;
					if(ExtractSliceRangeFromAssignment(rhsAssignment.c_str(), signalOfInterest, upper, lower))
					{
						if(upper / elementSize == lower/elementSize)
						{
							break;
						}
					}
					else
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "otherSignal: %s with RHS = '%s' sketchy slicing: %u downto %u != %u",
								otherSignal->getName().c_str(), rhsAssignment, upper, lower, elementSize);
						return false;
					}
				}
			}
		}
	}

	return true;
}

void CUnconcatenator::replaceSignalsWithUnconcatenatedEquivalents(CSignal* concatenatedSignal, CSignal* slicedSignal,
    const std::vector<CSignal*>& signalsThatWillNeedReplacing, const std::string& replacementType, std::vector<CSignal*>& entitySignals,
    std::vector<CPortMap>& entityInstances)
{
	// concatenatedSignal is the one that does the concatenation, its dependencies need handling differently
	// all the other entries in signalsThatWillNeedReplacing need to be replaced with sliced versions

	uint32_t sliceRangeUpper = 0;
	uint32_t sliceRangeLower = 0;
	ExtractSliceRangeFromType(replacementType.c_str(), sliceRangeUpper, sliceRangeLower);
	uint32_t typeSize = sliceRangeUpper + 1;

	uint32_t concatenatedTypeSliceRangeUpper = 0;
	uint32_t concatenatedTypeSliceRangeLower = 0;
	ExtractSliceRangeFromType(concatenatedSignal->getType().c_str(), concatenatedTypeSliceRangeUpper, concatenatedTypeSliceRangeLower);
	uint32_t concatenatedTypeSize = concatenatedTypeSliceRangeUpper+1;

	uint32_t numberOfComponents = concatenatedTypeSize / typeSize;

	printf("Replacing: %s of type %s with %d %s signals each of size %d\n", concatenatedSignal->getName().c_str(),
	    concatenatedSignal->getType().c_str(), numberOfComponents, replacementType.c_str(), typeSize);

	std::vector<CSignal*> newSignals;

	// duplicate the signals vector
	for (CSignal* otherSignal : entitySignals)
	{
		auto itr = std::find(signalsThatWillNeedReplacing.begin(), signalsThatWillNeedReplacing.end(), otherSignal);
		if (itr == signalsThatWillNeedReplacing.end())
		{
			newSignals.push_back(otherSignal);
		}
	}

	// first pass, create new unconcatenated versions of the signals that will need replacing
	for (CSignal* signalToUnConcatenate : signalsThatWillNeedReplacing)
	{
		char* copy = strdup(signalToUnConcatenate->getAssignmentStatementRhs().c_str());
		char* state = NULL;

		// due to the reverse order of concatenation we loop backwards
		for (int i = numberOfComponents - 1; i >= 0; i--)
		{
			std::string newName = signalToUnConcatenate->getName() + " [" + std::to_string(i) + "]";
			CSignal* component = new CSignal(newName.c_str(), replacementType.c_str(),
			    signalToUnConcatenate->getSynthDefinition().getFile().c_str(), signalToUnConcatenate->getSynthDefinition().getLine());

			component->setIsUserDefined(signalToUnConcatenate->isUserDefined());
			component->setAssignmentStatementRhs(signalToUnConcatenate->getAssignmentStatementRhs().c_str());
			component->setIsClock(false);
			component->setIsInput(signalToUnConcatenate->isInput());
			component->setIsOutput(signalToUnConcatenate->isOutput());
			component->setIsPort(signalToUnConcatenate->isPort());
			component->setSourceAssignment(signalToUnConcatenate->getSourceAssignment());
			component->setSynthAssignment(signalToUnConcatenate->getSynthAssignment());
			component->setSynthDefinition(signalToUnConcatenate->getSynthDefinition());
			component->setIsUnconcatenated(true);
			component->setUnconcatenationIndex(i);
			component->setUnconcatenatedName(signalToUnConcatenate->getName());

			if (signalToUnConcatenate == concatenatedSignal)
			{
				// special case for the concatenated signal, each slice gets its own contributor
				char* part = strtok_r(((uint32_t)i == (numberOfComponents - 1)) ? copy : NULL, " &", &state);
				if (!part)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
					    "Cannot unconcatente signal: cannot resolve the contributors for signal: %s", signalToUnConcatenate->getName().c_str());
					throw 1; // this will cause leaks
				}
				// find the corresponding signal in the previous contributors array
				bool found = false;
				if(isConstant(part))
				{
					found = true;
				}
				else
				{
					for (CSignal* contributor : signalToUnConcatenate->getContributors())
					{
						if (contributor->getName() == part)
						{
							found = true;
							std::vector<CSignal*> contributors;
							contributors.push_back(contributor);
							if (signalToUnConcatenate->getClock())
							{
								component->setClockedContributors(signalToUnConcatenate->getClock(), contributors);
							}
							else
							{
								component->setCombinatorialContributors(contributors);
							}
							break;
						}
					}
				}
				if (!found)
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
					    "Cannot unconcatente signal: %s as I cannot resolve the contributors. Searched for: '%s'",
					    signalToUnConcatenate->getName().c_str(), part);
					throw 1;
				}
				component->setAssignmentStatementRhs(part);
			}
			else
			{
				// preserve original contributors
				if (signalToUnConcatenate->getClock())
				{
					component->setClockedContributors(signalToUnConcatenate->getClock(), signalToUnConcatenate->getContributors());
				}
				else
				{
					component->setCombinatorialContributors(signalToUnConcatenate->getContributors());
				}
			}

			newSignals.push_back(component);
		}

		free(copy);
	}

	// TODO: at some port we should be replacing signals on the port map in entitySignals

	// seconds pass, go through all contributors and assignment string of all signals and update references to removed signals
	// find other signals referencing the thing we have just unconcatenated and update their contributors
	for (CSignal* otherSignal : newSignals)
	{
		// this could probably be done with a reference
		std::vector<CSignal*> contributorsCopy = otherSignal->getContributors();

		for (std::vector<CSignal*>::iterator itr = contributorsCopy.begin(); itr != contributorsCopy.end();)
		{
			CSignal* contributorSignal = *itr;
			auto findItr = std::find(signalsThatWillNeedReplacing.begin(), signalsThatWillNeedReplacing.end(), contributorSignal);
			if (findItr != signalsThatWillNeedReplacing.end())
			{
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "otherSignal: %s, ContrinbutorsCopy started %zu long",
				    otherSignal->getName().c_str(), contributorsCopy.size());
				for (CSignal* s : contributorsCopy)
				{
					printf("%s, ", s->getName().c_str());
				}
				printf("\n");

				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "otherSignal: %s, Contributor Signal: %s",
				    otherSignal->getName().c_str(), contributorSignal->getName().c_str());

				// remove old contributor
				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "otherSignal: %s, Removing entry '%s' from contributors",
				    otherSignal->getName().c_str(),
				    contributorSignal->getName().c_str());

				contributorsCopy.erase(std::remove(contributorsCopy.begin(), contributorsCopy.end(), contributorSignal), contributorsCopy.end());

				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "otherSignal: %s, ContrinbutorsCopy is now %zu long",
				    otherSignal->getName().c_str(), contributorsCopy.size());

				std::string replaceTerm;

				// we need to figure out whether we were using a sliced version, or the whole version
				uint32_t sliceRangeUpper = 0;
				uint32_t sliceRangeLower = 0;
				if (ExtractSliceRangeFromAssignment(otherSignal->getAssignmentStatementRhs().c_str(), contributorSignal, sliceRangeUpper, sliceRangeLower))
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG,
					    "contributorSignal: %s, otherSignal: %s, Assignment str: '%s', sliceRange: %u downto %u", contributorSignal->getName().c_str(),
					    otherSignal->getName().c_str(), otherSignal->getAssignmentStatementRhs().c_str(), sliceRangeUpper, sliceRangeLower);

					// only add the relevant component as a contributor
					if ((sliceRangeUpper - sliceRangeLower) + 1 != typeSize || sliceRangeLower % typeSize != 0
					    || sliceRangeLower / typeSize >= numberOfComponents)
					{
						if(sliceRangeUpper / typeSize == sliceRangeLower / typeSize)
						{
							// we are slicing one member of the array
							int unconcatenationIndex = sliceRangeLower / typeSize;
							CSignal* unconcatenatedContributorSignal = findUnconcatenatedContributorSignal(newSignals, contributorSignal,
							    unconcatenationIndex);
							if (!unconcatenatedContributorSignal)
							{
								CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
								    "Cannot unconcatente signal: %s, contributor signal %s with unconcatenation index: %d, target signal not found",
								    otherSignal->getName().c_str(), contributorSignal->getName().c_str(), unconcatenationIndex);
								// maybe this should not be fatal
								throw 1;
							}
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Adding to contributors: %s",
									unconcatenatedContributorSignal->getName().c_str());
							contributorsCopy.push_back(unconcatenatedContributorSignal);
							replaceTerm = unconcatenatedContributorSignal->getName() + "(" + std::to_string(sliceRangeUpper - unconcatenationIndex * typeSize) + " downto " + std::to_string(sliceRangeLower - unconcatenationIndex * typeSize) + ")";
						}
						else
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
									"Cannot unconcatente signal: %s, other signal %s slices it using range (%u -> %u) which does not align with our predetermined sub slice length: %d (%d, %d, %d)",
									contributorSignal->getName().c_str(), otherSignal->getName().c_str(), sliceRangeUpper, sliceRangeLower,
									typeSize, (sliceRangeUpper - sliceRangeLower) + 1, sliceRangeLower % typeSize, sliceRangeLower / numberOfComponents);
							// maybe this should not be fatal?
							throw 1;
						}
					}
					else
					{
						int unconcatenationIndex = sliceRangeLower / typeSize;
						CSignal* unconcatenatedContributorSignal = findUnconcatenatedContributorSignal(newSignals, contributorSignal,
						    unconcatenationIndex);
						if (!unconcatenatedContributorSignal)
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
							    "Cannot unconcatente signal: %s, contributor signal %s with unconcatenation index: %d, target signal not found",
							    otherSignal->getName().c_str(), contributorSignal->getName().c_str(), unconcatenationIndex);
							// maybe this should not be fatal
							throw 1;
						}
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Adding to contributors: %s",
								unconcatenatedContributorSignal->getName().c_str());
						contributorsCopy.push_back(unconcatenatedContributorSignal);
						replaceTerm = unconcatenatedContributorSignal->getName();
					}
				}
				else
				{
					if(otherSignal->isUnconcatenated() )
					{
						int unconcatenationIndex = otherSignal->getUnconcatenationIndex();
						CSignal* unconcatenatedContributorSignal = findUnconcatenatedContributorSignal(newSignals, contributorSignal, unconcatenationIndex);
						if (!unconcatenatedContributorSignal)
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::FATAL,
							    "Cannot unconcatente signal: %s, contributor signal %s with unconcatenation index: %d, target signal not found",
							    otherSignal->getName().c_str(), contributorSignal->getName().c_str(), unconcatenationIndex);
							// maybe this should not be fatal
							throw 1;
						}
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Adding to contributors: %s",
								unconcatenatedContributorSignal->getName().c_str());
						contributorsCopy.push_back(unconcatenatedContributorSignal);
						replaceTerm = unconcatenatedContributorSignal->getName();
					}
					else
					{
						// insert all components (this might not be reachable based on prior checks)
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Adding all components to contributors");
						for(uint32_t i=0;i<numberOfComponents;i++)
						{
							CSignal* unconcatenatedContributorSignal = findUnconcatenatedContributorSignal(newSignals, contributorSignal, i);
							contributorsCopy.push_back(unconcatenatedContributorSignal);

							if(i != 0)
							{
								replaceTerm += " ";
							}
							replaceTerm += unconcatenatedContributorSignal->getName();
						}
					}
				}

				CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Saving %zu contributors to: '%s'", contributorsCopy.size(),
				    otherSignal->getName().c_str());
				if (otherSignal->getClock())
				{
					otherSignal->setClockedContributors(otherSignal->getClock(), contributorsCopy);
				}
				else
				{
					otherSignal->setCombinatorialContributors(contributorsCopy);
				}

				if(!replaceTerm.empty())
				{
					std::string findTerm = contributorSignal->getName();
					std::string assignmentRhs = otherSignal->getAssignmentStatementRhs();

					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "Fixing RHS assignment: finding: %s and replacing it with %s in '%s'",
							findTerm.c_str(),
							replaceTerm.c_str(),
							assignmentRhs.c_str());

					CSignalUnRenamer::RhsAssignmentStdStringReplace(assignmentRhs, findTerm, replaceTerm);

					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "result: '%s'", assignmentRhs.c_str());

					otherSignal->setAssignmentStatementRhs(assignmentRhs.c_str());
				}
				else
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "NOT Fixing RHS assignment:");
				}

				itr = contributorsCopy.begin();
			}
			else
			{
				++itr;
			}
		}
	}

	for (CSignal* signal : newSignals)
	{
		signal->dump();
	}

	entitySignals.clear();
	entitySignals.insert(entitySignals.end(), newSignals.begin(), newSignals.end());
}

bool CUnconcatenator::ExtractSliceRangeFromAssignment(const char* assignmentRhs, const CSignal* signalOfInterest, uint32_t& upper, uint32_t& lower)
{
	char* copy = strdup(assignmentRhs);

	char* ptr = copy;
	char* pos = strstr(ptr, signalOfInterest->getName().c_str());

	CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "pos: '%s'", pos);

	if (pos != NULL)
	{
		pos += signalOfInterest->getName().length();
		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "pos: '%s'", pos);
		while (*pos)
		{
			if (*pos == '(')
			{
				break;
			}
			else if (*pos == ' ')
			{
				pos++;
			}
			else
			{
				break;
			}
		}

		CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "pos: '%s'", pos);

		if (*pos == '(')
		{
			pos++;
			char* start = pos;
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "start = '%s', pos: '%s'", start, pos);
			int bracketsOpened = 0;
			while (*pos)
			{
				if (*pos == '(')
				{
					CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "start = '%s', pos: '%s'", start, pos);
					bracketsOpened++;
				}
				else
				{
					if (*pos == ')')
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "start = '%s', pos: '%s'", start, pos);
						if (bracketsOpened)
						{
							bracketsOpened--;
						}
						else
						{
							*pos = 0;
							break;
						}
					}
				}
				++pos;
			}
			CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "start = '%s', pos: '%s'", start, pos);

			bool success = ParseSliceRange(start, upper, lower);

			free(copy);
			return success;
		}
	}

	free(copy);
	return false;
}

bool CUnconcatenator::ExtractSliceRangeFromType(const char* type, uint32_t& upper, uint32_t& lower)
{
	char* copy = strdup(type);
	const char* searchTerm = "std_logic_vector ";
	char* stdLogicVectorPos = strstr(copy, searchTerm);
	bool success = false;
	if (stdLogicVectorPos)
	{
		stdLogicVectorPos += strlen(searchTerm);
		while (*stdLogicVectorPos)
		{
			if (*stdLogicVectorPos != '(')
			{
				stdLogicVectorPos++;
			}
			else
			{
				break;
			}
		}
		stdLogicVectorPos++;
		success = ParseSliceRange(stdLogicVectorPos, upper, lower);
	}
	else
	{
		// it was a std_logic
	}
	free(copy);
	return success;
}

bool CUnconcatenator::ParseSliceRange(const char* type, uint32_t& upper, uint32_t& lower)
{
	char* next = NULL;
	upper = strtoul(type, &next, 10);
	lower = 0;
	if (next && *next == ' ')
	{
		while (*next)
		{
			if (*next >= '0' && *next <= '9')
			{
				break;
			}
			next++;
		}
		lower = strtol(next, NULL, 10);
	}
	else
	{
		lower = upper;
	}
	return true;
}

CSignal* CUnconcatenator::findUnconcatenatedContributorSignal(std::vector<CSignal*>& signals, CSignal* concatenatedSignal, int index)
{
	for (CSignal* s : signals)
	{
		if (s->isUnconcatenated())
		{
			if (s->getUnconcatenationIndex() == index && s->getUnconcatenatedName() == concatenatedSignal->getName())
			{
				return s;
			}
		}
	}
	return NULL;
}

bool CUnconcatenator::isConstant(const char* signal)
{
	// detects:
	// "000000000000000000000000000000000000000000000000"
	// "XXXXXXXXXXXXXXXX"

	uint32_t length = strlen(signal);

	if(signal[0] == '"' && signal[length-1] == '"')
	{
		bool allBitsValid = true;
		for(uint32_t i =1; i<length-2;i++)
		{
			switch(signal[i])
			{
				case '0':
				case '1':
				case 'X':
				case 'Z':
					continue;
				default:
					allBitsValid = false;
					break;
			}
		}
		return allBitsValid;
	}
	return false;
}

} /* namespace vhdl */
