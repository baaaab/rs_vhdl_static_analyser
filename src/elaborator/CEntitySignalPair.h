#ifndef SRC_ELABORATOR_CENTITYSIGNALPAIR_H_
#define SRC_ELABORATOR_CENTITYSIGNALPAIR_H_
namespace vhdl
{
class CEntityInstance;
class CSignal;

class CEntitySignalPair
{
public:
	CEntitySignalPair(const CEntityInstance* entity, const CSignal* signal);
	virtual ~CEntitySignalPair();

	const CEntityInstance* getEntityInstance() const;
	const CSignal* getSignal() const;

private:
	const CEntityInstance* _entity;
	const CSignal* _signal;
};

} /* namespace vhdl */

#endif /* SRC_ELABORATOR_CENTITYSIGNALPAIR_H_ */
