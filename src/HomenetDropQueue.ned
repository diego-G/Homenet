package homenet.src;

import inet.networklayer.queue.OutputQueue;

//
// Drops queue, to be used in Homenet.
// Conforms to the OutputQueue interface.
//
simple HomenetDropQueue like OutputQueue
{
    parameters:
        int frameCapacity = default(100);
        @display("i=block/queue");
    gates:
        input in;
        output out;
}



