package homenet.src;

//
// Send message to thrupumeter and to the network.
//
simple Copy
{
    parameters:
        int mode = default(1);
        double pktLost = default(0);
        @display("i=block/broadcast");
    gates:
        input inEncapGate;
        output outEncapGate;
        output thGate; // thruput connection
}
