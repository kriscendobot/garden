---
source: doc/design/net-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The peer send-buffer backpressure design for casknet. Rather than growing the send buffer when it fills, a Peer blocks `Store()` callers to apply backpressure on local producers, and (the fix this document introduces) wakes them in TrafficClass priority order on drain via a bank of 129 per-class notifier channels and atomic waiter counters, complementing the sendbuffer's existing dequeue-side `PopPriority()` ordering. The second half is a careful concurrency proof that the increment-under-lock / notify-after-unlock ordering plus capacity-1 channels guarantee no drain notification is ever lost, so no waiter blocks forever. This is the enqueue-side complement to the CoDel-style dequeue-side load shedding in `trace.md` and the README's priority-load-shedding section.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [backpressure-and-traffic-class-wake](../sections/cask--net-design--backpressure-and-traffic-class-wake.md) | networking, data-structures | current |
| [lost-notification-coordination](../sections/cask--net-design--lost-notification-coordination.md) | networking | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Complements `cask--trace--traffic-class-and-priority` and `cask--readme--priority-load-shedding` (dequeue-side shedding); filed under the `codel-send-buffer-shedding` concept as the enqueue-side backpressure mechanism.

Source: [doc/design/net-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-design.md) at commit `cdb975d8`.
