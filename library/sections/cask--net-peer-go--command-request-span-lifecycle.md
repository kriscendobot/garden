---
title: The span-tracked request lifecycle of Store / Load / CAS / Collect / Weigh
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "266-628"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How a Peer's public operations enqueue work and return immediately, tracking completion through a casktel Span (Add(1) on enqueue, Add(-1) on ack, Fail(err)+Add(-1) on error), with inflight coalescing and the Fail-outside-lock ordering rule
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
notes: |
  casknet-side consumer of the casktel-span-completion concept: every Peer
  operation is fire-and-forget over UDP, and the Span is how the caller learns
  when the remote acknowledges. Cross-references casktel-span-completion (the
  Span contract) and casknet-wire-protocol (the commands these operations send).
---

> Abstract: every public operation on a casknet `Peer` (`Store`, `Load`, `CAS`, `Collect`, `Weigh`, `Acknowledge`) is **fire-and-forget over UDP**: it ensures an encrypted session, encrypts the command plaintext, enqueues it on the send buffer, and returns immediately. Completion is reported not through the return value but through a [[casktel-span-completion|casktel Span]] extracted from the request context. `Store` calls `span.Add(1)` when it accepts the block and `span.Add(-1)` when the remote acknowledges; on any failure it calls `span.Fail(err)` then `span.Add(-1)`. The caller enqueues many stores, then waits once on `<-span.Done()` and checks `span.Err()`. Duplicate in-flight stores of the same hash **coalesce**: a second `Store` of a hash already in flight appends its span to the existing `inflight` entry rather than sending a second packet, so one acknowledgment fans out to every waiting span. The request/response operations (`CAS`, `Collect`, `Weigh`) instead key a per-`spanID` in-flight map and block the calling goroutine on a response channel until the reversed-command reply arrives or the context cancels.

This section carries the request-lifecycle comments on `peer.go`'s public surface. Concept: [[casktel-span-completion]] (the Span `Add` / `Done` / `Fail` contract); the commands these operations put on the wire are catalogued under [[casknet-wire-protocol]].

## Store: enqueue, return, resolve on acknowledgment

```go
// Store enqueues a block for storage on the remote peer. It extracts the span
// from context (or uses nopcasktel.Nop if none), calls span.Add(1), enqueues
// the block, and returns immediately. On acknowledgment, span.Add(-1) is called;
// on failure, span.Fail(err) then span.Add(-1).
//
// Callers wait on <-span.Done() after all stores are enqueued, then check span.Err().
```

The body realizes the comment exactly: `ensureSession` first (so the block can be encrypted under a live session), then `span.Add(1)`, then it builds the store plaintext, encrypts it, and inserts an `inflight` entry keyed by the block hash. The operation never blocks on the network — the only thing it can block on is a **full send queue**, and even that is interruptible by `ctx.Done()` (on cancel it deletes the inflight entry, calls `span.Fail(ctx.Err())` + `span.Add(-1)`, and returns the context error). When the remote's `rots` acknowledgment arrives, the receive path calls `span.Add(-1)` for every span on the inflight entry, releasing the caller's `<-span.Done()`.

## In-flight coalescing: one packet, many spans

```go
if existing, ok := p.inflight[hash]; ok {
	existing.spans = append(existing.spans, span)
	p.mu.Unlock()
	p.kick()
	return nil
}
```

If a `Store` of a hash is requested while an identical hash is already in flight, the second call does **not** send a second packet. It appends its span to the existing entry's `spans` slice and returns. A single acknowledgment then resolves every coalesced span. This makes redundant stores of the same content (common when a Merkle tree shares sub-blocks) cost one round trip, not N.

## Request/response operations block on a per-spanID channel

`CAS`, `Collect`, and `Weigh` are not fire-and-forget — the caller needs the remote's answer. Each allocates a random `spanID`, registers a small in-flight record in a per-operation map keyed by that `spanID` (`casInflight`, `collectInflight`, `weighInflight`), sends the command, and blocks on a response channel:

```go
// CAS performs a compare-and-swap on the remote peer's store.
// Returns (success, currentValue, error).
// If the swap succeeds, success is true and currentValue equals new.
// If the swap fails due to a race, success is false and currentValue is the actual value.
// If unauthorized, returns ErrCASUnauthorized.
```

When the reversed-command reply (`csac` for `casc`, `cgcg` for `gcgc`, `ssam` for `mass`) arrives, the receive path looks up the `spanID`, delivers the result on the channel, and the blocked caller returns. The `spanID` is the correlation token that ties an asynchronous UDP reply back to the synchronous caller; it is the same field the wire layouts carry (see [[casknet-wire-protocol]]).

## Fail and Sub outside the lock

```go
// Fail and Sub outside lock to avoid deadlock
```

Span callbacks (`Fail`, `Add(-1)`) can run arbitrary caller-supplied tracer code, so the receive path collects the spans to resolve **while holding `p.mu`**, releases the lock, and only then invokes the span callbacks. Calling a span callback under the peer mutex would let tracer code that re-enters the peer (a metric read, a nested store) deadlock. This ordering — mutate peer state under the lock, run span side effects after unlock — recurs throughout the file (the `notifyDrain` call in `process` follows the same "after unlock" discipline; see the [traffic-class drain section](cask--net-peer-go--traffic-class-send-queue-drain-prioritization.md)).

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 266-628).
