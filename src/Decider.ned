package homenet.src;

//
// This module decides if we are going to use the active or passive mode. We 
// will use two variables, passive and emitter, to take the decision.
//
// In emitter module ON, we have to send packets in the direction of stats 
// module towards the network. When emitter module is OFF, We are the receiver 
// module, so we receive packet and send reply.
//
// In the passive mode, every packet that we receive from the statistics module
// will be discarded. It only lets the flow between stats and the host 
// connected to our emitter module. If the passive mode is off, it would
// be the opposite way: only packets from statistics module and not from the 
// host.
//
simple Decider
{
    parameters:
        int emitter; // 1 emitter, 0 receiver
        int passive; // 1 passive, 0 active
        @display("i=block/layer");
    gates:
        inout ethg[] @labels(EtherFrame-conn);
}


