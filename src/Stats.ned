package homenet.src;

import inet.linklayer.ethernet.EtherEncap;
import inet.linklayer.ethernet.EtherMAC;
import inet.linklayer.etherswitch.MACRelayUnit;


//
// Model of an Ethernet switch.
//
// The duplexChannel attributes of the MACs must be set according to the
// medium connected to the port; if collisions are possible (it's a bus or hub)
// it must be set to false, otherwise it can be set to true.
//
// This model does not contain the spanning tree algorithm.
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
        thruputMeter: HomenetThM {
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

