package homenet.src;

//
// Thruput measurement utility module.
//
simple HomenetThM
{
    parameters:
        @node();
        double startTime @unit("s") = default(0s);
        int batchSize = default(50);
        double maxInterval @unit("s") = default(1s);

        int emisor = default(1);
        double rcv_win = default(65535);
        int tcp = default(0);

        @display("i=block/timer_vs");
    gates:
        input in;
}
