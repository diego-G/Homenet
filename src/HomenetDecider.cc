#include <vector>
#include <omnetpp.h>
#include <string.h>

#include "HomenetDecider.h"

#include <iostream>
#include <fstream>

Define_Module(HomenetDecider);

void HomenetDecider::initialize() {
	passive = par("passive");
	emitter = par("emitter");
}

void HomenetDecider::handleMessage(cMessage *msg) {
	int i;

	if (emitter == 1) {
		if (passive == 1) {
			if (msg->getArrivalGateId() == 1048577) {
				i = 0;
				send(msg, "ethg$o", i);
			} else if (msg->getArrivalGateId() == 1048578) {
				delete (msg);
			} else {
				i = 1;
				send(msg, "ethg$o", i);
			}
		} else {
			//ev << "  gate  receiver " << msg->getArrivalGateId() << endl;
			if (msg->getArrivalGateId() == 1048578) {
				i = 0;
				send(msg, "ethg$o", i);
			} else if (msg->getArrivalGateId() == 1048577) {
				delete (msg);
			} else {
				i = 2;
				send(msg, "ethg$o", i);
			}
		}
	} else {
		if (passive == 1) {
			if (msg->getArrivalGateId() == 1048577) {
				i = 0;
				send(msg, "ethg$o", i);
			} else if (msg->getArrivalGateId() == 1048578) {
				delete (msg);

			} else {
				i = 1;
				send(msg, "ethg$o", i);
			}
		} else {
			if (msg->getArrivalGateId() == 1048578) {
				i = 1;
				send(msg, "ethg$o", i);
			} else if (msg->getArrivalGateId() == 1048577) {
				i = 2;
				send(msg, "ethg$o", i);

			} else
				delete (msg);
		}
	}
}

void HomenetDecider::finish() {
}
