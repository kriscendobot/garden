---
title: Encrypted-acknowledge batching — per-session grouping, batch-or-timeout flush, and average-holdback computation
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "1483-1567"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How the Peer queues encrypted store-acknowledges and flushes them in batches grouped by session ID, flushing a session's batch when it reaches AcknowledgeBatchSize or its holdback deadline passes, and folding the per-entry receive-to-send delay into a single average-holdback field the remote subtracts from its RTT sample
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Acknowledge-batching path of peer.go, paired with the RTT-estimation section
  (cask--net-peer-go--rtt-estimation-and-retransmission-timeout) because the
  average-holdback field is what keeps the remote's RTT sample honest. Cross-
  references casknet-wire-protocol (the rots store-ack carries the averaged
  holdback) and the casksock-local-protocol RTT-bounded ackn batching it mirrors.
---

> Abstract: a `casknet` `Peer` does not acknowledge every received block immediately; it queues encrypted acknowledges and flushes them in batches. `noteEncryptedAcknowledge` appends a pending `{sessionID, hash, receivedAt}` entry under the peer lock and records the first-pending timestamp; `flushEncryptedAcknowledgesLocked` groups the pending entries **by session ID** and, for each session, flushes only when the batch reaches `AcknowledgeBatchSize` **or** the holdback deadline has passed. For each flushed batch it computes an **average holdback** — the mean of `now − receivedAt` across the batched hashes — and folds it into the store-ack plaintext so the remote can subtract the time this peer deliberately held the acknowledge back from its own round-trip-time measurement. The batch is encrypted under the session, sent directly (acknowledges are treated as high priority, bypassing the send queue), and the sent entries are removed while any leftover entries above the batch size stay pending for the next flush.

This section carries the encrypted-acknowledge batching path. It pairs with [rtt-estimation-and-retransmission-timeout](cask--net-peer-go--rtt-estimation-and-retransmission-timeout.md): the average-holdback field exists precisely so that batching acknowledges does not corrupt the remote's RTT estimate. The store-ack itself is the `rots` command in [[casknet-wire-protocol]]; the same RTT-bounded batching appears on the local socket as the `ackn` batching of [[casksock-local-protocol]].

## Queuing a pending acknowledge

```go
// noteEncryptedAcknowledge queues an encrypted acknowledge for batching.
func (p *Peer) noteEncryptedAcknowledge(sessionID cask.Hash, hash cask.Hash, receivedAt time.Time) {
	p.start()
	p.mu.Lock()
	p.encryptedAckPending = append(p.encryptedAckPending, encryptedAckEntry{
		sessionID:  sessionID,
		hash:       hash,
		receivedAt: receivedAt,
	})
	if len(p.encryptedAckPending) == 1 {
		p.encryptedAckFirstAt = receivedAt
	}
	p.mu.Unlock()
	p.kick()
}
```

Each received block to be acknowledged records when it was received. The first entry in an empty queue stamps `encryptedAckFirstAt`, which anchors the holdback deadline. `kick` nudges the peer's send loop so a flush is evaluated promptly rather than only on the next timer tick.

## Group by session, flush on batch-full or deadline

```go
// Group by session ID
bySession := make(map[cask.Hash][]encryptedAckEntry)
for _, entry := range p.encryptedAckPending {
	bySession[entry.sessionID] = append(bySession[entry.sessionID], entry)
}

batchSize := p.cfg.AcknowledgeBatchSize
if batchSize == 0 {
	batchSize = DefaultConfig().AcknowledgeBatchSize
}

for sessionID, entries := range bySession {
	// Check if we should flush (batch full or timeout)
	deadline := p.acknowledgeDeadlineLocked(now)
	if len(entries) < batchSize && now.Before(deadline) {
		continue
	}
	// Take up to batchSize entries
	count := len(entries)
	if count > batchSize {
		count = batchSize
	}
	batch := entries[:count]
	...
}
```

Acknowledges are partitioned by session because each batch is encrypted under one session's key and sent to one peer address. A session's batch is sent when either it has accumulated `AcknowledgeBatchSize` entries or its holdback deadline (`acknowledgeDeadlineLocked`) has elapsed, whichever comes first — the standard Nagle-style "send a full packet, or send what you have once you have waited long enough" trade-off. Only up to `batchSize` entries go out per flush; a session that has more than a full batch pending keeps the remainder for the next flush.

## Average-holdback computation

```go
// Calculate average holdback
var sumHoldback uint64
hashes := make([]cask.Hash, 0, count)
for _, e := range batch {
	hashes = append(hashes, e.hash)
	if now.After(e.receivedAt) {
		sumHoldback += uint64(now.Sub(e.receivedAt).Nanoseconds())
	}
}
avgHoldback := sumHoldback / uint64(len(hashes))

// Build and encrypt acknowledge
plaintext := buildStoreAckPlaintext(hashes, avgHoldback)
packet, err := p.server.Sessions.Encrypt(sessionID, plaintext)
...
// Send directly (acknowledges are high priority)
_, _ = p.server.conn.WriteToUDP(packet, p.address)
```

The holdback is the time this peer deliberately sat on each acknowledge before sending it (`now − receivedAt`), averaged across the batched hashes and carried as a single field in the store-ack plaintext. The sender of the original blocks subtracts this averaged holdback from its measured round-trip time, so that intentional batching delay is not mistaken for network latency — without it, batching acknowledges would inflate every RTT sample and push the [retransmission timeout](cask--net-peer-go--rtt-estimation-and-retransmission-timeout.md) too high. The encrypted batch is written **directly** to the UDP connection rather than through the per-class send queue, because acknowledges are high priority: delaying them further would defeat the holdback accounting. After sending, the flushed entries are dropped and the pending list is rebuilt from whatever remained across all sessions; an emptied list clears `encryptedAckFirstAt`.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 1483-1567).
