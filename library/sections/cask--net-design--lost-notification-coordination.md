---
title: Lost-Notification Coordination
source: doc/design/net-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The concurrency argument for why the wake-by-TrafficClass drain mechanism never loses a notification, so no `Store()` waiter blocks forever. The key ordering: a writer that finds the queue full increments `drainWaiterCount[class]` **while still holding `p.mu`**, then unlocks, then blocks on `select { <-drainNotify[class] | <-ctx.Done() }`; on wake it decrements, re-locks, and retries enqueue. The reader drains one slot (`PopPriority` or `Remove`), unlocks **before** calling `notifyDrain()`, then scans and does a non-blocking send to the smallest waiting class. Because the increment happens under the lock and the notify happens after the unlock-plus-drain, any reader running after the writer's unlock observes the incremented count via the atomic Load. The notifier channels have capacity 1: if two drains happen before any waiter runs, the second `notifyDrain` may find the channel full and take the default branch, but no waiter is lost (one value sits in the channel for one waiter; the other drain simply left a slot free that the next enqueue attempt fills without blocking). Decrement-on-wake keeps the count equal to the number of actually-blocked writers, so a single drain never double-wakes (one send → one receive → one decrement).

## Writer (Store when queue full)

1. Hold `p.mu`; enqueue fails (queue full).
2. `drainWaiterCount[class].Add(1)` — visible to the reader before we block.
3. `p.mu.Unlock()` — the reader can now run process(), drain, then notifyDrain().
4. Block on `select { <-drainNotify[class] | <-requestContext.Done() }`.
5. On wake: `drainWaiterCount[class].Add(-1)`, re-acquire `p.mu`, retry enqueue.
6. On context done: decrement, re-acquire lock, remove from inflight, return.

The writer increments the count **while holding the lock**, then unlocks, then blocks. So by the time it is in the select, the count is already incremented, and any reader that runs after the unlock sees the increment when it does `drainWaiterCount[c].Load()` in notifyDrain().

## Reader (process after PopPriority / cancel after Remove)

1. Drain one slot (PopPriority or Remove); update queue/slots.
2. `p.mu.Unlock()` — do not hold the lock while notifying.
3. `notifyDrain()`: for c = 0..128, if `drainWaiterCount[c].Load() > 0`, non-blocking send on `drainNotify[c]`, then return.
4. Send the packet (process) or finish cancel.

The reader observes the waiter count **after** the slot is actually free, so a writer that incremented and blocked is visible.

## Why a drain notification cannot pass unnoticed

- **Writer blocks after increment.** Whenever a writer is blocked on `<-drainNotify[class]`, its class count is already incremented; any later drain sees count > 0 and sends, waking it.
- **Writer increments before unlock.** A writer that just unlocked and is about to select has already incremented. If the reader runs immediately, it sees count > 0 and sends; the channel is empty so the send succeeds, and the writer receives it as soon as it enters the select. It does not "miss" the notification by not being in the select yet.
- **Channel capacity 1.** If two drains happen before any waiter runs, the second notifyDrain may find the channel full and take the default branch. No waiter is lost: one value sits in the channel for one waiter, and the other drain left a slot free that the next `Store()` enqueue fills without blocking.
- **Decrement on wake.** A woken writer decrements before re-locking, so the count again matches the number of writers actually blocked. One drain never double-wakes (one send → one receive → one decrement).

## Summary

The ordering (increment under lock → unlock → block; drain → unlock → Load count → send) plus one buffered channel per class ensures every drain either wakes one waiter (send succeeds) or finds no waiters (all counts 0). A writer that incremented and blocked is eventually observed and woken, so no writer can block forever on a missed notification.

Source: [doc/design/net-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-design.md) at commit `cdb975d8`.
