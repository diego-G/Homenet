package homenet.src;

import inet.linklayer.ethernet.EtherEncap;
import inet.linklayer.ethernet.EtherMAC;
import inet.linklayer.etherswitch.MACRelayUnit;

//
// This module is very important. Inside of it, we will take the measurements 
// and record the results. It will develop two roles depending on whether 
// sending or receiving statistics.
//
module Stats
{
    parameters:
        @node();
        @labels(node,ethernet-node);
        @display("i=device/pocketpc;bgb=388,317");
        string relayUnitType = default("MACRelayUnitNP"); // type of the MACRelayUnit; currently possible
                                                          // values are MACRelayUnitNP and MACRelayUnitPP
    gates:
        inout ethg[] @labels(EtherFrame-conn);
    submodules:
        relayUnit: <relayUnitType> like MACRelayUnit {
            parameters:
                @display("p=325,140");
            gates:
                lowerLayerIn[sizeof(ethg)];
                lowerLayerOut[sizeof(ethg)];
        }
        mac[sizeof(ethg)]: EtherMAC {
            parameters:
                promiscuous = true;
                queueModule = "";
                @display("p=117,227,row;q=queue");
        }
        etherEncap: EtherEncap {
            @display("p=117,140");
        }
        thruputMeter: ThM {
            @display("p=262,52");
        }
        copy: Copy {
            @display("p=117,52");
        }
    connections:
        mac[0].upperLayerIn <-- relayUnit.lowerLayerOut[0];
        mac[1].upperLayerIn <-- relayUnit.lowerLayerOut[1];
        mac[1].upperLayerOut --> relayUnit.lowerLayerIn[1];
        mac[0].phys <--> ethg[0];
        mac[1].phys <--> ethg[1];

        etherEncap.lowerLayerOut --> relayUnit.lowerLayerIn[0];
        etherEncap.lowerLayerIn <-- mac[0].upperLayerOut;
        copy.inEncapGate <-- etherEncap.upperLayerOut;
        etherEncap.upperLayerIn <-- copy.outEncapGate;
        copy.thGate --> thruputMeter.in;
}

