#ifndef __INET_HOMENETTHM_H
#define __INET_HOMENETTHM_H

#include <omnetpp.h>
#include "INETDefs.h"
#include "Values.h"


/**
 * Measures and records network throughput
 */
// FIXME problem: if traffic suddenly stops, it'll show the last reading forever;
// (output vector will be correct though); would need a timer to handle this situation
class INET_API HomenetThM : public cSimpleModule
{
  protected:
    // config
    simtime_t startTime; // start time
    unsigned int batchSize;   // number of packets in a batch
    simtime_t maxInterval; // max length of measurement interval (measurement ends
                     // if either batchSize or maxInterval is reached, whichever
                     // is reached first)

    // global statistics
    unsigned long numPackets;
    unsigned long numBits;

    // Homenet global statistics
    int emisor;
    double rcv_win;
    int tcp;

    // current measurement interval
    simtime_t intvlStartTime;
    simtime_t intvlLastPkTime;
    unsigned long intvlNumPackets;
    unsigned long intvlNumBits;

    // Homenet current measurement interval
    long SqN;
    long expectedReplySqN;
    long outOfTimeReplySqN;
    long outOfOrderArrivalCount;
    int tempExpired;
    cMessage *timeOutEvent;
    simtime_t eej;

    // statistics
    cOutVector bitpersecVector;
    cOutVector pkpersecVector;

    // Homenet statistics
    cOutVector pkDelayVector;
    cOutVector jitterVector;
    cStdDev pkDelayStats;
    cStdDev pkJitter;
    cStdDev pkJitter2;

  protected:
    virtual void updateStats(simtime_t now, unsigned long bits);
    virtual void beginNewInterval(simtime_t now);
    void recordDelay(Values *homenetObject);

  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
};

#endif
