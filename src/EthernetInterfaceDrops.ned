package homenet.src;

import inet.linklayer.INetworkInterface;
import inet.linklayer.ethernet.EtherEncap;
import inet.linklayer.ethernet.EtherMAC;
import inet.linklayer.ppp.DropsGenerator;
import inet.networklayer.queue.OutputQueue;


//
// Ethernet network interface with Drops generator. Complements EtherMAC and 
// EtherEncap with an output queue for QoS and RED support.
// 
// @see EthernetInterface2, EthernetInterfaceNoQueue
//
module EthernetInterfaceDrops like INetworkInterface
{
    parameters:
        string queueType = default("DropTailQueue");
        @display("i=block/ifcard;bgb=212,345;i2=status/lightning");
    gates:
        input netwIn;
        output netwOut;
        inout phys @labels(EtherFrame);
    submodules:
        queue: <queueType> like OutputQueue {
            parameters:
                @display("p=76,108;q=l2queue");
        }
        mac: EtherMAC {
            parameters:
                queueModule = "queue";
                txQueueLimit = 1; // queue sends one packet at a time
                @display("p=130,280");
        }
        encap: EtherEncap {
            parameters:
                @display("p=130,189");
        }
        dropsGenerator: DropsGenerator {
            @display("p=76,42");
        }
    connections:
        netwIn --> dropsGenerator.in;
        queue.out --> encap.upperLayerIn;
        netwOut <-- { @display("m=n"); } <-- encap.upperLayerOut;
        encap.lowerLayerOut --> mac.upperLayerIn;
        encap.lowerLayerIn <-- mac.upperLayerOut;
        mac.phys <--> phys;
        dropsGenerator.out --> queue.in;
}

