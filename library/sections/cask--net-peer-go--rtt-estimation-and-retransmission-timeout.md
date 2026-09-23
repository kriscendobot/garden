---
title: RTT estimation and the RFC 6298 retransmission timeout
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "251-256, 1082-1129"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How a Peer estimates smoothed round-trip time and variance with the RFC 6298 EMA, derives the retransmission timeout as SRTT + 4*RTTVAR clamped to a configured floor and ceiling, and uses Karn's algorithm to ignore RTT samples from retransmitted packets
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Implementation-only material: the design docs describe casknet's reliability
  at the protocol level but do not specify the RTT/RTO estimator. This is the
  authoritative source for casknet's RFC 6298 + Karn's-algorithm timer.
  New concept casknet-rtt-and-retransmission-timeout.
---

> Abstract: casknet runs reliability over unreliable UDP, so each `Peer` keeps a per-peer **retransmission timeout** (RTO) estimated exactly as TCP does. It tracks a smoothed round-trip time `SRTT` and an RTT variance `RTTVAR`, both as exponential moving averages (`SRTT = 7/8·SRTT + 1/8·sample`, `RTTVAR = 3/4·RTTVAR + 1/4·|SRTT − sample|`), seeded on the first sample (`SRTT = sample`, `RTTVAR = sample/2`). The RTO is the **RFC 6298** formula `RTO = SRTT + 4·RTTVAR`, clamped below by `RetransmissionTimeoutMinimum` and above by `RetransmissionTimeoutMaximum`; before the first sample arrives the RTO is just the configured minimum. Critically, RTT samples are taken **only from packets that were never retransmitted** (Karn's algorithm): once a packet is re-sent, an acknowledgment is ambiguous about which transmission it answers, so it is excluded from the estimator. When a packet is sent, its next-retry deadline is set to `now + RTO`; the `process` loop re-enqueues entries past their deadline.

This section carries the RTT/RTO estimator comments. It is implementation-only: the casknet design docs describe protocol reliability but do not pin the timer algorithm. Concept: [[casknet-rtt-and-retransmission-timeout]].

## The RTO formula (RFC 6298)

```go
// RFC 6298: RTO = SRTT + max(G, K*RTTVAR) where K=4 and G is clock granularity.
// We use RetransmissionTimeoutMinimum as the floor for the final RTO, not for the variance term.
roundTripTime := time.Duration(p.smoothedRoundTripTimeNanoseconds)
variation := time.Duration(p.roundTripTimeVariationNanoseconds)
retransmissionTimeout := roundTripTime + 4*variation
if retransmissionTimeout < p.cfg.RetransmissionTimeoutMinimum {
	retransmissionTimeout = p.cfg.RetransmissionTimeoutMinimum
}
if p.cfg.RetransmissionTimeoutMaximum > 0 && retransmissionTimeout > p.cfg.RetransmissionTimeoutMaximum {
	retransmissionTimeout = p.cfg.RetransmissionTimeoutMaximum
}
```

The comment is precise about one deviation from the RFC: the configured minimum is the floor on the **final** RTO, not on the variance term `K·RTTVAR`. When no samples have arrived (`smoothedRoundTripTimeNanoseconds == 0`) the function short-circuits to `RetransmissionTimeoutMinimum`, so a fresh peer retransmits on the configured floor until it has measured the path.

## The EMA update

```go
func (p *Peer) updateRoundTripTimeLocked(sample time.Duration) {
	...
	if p.smoothedRoundTripTimeNanoseconds == 0 {
		p.smoothedRoundTripTimeNanoseconds = sampleNanoseconds
		p.roundTripTimeVariationNanoseconds = sampleNanoseconds / 2
		return
	}
	// RTTVAR = 3/4 RTTVAR + 1/4 |SRTT - sample|
	// SRTT   = 7/8 SRTT + 1/8 sample
	...
}
```

The variance is updated **before** the smoothed mean (RFC 6298 ordering) so the deviation is measured against the old `SRTT`. The 1/8 and 1/4 gains are the canonical TCP weights (`alpha = 1/8`, `beta = 1/4`). Both values are stored as `uint64` nanoseconds on the `Peer` and read under `p.mu`; `RTTStats()` exposes `(srtt, rttvar, rto)` for observability and tests, and the doc on `RTTStats` notes all three are zero until the first successful acknowledgment.

## Karn's algorithm: ignore samples from retried packets

```go
// Karn's algorithm: only use RTT samples from packets that haven't been
// retransmitted, since we can't know which transmission the ack is for.
```

An acknowledgment for a hash that was sent more than once cannot be attributed to a particular transmission, so feeding its round-trip time into the estimator would corrupt `SRTT`. The acknowledge handler therefore only samples packets whose `sendCount` is 1. This is the classic Karn/Partridge fix that keeps a retransmission storm from poisoning the very timer that governs retransmission.

## Where the RTO is consumed

After `process` pops and sends an entry, it stamps `inflight.nextRetryAt = now + retransmissionTimeoutLocked()`. The send loop's `enqueueDueRetriesLocked` walks the in-flight set each tick and re-enqueues any entry past its `nextRetryAt`, incrementing `retryCount` (and, on the re-send, disqualifying the packet from RTT sampling per Karn). The CoDel sojourn-time shedding (see the [traffic-class drain section](cask--net-peer-go--traffic-class-send-queue-drain-prioritization.md) and [[codel-send-buffer-shedding]]) is a separate timer governing queue *admission*, independent of this per-packet retransmission timer.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 251-256, 1082-1129).
