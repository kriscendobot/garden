---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §Three-buffer-write-order discipline
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

The host code does, in order:

1. `databuf.set(subenc)` — fill data first.
2. `lenbuf[0] = remaining` — set length.
3. `statusbuf[0] = rejectFlag | doneFlag` — set status (the
   atomic write).
4. `Atomics.notify(statusbuf, 0, +Infinity)` — wake guest.

§Write-status-last-then-notify. The guest is blocked on
`Atomics.wait(statusbuf, 0, STATUS_WAITING)` — it wakes
when statusbuf is changed *and* notified. §Status-write-
plus-notify is the §commit-point of each chunk.

§If-status-was-set-before-data: the guest could wake up
(via spurious wake or its own polling) and read stale data.
§Order-matters-for-correctness.

§The-comment-doesn't-spell-this-out — the order is enforced
by §code-position-not-by-explicit-discipline. §Implicit-
invariant noted here.
