package homenet.src;

//
// This module makes possible to choose if the incoming message is interesting 
// for our statistics or its useless. Depending which kind of packet is, it is 
// processed through throughput meter or it is sent to the network.
//
simple Copy
{
    parameters:
        int mode = default(0); // 0 for Tx mode, 1 to Rx mode
        double pktLost = default(0); // Number of Packets lost
        @display("i=block/broadcast");
    gates:
        input inEncapGate;
        output outEncapGate;
        output thGate; // Throughputmeter connection
}
