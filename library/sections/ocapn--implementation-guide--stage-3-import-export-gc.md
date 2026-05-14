---
title: Stage 3 — import/export GC (op:gc-exports + wire-delta)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: The wire-delta mechanism is the non-obvious correctness piece of cooperative distributed GC — without it, a GC message that overtakes a still-in-flight reference would cause a dangling reference. Cross-cuts with ocapn--draft-specifications-captp--* (the spec) and Endo's CapTP GC plumbing (endo--pkg-captp-readme--*).
---

> Abstract: Stage 3 milestone: cooperative distributed GC of exports. `op:gc-exports export-pos-list wire-delta-list` is sent by the *importer* (the receiver) when it no longer needs a set of references. Both sides keep wire reference counts. The `wire-delta-list` field is the count of how many references the importer has *received* for each `export-pos` since the last `op:gc-exports` it sent for that position. When the exporter receives the GC message, it subtracts the wire-delta from its own send-count; if the remaining count is zero, the export can be reclaimed. The wire-delta is what makes the protocol safe against the race where a GC message overtakes an in-flight reference: if the exporter has sent N references and received the importer's GC counting only K of them, the exporter still has N-K outstanding and must wait.

### Stage 3: import/export gc

Alisha looks at her export table and sees the following:

- `0 -> <bootstrap object>`
- `1 -> <bootstrap fetch resolve-me-desc>`
- `2 -> <robot beep resolve-me-desc>`
- `3 -> <beep's vow listen resolve-me-desc>`
- `4 -> <move forward resolve-me-desc>`

A lot of objects hanging around. Alisha implements GC.

CapTP has two GC ops; this stage covers `op:gc-exports` (the other, `op:gc-answers`, is for questions and answers — stage 5).

```
<op:gc-exports export-pos-list   ; list of positive integers
               wire-delta-list>  ; list of positive integers
```

CapTP GC is collaborative: both sides count references seen in CapTP messages. When the importing side no longer needs a set of objects it sends `op:gc-exports` where `export-pos-list` contains the released `export-pos` values and `wire-delta-list` contains the corresponding count of references received for each since the last `op:gc-exports` for that object.

Why the wire-delta? Consider Peer A exporting `alice`. Alice has been referenced in many CapTP messages — say two have been received by Peer B and three are still on the wire. Peer B has incremented its reference count of `alice` twice, then decides it no longer needs the object and sends an `op:gc-exports`. Three more `alice`-referencing messages arrive *after* the GC was emitted. If Peer A naively GC'd alice on receiving the GC op, those three references would be dangling.

The wire-delta solves this: Peer B's GC carries `wire-delta-list: 2` (the count of references B has *seen* so far). Peer A subtracts 2 from its own send-count. If A had sent 5 references, the result is 3 — still > 0, so A waits. Once B sees the three more and emits another `op:gc-exports` with wire-delta 3, A can reclaim.

Alisha's implementation:

- Two tables: GC count for imported objects, GC count for exported objects.
- Before transmitting any `op:deliver`, walk the args and increment the export GC count for any references mentioned.
- On incoming messages, increment the import GC count similarly.
- Register a finalizer on her language's GC: when a local proxy for an imported object is freed, emit `op:gc-exports` with the wire-delta = references-received-since-last-GC.
- On receiving `op:gc-exports`, subtract each wire-delta from the corresponding count. When a count reaches zero, drop the entry from both tables.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
