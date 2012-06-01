#include <omnetpp.h>
#include "HomenetDropQueue.h"

Define_Module(HomenetDropQueue);

void HomenetDropQueue::initialize() {
	PassiveQueueBase::initialize();
	queue.setName("l2queue");

	qlenVec.setName("queue length");
	dropVec.setName("drops");

	outGate = gate("out");

	// configuration
	frameCapacity = par("frameCapacity");
	percentageDrops = par("percentageDrops");
}

bool HomenetDropQueue::enqueue(cMessage *msg) {
	if (frameCapacity && queue.length() >= frameCapacity) {
		EV << "Queue full, dropping packet.\n";
		delete msg;
		dropVec.record(1);
		return true;
	} else {
		queue.insert(msg);
		qlenVec.record(queue.length());
		return false;
	}
}

cMessage *HomenetDropQueue::dequeue() {
	if (queue.empty())
		return NULL;

	cMessage *pk = (cMessage *) queue.pop();

	// statistics
	qlenVec.record(queue.length());

	return pk;
}

void HomenetDropQueue::sendOut(cMessage *msg) {
	if (uniform(0, 1) > percentageDrops) {
		delete msg;
		dropVec.record(1);
	} else
		send(msg, outGate);
}
