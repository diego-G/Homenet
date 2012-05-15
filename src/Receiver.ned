package homenet.src;

//
// This module receives the information and make the right calculations to 
// obtain the end-to-end delay and jitter.
//
module Receiver
{
    parameters:
        @node();
        @labels(node,ethernet-node);
        @display("i=old/mailbox;bgb=388,317");
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
        decider.ethg[1] <--> stats.ethg[1];
        stats.ethg[0] <--> ethg[0];
        decider.ethg[0] <--> ethg[1];
}

