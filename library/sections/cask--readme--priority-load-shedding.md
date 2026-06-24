---
title: Priority-aware load shedding
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: CASK's load-shedding model. Every block in flight carries a one-byte traffic class (0–128) and a 128-bit trace identifier. Priority is computed as `Trace >> (128 - TrafficClass)`, producing a 256-bit ordering in which lower traffic class and lower trace value mean higher priority. The send buffer dequeues by priority; when full, backpressure is applied per traffic class via 129 notifier channels (one per class) so the highest-priority blocked sender is woken first when a slot frees. A relay or gateway watching envelope TTLs can expire idle packets and shed low-priority traffic under load — in a 100-worker fan-out at twice capacity, coordinated shedding on the priority figure lets roughly half of aggregate requests succeed, losing capacity only to already-excess packets.

Every block in flight carries a one-byte traffic class (0–128) and a 128-bit trace identifier. Priority is computed as `Trace >> (128 - TrafficClass)`, producing a 256-bit ordering: lower traffic class and lower trace value mean higher priority (see the `trace` design doc).

The send buffer dequeues by priority, and when it is full, backpressure is applied per traffic class: 129 notifier channels (one per class) ensure that the highest-priority blocked sender is woken first when a slot frees (see the `net-design` doc).

A relay or gateway watching TTLs in the envelope can expire idle packets and shed low-priority traffic under load. In a fan-out scenario — a gateway dispatching to 100 workers, each at twice capacity — coordinated shedding on the priority figure means roughly half of aggregate requests succeed, with capacity lost only to packets that were already in excess.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
