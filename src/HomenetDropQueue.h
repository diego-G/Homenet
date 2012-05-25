#ifndef __INET_HOMENETDROPQUEUE_H
#define __INET_HOMENETDROPQUEUE_H

#include <omnetpp.h>
#include "PassiveQueueBase.h"

/**
 * Drop-front queue. See NED for more info.
 */
class INET_API HomenetDropQueue : public PassiveQueueBase
{
  protected:
    // configuration
    int frameCapacity;

    // state
    cQueue queue;
    cGate *outGate;

    // statistics
    cOutVector qlenVec;
    cOutVector dropVec;

  protected:
    virtual void initialize();

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual bool enqueue(cMessage *msg);

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual cMessage *dequeue();

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual void sendOut(cMessage *msg);
};

#endif


