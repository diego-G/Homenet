#ifndef __VALUES_H
#define __VALUES_H

#include <omnetpp.h>

/**
 * Useful to transmit values in the message
 */

class Values: public cObject {

protected:
	simtime_t Ee1;
	simtime_t Simtime1;
	long SqN;

public:
	Values();
	~Values();

	virtual Values *dup() const;

	simtime_t getEe1() const;
	void setEe1(simtime_t Ee1);

	simtime_t getSimtime1() const;
	void setSimtime1(simtime_t Simtime1);

	long getSqN() const;
	void setSqN(long SqN);

};

#endif

