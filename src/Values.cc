#include <omnetpp.h>
#include <vector>
#include <string.h>
#include <stdio.h>

#include "Values.h"

Register_Class(Values);

Values::Values() {
	Ee1 = 0;
	Simtime1 = 0;
	SqN = 0;
}

Values::~Values() {
}

simtime_t Values::getEe1() const {
	return Ee1;
}

Values *Values::dup() const {
	return new Values(*this);
}

void Values::setEe1(simtime_t Ee1) {
	this->Ee1 = Ee1;
}

simtime_t Values::getSimtime1() const {
	return Simtime1;
}

void Values::setSimtime1(simtime_t Simtime1) {
	this->Simtime1 = Simtime1;
}

long Values::getSqN() const {
	return SqN;
}

void Values::setSqN(long SqN) {
	this->SqN = SqN;
}
