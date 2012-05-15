package homenet.simulations;

import homenet.src.HomenetHost;
import homenet.src.HostWithDropsGenerator;
import homenet.src.Stats;
import inet.linklayer.ethernet.EtherHub;
import inet.nodes.inet.OSPFRouter;
import inet.world.ChannelInstaller;
import inet.world.NAMTrace;
import ned.DatarateChannel;


//
// <h3> Homenetwork topology scenario </h3> 
//
// The house used has a living room, a kitchen, a garage and four rooms: three 
// bedrooms and another one used as an office.
//
// The network is designed in a mesh so that each node is able to have more 
// than one alternative path to send its information depending on the metrics 
// of each link to the destination. The design also tries to prevent that any 
// node will be unreachable in case of failure always ensuring that no node is 
// overloaded.
//
network Homenet
{
    parameters:
        @display("p=10,10;b=736,568;bgb=792,614");
    types:
        channel C extends DatarateChannel
        {
            //datarate = 100Mbps;
            delay = 0.1us;
        }
    submodules:
        channelInstaller: ChannelInstaller {
            parameters:
                channelClass = "ThruputMeteringChannel";
                channelAttrs = "format=#N";
                @display("p=72,34");
        }
        nam: NAMTrace {
            parameters:
                @display("p=159,33");
        }
        room_A: OSPFRouter {
            parameters:
                @display("p=443,310");
            gates:
                ethg[3];
        }
        room_C: OSPFRouter {
            parameters:
                @display("p=443,232");
            gates:
                ethg[3];
        }
        garage: OSPFRouter {
            parameters:
                @display("p=293,421");
            gates:
                ethg[3];
        }
        kitchen: OSPFRouter {
            parameters:
                @display("p=593,421");
            gates:
                ethg[3];
        }
        office: OSPFRouter {
            parameters:
                @display("p=593,310");
            gates:
                ethg[5];
        }
        room_B: OSPFRouter {
            parameters:
                @display("p=293,310");
            gates:
                ethg[5];
        }
        living_room: OSPFRouter {
            parameters:
                @display("p=443,421");
            gates:
                ethg[6];
        }
        Host0: HostWithDropsGenerator {
            @display("p=41,310");
            gates:
                ethg[1];
        }
        Host1: HomenetHost {
            @display("p=443,34");
            gates:
                ethg[1];
        }
        Host2: HomenetHost {
            @display("p=751,310");
            gates:
                ethg[1];
        }
        Host3: HomenetHost {
            @display("p=592,559");
            gates:
                ethg[1];
        }
        Host4: HomenetHost {
            @display("p=443,559");
            gates:
                ethg[1];
        }
        Host5: HomenetHost {
            @display("p=293,559");
            gates:
                ethg[1];
        }
        etherHub0: EtherHub {
            @display("p=204,310");
            gates:
                ethg[2];
        }
        etherHub1: EtherHub {
            @display("p=444,167");
            gates:
                ethg[2];
        }
        etherHub2: EtherHub {
            @display("p=674,310");
            gates:
                ethg[2];
        }
        etherHub3: EtherHub {
            @display("p=593,490");
            gates:
                ethg[2];
        }
        etherHub4: EtherHub {
            @display("p=443,490");
            gates:
                ethg[2];
        }
        etherHub5: EtherHub {
            @display("p=293,490");
            gates:
                ethg[2];
        }
        Transmitter0: Stats {
            parameters:
                @display("p=119,310;i=msg/mail");
            gates:
                ethg[2];
        }
        Receptor1: Stats {
            parameters:
                @display("p=443,106;i=old/mailbox");
            gates:
                ethg[2];
        }
    connections:

        room_B.ethg[1] <--> C <--> room_C.ethg[1];
        room_B.ethg[2] <--> C <--> room_A.ethg[0];
        room_B.ethg[3] <--> C <--> living_room.ethg[2];
        room_B.ethg[4] <--> C <--> garage.ethg[1];
        office.ethg[2] <--> C <--> living_room.ethg[4];
        room_A.ethg[1] <--> C <--> office.ethg[3];
        kitchen.ethg[2] <--> C <--> office.ethg[1];
        garage.ethg[2] <--> C <--> living_room.ethg[1];
        kitchen.ethg[1] <--> C <--> living_room.ethg[5];
        room_A.ethg[2] <--> C <--> living_room.ethg[3];
        office.ethg[4] <--> C <--> room_C.ethg[2];

        etherHub0.ethg[1] <--> C <--> room_B.ethg[0];
        Host3.ethg[0] <--> C <--> etherHub3.ethg[0];

        Host2.ethg[0] <--> C <--> etherHub2.ethg[0];
        etherHub2.ethg[1] <--> C <--> office.ethg[0];
        etherHub3.ethg[1] <--> C <--> kitchen.ethg[0];
        Host4.ethg[0] <--> C <--> etherHub4.ethg[0];
        etherHub4.ethg[1] <--> C <--> living_room.ethg[0];
        Host5.ethg[0] <--> C <--> etherHub5.ethg[0];
        etherHub5.ethg[1] <--> C <--> garage.ethg[0];

        Host0.ethg[0] <--> C <--> Transmitter0.ethg[0];
        Transmitter0.ethg[1] <--> etherHub0.ethg[0];

        Host1.ethg[0] <--> C <--> Receptor1.ethg[1];
        Receptor1.ethg[0] <--> etherHub1.ethg[0];
        etherHub1.ethg[1] <--> C <--> room_C.ethg[0];
}
