---
id: codel-send-buffer-shedding
aliases: ["CoDel", "codel", "controlled delay", "send-buffer shedding", "load shedding", "load-shedding", "sendbuffer", "recvbuffer", "priority load shedding", "TrafficClass", "traffic class", "256-bit priority", "parasitic eviction", "cohort shedding", "backpressure", "drainNotify", "drainWaiterCount", "notifyDrain", "PopPriority", "wake by traffic class", "WithTrafficClass", "TrafficClassFromContext"]
topics: [networking, data-structures]
status: current
---

# codel-send-buffer-shedding

CASK's approach to bounding latency and shedding load under pressure, borrowing the CoDel (controlled-delay) idea and grounding it in a priority ordering. Each message carries a one-byte **TrafficClass** (0–128) and a 128-bit **Trace**; its **Priority** is `Trace >> (128 - TrafficClass)`, and `(TrafficClass, Trace)` forms a single 256-bit ordering key where lower-class, lower-trace traffic is least likely to be evicted (maximizing overall system health). The send and receive buffers are fixed-size parallel-array tables with priority heaps over the columns, so when a buffer fills, a higher-priority span **parasitically evicts** lower-priority entries (and, in the telemetry buffer, their associated log blocks) rather than blocking. Traffic classes 0–5 are reserved for acknowledgements; the ack class for any other class is that class minus 5, sized so acks roughly outrank the traffic they confirm and suppress retries. At the RPC layer the same idea appears as **cohort-based shedding**: requests are bucketed into healthy/unhealthy cohorts by `hash(user_id, priority) & mask`, and an overloaded node sheds unhealthy cohorts first while continuing to serve healthy ones. The dequeue side (the Peer sends by `PopPriority()`, highest priority first) is complemented by an **enqueue-side backpressure** mechanism (`net-design.md`): when the send queue is full a Peer blocks `Store()` callers instead of growing the buffer, and wakes them in TrafficClass order via a bank of 129 per-class notifier channels (`drainNotify[0..128]`) and atomic waiter counters that `notifyDrain()` scans low-class-first.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--trace--traffic-class-and-priority](../sections/cask--trace--traffic-class-and-priority.md) | TrafficClass/Priority computation and the (TrafficClass, Trace) 256-bit eviction key; ack classes 0–5. |
| [cask--trace--tracer-interface-and-telemetry-buffer](../sections/cask--trace--tracer-interface-and-telemetry-buffer.md) | buffercasktel: high-priority spans parasitically evict lower-priority spans and their log blocks. |
| [cask--readme--priority-load-shedding](../sections/cask--readme--priority-load-shedding.md) | Per-class backpressure and coordinated fan-out shedding over the sendbuffer priority heaps. |
| [cask--readme--what-tcp-costs-you](../sections/cask--readme--what-tcp-costs-you.md) | The TCP critique (bufferbloat, no in-flight priority/expiry) that motivates CoDel borrowing. |
| [cask--architecture--layers-3-4-rpc-routing-orchestration](../sections/cask--architecture--layers-3-4-rpc-routing-orchestration.md) | Cohort-based health grouping and coordinated load shedding at the RPC layer. |
| [cask--net-design--backpressure-and-traffic-class-wake](../sections/cask--net-design--backpressure-and-traffic-class-wake.md) | Enqueue-side: block `Store()` on a full queue; wake waiters by TrafficClass via 129 per-class notifier channels. |
| [cask--net-design--lost-notification-coordination](../sections/cask--net-design--lost-notification-coordination.md) | The increment-under-lock / notify-after-unlock proof that no drain notification is lost. |

## See also

- [[parallel-arrays-columnar]] — the fixed-size buffer the priority heaps order; eviction is a swap-to-end deallocation.
- [[swap-to-end-allocation]] — how an evicted slot is reclaimed.
- [[content-addressed-block-store]] — the 1KB block is the unit both buffered and shed.
