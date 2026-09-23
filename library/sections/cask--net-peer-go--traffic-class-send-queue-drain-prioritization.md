---
title: Traffic-class send-queue drain prioritization
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "100-103, 798-811, 2204-2247"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How a full send queue blocks Store() callers per TrafficClass on a 129-channel drain-notify array, wakes the highest-priority (smallest-class) waiter first when a slot frees, and derives a caller's drain class from context or the casktel Span
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Implementation-side realization of the drainNotify / drainWaiterCount /
  notifyDrain / WithTrafficClass keywords already filed under
  codel-send-buffer-shedding. The CoDel sojourn shedding governs admission; this
  drain machinery governs which blocked writer wakes when a slot frees.
---

> Abstract: when a `Peer`'s send queue is full, a `Store` caller blocks rather than dropping the block, and casknet wakes blocked writers in **traffic-class priority order**. The peer holds two parallel 129-element arrays, one slot per `TrafficClass` 0..128 (lower class = higher priority): `drainNotify[c]` is a 1-buffered channel a waiter selects on, and `drainWaiterCount[c]` is an atomic count of writers blocked at class `c`. A blocked `Store` increments `drainWaiterCount[class]` and selects on `drainNotify[class]`. After the `process` loop drains one slot (a `PopPriority` or `Remove`), it calls `notifyDrain`, which scans classes from 0 upward and signals the **first** class that has a waiter — so the smallest (highest-priority) class that is blocked is served first. A caller's class comes from `drainClassFromContext`: an explicit `WithTrafficClass` on the context wins; otherwise the casktel `Span.TrafficClass()`; otherwise `DefaultDrainTrafficClass = 64`. `notifyDrain` is always called **after** the peer mutex is released, so `drainWaiterCount` reflects writers that have already committed to blocking.

This section carries the drain-prioritization comments. Concept: [[codel-send-buffer-shedding]] (the keywords `drainNotify`, `drainWaiterCount`, `notifyDrain`, `WithTrafficClass`, `TrafficClassFromContext` already resolve there). The CoDel admission shedding and this drain machinery are two distinct mechanisms over the same send buffer: CoDel decides *whether* to defer or drop; this decides *which blocked writer wakes* when a slot frees.

## Two parallel per-class arrays

```go
// drainNotify[0..128]: one channel per TrafficClass; process/cancel wake highest-priority waiter.
// drainWaiterCount[0..128]: atomic count of Store() callers blocked per class.
// See DESIGN.md.
drainNotify      [129]chan struct{}
drainWaiterCount [129]atomic.Int32
```

There are 129 classes because `TrafficClass` is `0..128` inclusive. Each `drainNotify[c]` is a 1-buffered channel; each `drainWaiterCount[c]` is a lock-free counter so `notifyDrain` can scan the priority ladder without taking the peer mutex.

## A blocked writer registers, then selects

In `Store`, when `enqueueStoreLocked` reports the queue is full, the caller registers itself and waits:

```go
p.drainWaiterCount[drainClass].Add(1)
p.mu.Unlock()
select {
case <-p.drainNotify[drainClass]:
	p.drainWaiterCount[drainClass].Add(-1)
	p.mu.Lock()
case <-ctx.Done():
	// decrement, delete inflight, span.Fail(ctx.Err()), span.Add(-1)
}
```

The wait is interruptible: a cancelled context unblocks the writer, which then cleans up its inflight entry and fails its span. After waking from `drainNotify`, the writer re-acquires the lock and retries `enqueueStoreLocked` in a loop, since another writer may have taken the freed slot first.

## notifyDrain wakes the smallest class with a waiter

```go
// notifyDrain wakes one Store() waiter from the highest-priority (smallest)
// TrafficClass that has waiters. Call only after the send queue has drained one
// slot (after PopPriority or Remove). See DESIGN.md for writer/reader ordering
// and why a drain cannot leave a writer blocking forever.
func (p *Peer) notifyDrain() {
	for c := 0; c < 129; c++ {
		if p.drainWaiterCount[c].Load() > 0 {
			select {
			case p.drainNotify[c] <- struct{}{}:
			default:
				// Channel full: one waiter already has a pending wake; slot stays free until next enqueue.
			}
			return
		}
	}
}
```

The scan from `c = 0` upward is the priority order: class 0 is the most important, class 128 the least, so the first class with a positive waiter count gets the single wake. The `default` branch handles the case where a wake is already pending on that class's buffered channel (the channel is full): rather than block, `notifyDrain` returns and the freed slot stays available until the next enqueue, which is safe because the already-pending wake will retry the loop. The DESIGN.md reference covers why this ordering cannot leave a writer blocked forever.

## After-unlock ordering

In `process`, the call site is deliberately placed after the mutex is dropped:

```go
p.mu.Unlock()
// Notify after unlock so blocked Store() callers are visible via drainWaiterCount.
p.notifyDrain()
p.sendEntry(entry)
```

Releasing the lock before `notifyDrain` guarantees that any writer that decided to block has already incremented `drainWaiterCount` (it does so under the lock, then unlocks and selects), so `notifyDrain` cannot miss a waiter that is about to park. This is the same mutate-under-lock / signal-after-unlock discipline the [span lifecycle section](cask--net-peer-go--command-request-span-lifecycle.md) uses for `Fail`/`Add(-1)`.

## Where the class comes from

```go
// drainClassFromContext returns the TrafficClass to use for drain waiting (0-128).
// Uses TrafficClassFromContext; if not set, uses Span.TrafficClass if present,
// else returns DefaultDrainTrafficClass.
```

`DefaultDrainTrafficClass = 64` sits at the middle of the ladder. The precedence is: explicit `WithTrafficClass(ctx, class)` first, then the casktel `Span.TrafficClass()` carried on the context, then the default. Values above 128 are clamped to 128. This lets a caller that already attached a span for completion tracking (see the [span lifecycle section](cask--net-peer-go--command-request-span-lifecycle.md)) inherit that span's traffic class for backpressure prioritization without a second annotation.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 100-103, 798-811, 2204-2247).
