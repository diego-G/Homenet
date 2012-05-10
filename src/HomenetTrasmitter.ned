package homenet.src;

//
// Model of an Ethernet switch.
//
// The duplexChannel attributes of the MACs must be set according to the
// medium connected to the port; if collisions are possible (it's a bus or hub)
// it must be set to false, otherwise it can be set to true.
//
// This model does not contain the spanning tree algorithm.
//
module HomenetTrasmitter
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
        statistics: HomenetStatistics {
            @display("p=295,111");
            gates:
                ethg[1];
        }
        stats: Stats {
            @display("p=129,214");
            gates:
                ethg[2];
        }
        decider: HomenetDecider {
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

