package homenet.src;

//
// This module is the generator of traffic. It takes the time when the packet 
// was created and the moment when it arrives to the module. This data is 
// attached in the packet.
//
module Trasmitter
{
    parameters:
        @node();
        @labels(node,ethernet-node);
        @display("i=msg/mail;bgb=388,317");
        string relayUnitType = default("MACRelayUnitNP"); // type of the MACRelayUnit; currently possible
                                                          // values are MACRelayUnitNP and MACRelayUnitPP
    gates:
        inout ethg[2] @labels(EtherFrame-conn);
    submodules:
        statistics: HomenetHost {
            @display("p=295,111");
            gates:
                ethg[1];
        }
        stats: Stats {
            @display("p=129,214");
            gates:
                ethg[2];
        }
        decider: Decider {
            @display("p=129,111");
            gates:
                ethg[3];
        }
    connections:
        statistics.ethg[0] <--> decider.ethg[2];
        decider.ethg[0] <--> stats.ethg[0];
        stats.ethg[1] <--> ethg[1];
        decider.ethg[1] <--> ethg[0];
}

