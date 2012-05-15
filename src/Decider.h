#ifndef __DECIDER_H
#define __DECIDER_H

#include <omnetpp.h>

/**
 * Measures and records network throughPut
 */
// FIXME problem: if traffic suddenly stops, it'll show the last reading forever;
// (output vector will be correct though); would need a timer to handle this situation
class Decider: public cSimpleModule {
protected:
	int passive;
	int emitter;

protected:
	virtual void initialize();
	virtual void handleMessage(cMessage *msg);
	virtual void finish();
};

#endif

