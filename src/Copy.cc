#include <stdio.h>
#include <iostream>
#include <fstream>

#include "IInterfaceTable.h"
#include "InterfaceTableAccess.h"
#include "EtherMAC.h"

#include <vector>
#include <omnetpp.h>
#include <string.h>

#include "Copy.h"
#include "Values.h"
#include "ARPPacket_m.h"

Define_Module(Copy);

void Copy::initialize() {

	mode = par("mode");
	pktLost = par("pktLost");
	SqN = 0;

}

void Copy::handleMessage(cMessage *msg) {

	// If the message is ARP, don't copy and just send to the network
	if (dynamic_cast<ARPPacket *>(msg)) {

		// Dispatch ARP packets to ARP
		send(msg, "outEncapGate");

	} else {
		if (mode == 1) {
			// Duplicate message and send the copy.
			cMessage *copy = (cMessage *) msg->dup();

			send(msg, "outEncapGate");
			send(copy, "thGate");
		} else {
			// Tx mode
			Values *homenetObject = new Values();
			homenetObject->setSimtime1(simTime());
			homenetObject->setEe1(simTime() - msg->getCreationTime());
			homenetObject->setSqN(SqN);
			msg->addObject(homenetObject);
			send(msg, "outEncapGate");

			SqN++;
		}
	}
}

void Copy::finish() {
}
