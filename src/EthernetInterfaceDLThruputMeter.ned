package homenet.src;

import inet.linklayer.INetworkInterface;
import inet.linklayer.ethernet.EtherEncap;
import inet.linklayer.ethernet.EtherMAC;
import inet.linklayer.ppp.ThruputMeter;
import inet.networklayer.queue.OutputQueue;


//
// Ethernet network interface. Complements EtherMAC and EtherEncap
// with an output queue for QoS and RED support.
//
// @see EthernetInterface2, EthernetInterfaceNoQueue
//
module EthernetInterfaceDLThruputMeter like INetworkInterface
{
    parameters:
        string queueType = default("DropTailQueue");
        @display("i=block/ifcard;bgl=2");
    gates:
        input netwIn;
        output netwOut;
        inout phys @labels(EtherFrame);
    submodules:
        queue: <queueType> like OutputQueue {
            parameters:
                @display("p=73,71;q=l2queue");
        }
        mac: EtherMAC {
            parameters:
                queueModule = "queue";
                txQueueLimit = 1; // queue sends one packet at a time
                @display("p=131,242");
        }
        encap: EtherEncap {
            parameters:
                @display("p=131,153");
        }
        thruputMeter: ThruputMeter {
            @display("p=192,71");
        }
    connections:
        netwIn --> queue.in;
        queue.out --> encap.upperLayerIn;
        thruputMeter.out --> { @display("m=n"); } --> netwOut;
        encap.lowerLayerOut --> mac.upperLayerIn;
        encap.lowerLayerIn <-- mac.upperLayerOut;
        mac.phys <--> phys;
        encap.upperLayerOut --> thruputMeter.in;
}
