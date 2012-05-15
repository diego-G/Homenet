package homenet.src;

import inet.applications.pingapp.PingApp;
import inet.applications.sctpapp.SCTPApp;
import inet.applications.tcpapp.TCPApp;
import inet.applications.udpapp.UDPApp;
import inet.base.NotificationBoard;
import inet.linklayer.ethernet.EthernetInterface;
import inet.linklayer.ext.ExtInterface;
import inet.linklayer.ppp.PPPInterface;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.ipv4.RoutingTable;
import inet.nodes.inet.NetworkLayer;
import inet.transport.sctp.SCTP;
import inet.transport.tcp.ITCP;
import inet.transport.udp.UDP;
import inet.util.NAMTraceWriter;
import inet.util.TCPDump;


//
// IP host with TCP and UDP layers and PING application. Besides, it has a drops
// generator in order to loose packets when neccesary.
//
module HostWithDropsGenerator
{
    parameters:
        @node();
        @labels(node,ethernet-node);
        @display("i=device/pc2;i2=status/lightning");
        int numTcpApps = default(0);
        int numUdpApps = default(0);
        int numSctpApps = default(0);
        string tcpAppType = default("n/a");
        string udpAppType = default("n/a");
        string sctpAppType = default("n/a");
        string tcpType = default("TCP");  // tcp implementation (e.g. TCP, TCP_old, TCP_NSC)
        bool IPForward = default(false);
        int namid = default(-1);
        string routingFile = default("");
        int numExtInterfaces = default(0);
    gates:
        inout pppg[] @labels(PPPFrame-conn);
        inout ethg[] @labels(EtherFrame-conn);
    submodules:
        namTrace: NAMTraceWriter {
            parameters:
                namid = namid;
                @display("p=57,294");
        }
        notificationBoard: NotificationBoard {
            parameters:
                @display("p=57,54");
        }
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=57,134");
        }
        routingTable: RoutingTable {
            parameters:
                IPForward = IPForward;
                routerId = "";
                routingFile = routingFile;
                @display("p=57,214");
        }
        tcpApp[numTcpApps]: <tcpAppType> like TCPApp {
            parameters:
                @display("p=186,54");
        }
        tcp: <tcpType> like ITCP {
            parameters:
                @display("p=186,141");
        }
        udpApp[numUdpApps]: <udpAppType> like UDPApp {
            parameters:
                @display("p=501,54");
        }
        udp: UDP {
            parameters:
                @display("p=501,141");
        }
        pingApp: PingApp {
            parameters:
                @display("p=336,54");
        }
        networkLayer: NetworkLayer {
            parameters:
                proxyARP = false;
                @display("p=336,230;q=queue");
            gates:
                ifIn[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
                ifOut[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
        }
        eth[sizeof(ethg)]: EthernetInterfaceDrops {
            parameters:
                @display("p=186,390,row,90;q=txQueue");
        }
        ext[numExtInterfaces]: ExtInterface {
            parameters:
                @display("p=501,390,row,90;q=txQueue;i=block/ifcard");
        }
        tcpdump: TCPDump {
            parameters:
                @display("p=336,302;i=abstract/cache_s");
            gates:
                ifIn[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
                in2[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
                ifOut[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
                out2[sizeof(pppg)+sizeof(ethg)+numExtInterfaces];
        }
    connections allowunconnected:
        for i=0..numTcpApps-1 {
            tcpApp[i].tcpOut --> tcp.appIn++;
            tcpApp[i].tcpIn <-- tcp.appOut++;
        }

        tcp.ipOut --> networkLayer.tcpIn;
        tcp.ipIn <-- networkLayer.tcpOut;

        for i=0..numUdpApps-1 {
            udpApp[i].udpOut --> udp.appIn++;
            udpApp[i].udpIn <-- udp.appOut++;
        }

        udp.ipOut --> networkLayer.udpIn;
        udp.ipIn <-- networkLayer.udpOut;

        networkLayer.pingOut --> pingApp.pingIn;
        networkLayer.pingIn <-- pingApp.pingOut;

        // connections to network outside
        for i=0..sizeof(pppg)-1 {
            tcpdump.out2[i] --> networkLayer.ifIn[i];
            tcpdump.in2[i] <-- networkLayer.ifOut[i];
        }

        for i=0..sizeof(ethg)-1 {
            ethg[i] <--> eth[i].phys;
            eth[i].netwOut --> tcpdump.ifIn[sizeof(pppg)+i];
            tcpdump.out2[sizeof(pppg)+i] --> networkLayer.ifIn[sizeof(pppg)+i];
            eth[i].netwIn <-- tcpdump.ifOut[sizeof(pppg)+i];
            tcpdump.in2[sizeof(pppg)+i] <-- networkLayer.ifOut[sizeof(pppg)+i];
        }

        for i=0..numExtInterfaces-1 {
            ext[i].netwOut --> tcpdump.ifIn[sizeof(pppg)+sizeof(ethg)+i];
            tcpdump.out2[sizeof(pppg)+sizeof(ethg)+i] --> networkLayer.ifIn[sizeof(pppg)+sizeof(ethg)+i];
            ext[i].netwIn <-- tcpdump.ifOut[sizeof(pppg)+sizeof(ethg)+i];
            tcpdump.in2[sizeof(pppg)+sizeof(ethg)+i] <-- networkLayer.ifOut[sizeof(pppg)+sizeof(ethg)+i];
        }
}
