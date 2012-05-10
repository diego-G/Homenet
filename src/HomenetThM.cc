#include <vector>
#include <omnetpp.h>
#include <string.h>

#include "HomenetThM.h"
#include "Values.h"
#include "TCPCommand_m.h"

#include <iostream>
#include <fstream>

Define_Module(HomenetThM);

void HomenetThM::initialize() {
	startTime = par("startTime");
	long _batchSize = par("batchSize");
	if ((_batchSize < 0) || (((long) (unsigned int) _batchSize) != _batchSize))
		throw cRuntimeError("invalid 'batchSize=%ld' parameter at '%s' module",
				_batchSize, getFullPath().c_str());
	batchSize = (unsigned int) _batchSize;
	maxInterval = par("maxInterval");

	rcv_win = par("rcv_win");
	tcp = par("tcp");
	emisor = par("emisor");

	numPackets = numBits = 0;
	intvlStartTime = intvlLastPkTime = 0;
	intvlNumPackets = intvlNumBits = 0;

	SqN = 0;
	expectedReplySqN = 0;
	outOfTimeReplySqN = 0;
	tempExpired = 0;
	outOfOrderArrivalCount = 0;
	timeOutEvent = NULL;

	WATCH(numPackets);
	WATCH(numBits);
	WATCH(intvlStartTime);
	WATCH(intvlNumPackets);
	WATCH(intvlNumBits);

	bitpersecVector.setName("thruput (bit/sec)");
	pkpersecVector.setName("packet/sec");

	//Homenet statistics
	pkDelayVector.setName("pkDelayVector");
	pkDelayStats.setName("pkDelayStats");
	jitterVector.setName("jitterVector");
}

void HomenetThM::handleMessage(cMessage *msg) {

	//if its a timer
	if (msg->isSelfMessage()) {
		tempExpired = 1;
		timeOutEvent = NULL;
	} else {
		if (msg->hasObject("")) {
			Values *homenetObject = (Values *) msg->getObject("");

			ev << "  Ee1:    " << homenetObject->getEe1() << endl;
			ev << "  Simtime1:    " << homenetObject->getSimtime1() << endl;
			ev << "  SqN    " << homenetObject->getSqN() << endl;

			if (tcp == 1) {
				simtime_t duration = simTime() - homenetObject->getSimtime1()
						+ homenetObject->getEe1();
				// Record measurements
				double bitpersec = rcv_win / (duration.dbl());
				bitpersecVector.recordWithTimestamp(simTime(), bitpersec * 8);
				numBits += PK(msg)->getBitLength();
				numPackets++;
			} else {
				updateStats(simTime(), PK(msg)->getBitLength());
			}
			if (homenetObject->getSqN() == expectedReplySqN) {
				// Expected packet arrived; expect next sequence number
				expectedReplySqN++;
				if (timeOutEvent != NULL) {
					cancelEvent(timeOutEvent);
					delete (timeOutEvent);
					timeOutEvent = NULL;
				}
				timeOutEvent = new cMessage("timeout");
				scheduleAt(simTime() + 2.0, timeOutEvent);
				tempExpired = 0;
				recordDelay(homenetObject);
			} else if (homenetObject->getSqN() > expectedReplySqN) {
				EV << "Jump in seq numbers, assuming lost packets since #"
							<< expectedReplySqN << "\n";
				outOfTimeReplySqN = expectedReplySqN;
				// Expect sequence numbers to continue from here
				expectedReplySqN = homenetObject->getSqN() + 1;

				if (timeOutEvent != NULL) {
					cancelEvent(timeOutEvent);
					delete (timeOutEvent);
					timeOutEvent = NULL;
				}
				timeOutEvent = new cMessage("timeout");
				scheduleAt(simTime() + 2.0, timeOutEvent);
				tempExpired = 0;
				recordDelay(homenetObject);
			} else { // SqN < expectedReplySeqNo
				if ((tempExpired == 1)
						|| (homenetObject->getSqN() < outOfTimeReplySqN)) {
					// Packet arrived too late: count as out of order arrival
					EV << "Arrived out of order and too late.\n";
					outOfOrderArrivalCount++;
				} else
					recordDelay(homenetObject);
			}
		} //hasObject
	}
	delete (msg);
}

void HomenetThM::recordDelay(Values *homenetObject) {
	pkJitter.collect(simTime() - homenetObject->getSimtime1());

	if (pkJitter.getCount() > 1)
		eej = pkJitter.getStddev();
	else
		eej = 0;

	jitterVector.record(eej);
	pkJitter2.collect(eej);
	pkDelayVector.record(
			simTime() - homenetObject->getSimtime1() + homenetObject->getEe1());
	pkDelayStats.collect(
			simTime() - homenetObject->getSimtime1() + homenetObject->getEe1());
}

void HomenetThM::updateStats(simtime_t now, unsigned long bits) {
	numPackets++;
	numBits += bits;

	// packet should be counted to new interval
	ev << " interval num packets " << intvlNumPackets << endl;
	ev << " valor now " << now - intvlStartTime << endl;

	// packet should be counted to new interval
	if (intvlNumPackets >= batchSize || now - intvlStartTime >= maxInterval)
		beginNewInterval(now);

	intvlNumPackets++;
	intvlNumBits += bits;
	intvlLastPkTime = now;

}

void HomenetThM::beginNewInterval(simtime_t now) {
	simtime_t duration = now - intvlStartTime;

	// record measurements
	ev << " thru   " << intvlNumBits << endl;
	ev << " time   " << duration.dbl() << endl;

	double bitpersec = intvlNumBits / duration.dbl();
	double pkpersec = intvlNumPackets / duration.dbl();

	bitpersecVector.recordWithTimestamp(intvlStartTime, bitpersec);
	pkpersecVector.recordWithTimestamp(intvlStartTime, pkpersec);

	// restart counters
	intvlStartTime = now; // FIXME this should be *beginning* of tx of this packet, not end!
	intvlNumPackets = intvlNumBits = 0;
}

void HomenetThM::finish() {
	simtime_t duration = simTime() - startTime;

	ev << "  pk. delay, min:    " << pkDelayStats.getMin() << endl;
	ev << "  pk. delay, max:    " << pkDelayStats.getMean() << endl;
	ev << "  pk. delay, mean:   " << pkDelayStats.getMax() << endl;
	ev << "  pk. delay, stddev: " << pkDelayStats.getStddev() << endl;

	recordScalar("JitterMean", pkJitter2.getMean());
	recordScalar("EedMean", pkDelayStats.getMean());
	recordScalar("Duration", duration);
	recordScalar("Drop packets", outOfOrderArrivalCount);
	recordScalar("Total packets", numPackets);
	recordScalar("Total bits", numBits);

	recordScalar("Throughput avg(bit/s)", numBits / duration.dbl());
	recordScalar("Packets avg/s", numPackets / duration.dbl());
}
