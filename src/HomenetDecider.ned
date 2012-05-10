package homenet.src;

//
// Send message to thrupumeter and to the network.
//
simple HomenetDecider
{
    parameters:
        int passive;
        int emitter;
        @display("i=block/layer");
    gates:
        inout ethg[] @labels(EtherFrame-conn);
}


