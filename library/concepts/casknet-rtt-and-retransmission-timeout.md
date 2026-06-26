---
id: casknet-rtt-and-retransmission-timeout
aliases: ["RFC 6298", "RFC6298", "retransmission timeout", "RTO", "smoothed RTT", "SRTT", "RTTVAR", "RTT variance", "round-trip time estimation", "Karn's algorithm", "Karn algorithm", "updateRoundTripTimeLocked", "retransmissionTimeoutLocked", "RTTStats", "RetransmissionTimeoutMinimum", "RetransmissionTimeoutMaximum", "nextRetryAt", "enqueueDueRetries", "casknet retransmission"]
topics: [networking]
status: current
---

# casknet-rtt-and-retransmission-timeout

How casknet runs reliable delivery over unreliable UDP by estimating a per-`Peer` retransmission timeout exactly the way TCP does. Each `Peer` keeps a smoothed round-trip time `SRTT` and an RTT variance `RTTVAR` as exponential moving averages (`SRTT = 7/8·SRTT + 1/8·sample`, `RTTVAR = 3/4·RTTVAR + 1/4·|SRTT − sample|`, seeded `SRTT = sample` / `RTTVAR = sample/2` on the first measurement). The retransmission timeout is the **RFC 6298** formula `RTO = SRTT + 4·RTTVAR`, clamped below by the configured `RetransmissionTimeoutMinimum` and above by `RetransmissionTimeoutMaximum`; before any sample arrives the RTO is just the minimum. RTT samples are taken **only from packets never retransmitted** (**Karn's algorithm**), because an acknowledgment for a re-sent packet is ambiguous about which transmission it answers. When a packet is sent, `nextRetryAt = now + RTO`; the send loop's `enqueueDueRetriesLocked` re-enqueues any in-flight entry past its deadline (counting it as a retry, which then disqualifies it from RTT sampling). This timer governs *per-packet retransmission* and is independent of the CoDel sojourn-time shedding that governs *queue admission* (see [[codel-send-buffer-shedding]]).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--net-peer-go--rtt-estimation-and-retransmission-timeout](../sections/cask--net-peer-go--rtt-estimation-and-retransmission-timeout.md) | The implementation: the RFC 6298 RTO formula with min/max clamp, the EMA update of SRTT/RTTVAR with the canonical 1/8 and 1/4 gains, and Karn's algorithm excluding retransmitted-packet samples. |

## See also

- [[codel-send-buffer-shedding]] — the other casknet timer: CoDel sojourn-time shedding decides *whether* to defer or drop a queued packet (admission), while this RTO decides *when* to re-send an unacknowledged one (reliability). Two distinct timers over the same send buffer.
- [[casktel-span-completion]] — a Store's span is resolved (`Add(-1)`) when the acknowledgment that also samples the RTT arrives; a retransmission storm both bumps `retryCount` and (via Karn) stops poisoning the estimator.
- [[casknet-wire-protocol]] — the `stor` / `rots` request/acknowledge pair whose round trip is the RTT sample.
