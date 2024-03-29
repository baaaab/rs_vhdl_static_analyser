#include "CSignalUnRenamer.h"

#include <iterator>
#include <algorithm>
#include <string>

#include "../output/CLogger.h"
#include "../output/ELogLevel.h"

namespace vhdl
{

CSignalUnRenamer::CSignalUnRenamer()
{

}

CSignalUnRenamer::~CSignalUnRenamer()
{

}

void CSignalUnRenamer::simplifyEntityArchitecture(std::vector<CSignal*>& signals, std::vector<CPortMap>& entityInstances)
{
	/*
	 * This function parses an entity/architecture and finds any signal assignments that are effectively
	 * renames where one of the operands is not a user defined signal.
	 *
	 * It also tries to make user defined signals appear as clocked assignments where possible
	 *
	 * eg:
	 *
	 wrap_din_i <= din.i;
	 wrap_din_q <= din.q;
	 wrap_din_valid <= din.valid;
	 wrap_din_pps <= din.pps;

	 n0_o <= wrap_din_pps & wrap_din_valid & wrap_din_q & wrap_din_i;

	 din_r <= n15_q; -- (signal)  // this is a rename, n15_q gets replaced with din_r

	 process (wrap_clk)
	 begin
	 if rising_edge (wrap_clk) then
	 n15_q <= n0_o;
	 end if;
	 end process;


	 * This class must modify entities after the architecture has been parsed, but before they are instantiated.
	 */

	for (std::vector<CSignal*>::iterator itr = signals.begin(); itr != signals.end();)
	{
		bool signalErased = false;
		CSignal* signal = *itr;
		if (!signal->getAssignmentStatementRhs().empty())
		{
			if (signal->getClock() == NULL)
			{
				// combinatorial
				const std::vector<CSignal*>& contributors = signal->getContributors();

				if (contributors.size() == 1)
				{
					CSignal* signalToReplace = NULL;
					CSignal* unRenamed = NULL;
					std::string assignmentRhsString;
					std::string signalName;
					bool forwardContributors = false;
					if(!signal->isUserDefined() && contributors.front()->isUserDefined())
					{
						signalToReplace = signal;
						unRenamed = contributors.front();
						assignmentRhsString = signal->getAssignmentStatementRhs();
						signalName = unRenamed->getName();
						forwardContributors = false;
					}
					else if(signal->isUserDefined() && !contributors.front()->isUserDefined())
					{
						signalToReplace = contributors.front();
						unRenamed = signal;
						assignmentRhsString = unRenamed->getAssignmentStatementRhs();
						signalName = signalToReplace->getName();
						forwardContributors = true;
					}

					if(signalToReplace && unRenamed)
					{
						CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::DEBUG, "if (!isClocked && contributors.size() == 1) Signal: '%s' looks like a rename of: '%s', checking assignments: '%s' vs '%s' ",
								signalToReplace->getName().c_str(),
								unRenamed->getName().c_str(),
								assignmentRhsString.c_str(),
								signalName.c_str()
								);
						if (assignmentRhsString == signalName)
						{
							CLogger::Log(__FILE__, __FUNCTION__, __LINE__, ELogLevel::INFO, "Signal: '%s' looks like a rename of: '%s', replacing it", signalToReplace->getName().c_str(), unRenamed->getName().c_str());

							for (CSignal* otherSignal : signals)
							{
								if (otherSignal != signalToReplace && otherSignal != unRenamed)
								{
									if(!otherSignal->getAssignmentStatementRhs().empty())
									{
										std::string rhs = otherSignal->getAssignmentStatementRhs();
										std::string findStr = signalToReplace->getName();
										std::string replaceStr = unRenamed->getName();

										if(RhsAssignmentStdStringReplace(rhs, findStr, replaceStr))
										{
											/*printf("Signal: %s, replacing %s with %s in %s\n",
																							otherSignal->getName().c_str(),
																							findStr.c_str(),
																							replaceStr.c_str(),
																							rhs.c_str());*/
											otherSignal->setAssignmentStatementRhs(rhs.c_str());
										}
									}

									//replace references to signal with unRenamed in contributors or clock
									if(otherSignal->getClock())
									{
										std::vector<CSignal*> clockedContributors = otherSignal->getContributors();
										CSignal* clockSignal = otherSignal->getClock();
										if(clockSignal == signal)
										{
											clockSignal = unRenamed;
										}
										ReplaceElementInVector(clockedContributors, signalToReplace, unRenamed);
										otherSignal->setClockedContributors(clockSignal, clockedContributors);
									}
									else
									{
										std::vector<CSignal*> combinatorialContributors = otherSignal->getContributors();
										ReplaceElementInVector(combinatorialContributors, signalToReplace, unRenamed);
										otherSignal->setCombinatorialContributors(combinatorialContributors);
									}
								}
							}

							// replace assignments and contributors of unrenamed with those of signalToReplace
							{
								unRenamed->setAssignmentStatementRhs(signalToReplace->getAssignmentStatementRhs().c_str());
								std::vector<CSignal*> contributors = signalToReplace->getContributors();
								// remove new destination signal from the list of contributors
								contributors.erase(std::remove(contributors.begin(), contributors.end(), unRenamed), contributors.end());

								if(signalToReplace->getClock())
								{
									unRenamed->setClockedContributors(signalToReplace->getClock(), contributors);
								}
								else
								{
									unRenamed->setCombinatorialContributors(contributors);
								}
							}

							if(forwardContributors)
							{
								// there is probably a better way to write this
								if(signalToReplace->getClock() != NULL && unRenamed->getClock() == NULL)
								{
									unRenamed->setClockedContributors(signalToReplace->getClock(), signalToReplace->getContributors());
								}
								else if(signalToReplace->getClock() == NULL && unRenamed->getClock() == NULL)
								{
									unRenamed->setCombinatorialContributors(signalToReplace->getContributors());
								}
							}

							for(CPortMap& pm : entityInstances)
							{
								pm.replaceSignal(signalToReplace, unRenamed);
							}

							// delete signal
							if(signal == signalToReplace)
							{
								itr = signals.erase(itr);
							}
							else
							{
								// this is not an efficent way to do this...
								signals.erase(std::find(signals.begin(), signals.end(), signalToReplace));
								itr = signals.begin();
							}
							signalErased = true;
						}
					}
				}
			}
		}
		if(!signalErased)
		{
			++itr;
		}
	}
}

void CSignalUnRenamer::ReplaceElementInVector(std::vector<CSignal*>& haystack, CSignal* needle, CSignal* replace)
{
	std::vector<CSignal*>::iterator needleFindResult = std::find(haystack.begin(), haystack.end(), needle);
	std::vector<CSignal*>::iterator replaceFindResult = std::find(haystack.begin(), haystack.end(), replace);
	if(needleFindResult != haystack.end())
	{
		if(replaceFindResult != haystack.end())
		{
			haystack.erase(needleFindResult);
		}
		else
		{
			*needleFindResult = replace;
		}
	}
}

bool CSignalUnRenamer::RhsAssignmentStdStringReplace(std::string& str, const std::string& from, const std::string& to)
{
	/*
	 * we want to do whole word replacement to avoid hitting substrings so try to append spaces on both/either side
	 */

	std::string findMod = " " + from + " ";
	std::string replaceMod = " " + to + " ";

	size_t startPos = str.find(findMod);
	if (startPos == std::string::npos)
	{
		findMod = from + " ";
		replaceMod = to + " ";
		startPos = str.find(findMod);
		if (startPos == std::string::npos)
		{
			findMod = " " + from;
			replaceMod = " " + to;
			startPos = str.find(findMod);
			if (startPos == std::string::npos)
			{
				findMod = from;
				replaceMod = to;
				startPos = str.find(findMod);
			}
		}
	}

	if (startPos == std::string::npos)
	{
		return false;
	}
	str.replace(startPos, findMod.length(), replaceMod);
	return true;
}

} /* namespace vhdl */
