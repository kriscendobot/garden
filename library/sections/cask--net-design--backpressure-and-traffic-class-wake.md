---
title: Backpressure and Wake-by-TrafficClass
source: doc/design/net-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, data-structures]
status: current
---

> Abstract: How a casknet Peer applies backpressure on local senders and wakes them in priority order. When the send queue is full, the Peer **blocks** callers of `Store()` until a packet drains (or the context is cancelled) rather than growing the buffer; the goal is to slow producers instead of accumulating unbounded queue and latency. The sendbuffer already prioritizes correctly **at dequeue** (the Peer sends by `PopPriority()`, highest priority first). The fix this doc adds is prioritization **at enqueue**: previously all blocked `Store()` callers waited on a single notifier channel, so whichever waiter woke on a freed slot was arbitrary regardless of TrafficClass. The implementation replaces that with a bank of 129 notifier channels `drainNotify[0..128]` (one per TrafficClass) and 129 atomic counters `drainWaiterCount[0..128]`: a blocked caller reads its TrafficClass from context (`TrafficClassFromContext`, default 64), increments its class counter, and blocks on `drainNotify[class]`; when the queue drains, `notifyDrain()` scans classes 0→128, finds the smallest class with waiters, and does a non-blocking send to wake one. Lower class number is higher priority, so a freed slot wakes a class-0 waiter before class-1, and so on.

## Backpressure instead of growing the buffer

When the send queue is full, the Peer blocks callers of `Store()` until at least one packet has been drained (or the context is cancelled). The buffer is **not** grown to absorb more traffic. The goal is to place backpressure on local senders so they do not overcommit: if the network or receiver cannot keep up, producers slow down instead of the queue growing unbounded and latency climbing.

## Failure mode (addressed): outbound prioritization at enqueue

Previously, when the send queue was full, multiple `Store()` callers blocked on a **single** notifier channel. Which waiter woke when a slot freed was effectively arbitrary, so concurrent local producers had equal probability of onboarding regardless of TrafficClass or priority. The sendbuffer prioritizes correctly **at dequeue** (the Peer sends by `PopPriority()`, so the next packet is always the highest-priority, smallest-priority-value, in the queue); the gap was at enqueue.

## Implementation: wake by TrafficClass

TrafficClass is in the range 0–128 (one byte). The Peer prioritizes who gets woken when the queue drains:

- **Bank of 129 notifier channels** (`drainNotify[0..128]`), one per TrafficClass. A blocked `Store()` call reads its TrafficClass from context (`TrafficClassFromContext`; default 64 if unset), increments the atomic waiter count for that class, and blocks on `drainNotify[class]`. On wake or cancellation it decrements.
- **129 atomic ints** (`drainWaiterCount[0..128]`): count of `Store()` callers blocked per TrafficClass.
- **When the queue drains** (`notifyDrain()`): scan from class 0 to 128, find the first (smallest) class with `drainWaiterCount[c].Load() > 0`, and do a non-blocking send on `drainNotify[c]` to wake one waiter.

Callers set TrafficClass via `WithTrafficClass(ctx, class)`. Lower class number is higher priority: when a slot frees, a TrafficClass-0 waiter is woken if any wait, else class 1, and so on.

Source: [doc/design/net-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-design.md) at commit `cdb975d8`.
