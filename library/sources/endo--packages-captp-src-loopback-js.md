---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/captp/src/loopback.js
source_line_range: 1-117
file_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
file_commit_date: 2025-10-09
file_commit_author: Kris Kowal
comment_subject: two CapTP instances cross-wired with shared bootstrap and synchronous trap-bridge
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-eighth comment-fragment ingest (cycle 158). 117-line
  @endo/captp *async-isolated-channel primitive* — the
  in-process test fixture for CapTP. Exports `makeLoopback`.
  Kris Kowal authored; last touched 2025-10-09 in cycle 108's
  coordinated-update commit `e56bf00f`.

  **Third @endo/captp source file ingested** after cycle
  154's trap.js and cycle 156's finalize.js.

  Single most structurally interesting move: §two-CapTP-
  instances-cross-wired architecture. Two makeCapTP calls
  each receive *the other's* dispatch function as the *send*
  hook. §Forward-reference-via-arrow observation: first call
  wraps farDispatch in arrow `o => farDispatch(o)` because
  farDispatch doesn't exist yet at call site (bound later by
  second makeCapTP). §closure-captures-binding-not-value JS-
  language fact made load-bearing. Explicit §eslint-disable-
  no-use-before-define comments — §eslint-as-design-discipline.

  §Single-bootstrap-shared-by-both-sides shape: same
  `Far('refGetter', { getRef(nonce) })` exo passed to both
  makeCapTP calls. §getRef-also-deletes pattern — §use-once-
  then-remove discipline. §nonce-as-handshake-key observation
  (number travels over CapTP; value stays local; nonce is
  the bridge).

  §makeRefMaker closure factory: §two-callers-one-pattern-
  via-closure (makeFar and makeNear differ only in which
  bootstrap they ask). §uniform-async-shape (both makeFar
  and makeNear are async even when symmetry could be broken).
  §harden-the-value-before-set defense-in-depth.

  §Uses-finalize.js-Weak-Value-Map observation: calls
  `makeFinalizingMap()` *without arguments* — default
  weakValues=false → §plain-Map-via-fakeFinalizingMap branch
  from cycle 156. §test-utility-doesn't-want-gc-
  nondeterminism observation: even where weak-value-map
  could be used, loopback chooses *not* to — preserving
  deterministic test behavior. Illustrates cycle 156's
  §gc-as-side-channel warning in concrete application.

  §Synchronous-trap-bridge via `trapGuest` option: cycle
  154's `nearTrapImpl` invoked synchronously after
  §sync-trap-by-crossing-the-boundary-immediately pattern —
  uses the far side's `farUnserialize` to reconstruct the
  actual JS object *synchronously*, then calls
  `nearTrapImpl[trapMethod](far, ...)`. §Use-the-far-side's-
  marshal-functions discipline. §trap-bypasses-the-async-
  protocol property.

  §isException-tagged-tuple-result for synchronous return:
  `[isException: boolean, serialized: capdata]`. §tagged-
  tuple-because-no-Promise-rejection-channel observation
  (sync calls don't have a rejection channel; tuple replaces
  it).

  §slotBody-hardcoded-as-canonical-marshal-form: JSON
  literal `{ "@qclass": "slot", "index": 0 }` precomputed
  and shared — §canonical-single-slot-marshal-string
  discipline.

  §which-side's-marshal-tables-do-we-use? answered by *which
  side owns the object* (not which side sent the message).
  §marshal-side-tracks-object-ownership discipline.

  §Re-export-E-from-captp convenience: callers `import {
  makeLoopback, E }` from one file. §single-entry-point-for-
  test-fixtures pattern.

  §Test-utility-composes-substrate pattern: loopback
  *exercises* the production code; sits one layer up from
  the substrate. Reading the loopback teaches the production
  code by seeing how it's used.

  §Distributed-protocol-test-fixture-as-genre: the §shared-
  bootstrap + nonce-keyed ref-table + cross-wired dispatch
  pattern is reusable beyond CapTP testing.

  Same coordinated-update commit `e56bf00f` as cycles 108 +
  110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 + 140
  + 144 + 148 + 150 + 152 + 154 + 158 (17-file cluster now).

  Cycle 158 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 52+ consecutive cycles. Pivoted to
  comments-lane.
---

> Abstract: `loopback.js` (117 lines) is the **async-
> isolated-channel primitive** for `@endo/captp`. The
> in-process test fixture for CapTP. Exports `makeLoopback`.
>
> **Third @endo/captp source file ingested** after cycle
> 154's trap.js and cycle 156's finalize.js.
>
> **Single most structurally interesting move**: §two-CapTP-
> instances-cross-wired architecture. §forward-reference-via-
> arrow + §closure-captures-binding-not-value. §eslint-as-
> design-discipline.
>
> §Single-bootstrap-shared-by-both-sides shape; §getRef-also-
> deletes pattern; §nonce-as-handshake-key observation.
>
> §makeRefMaker closure factory with §two-callers-one-pattern-
> via-closure; §uniform-async-shape.
>
> §Uses-finalize.js-Weak-Value-Map (cycle 156) in the §plain-
> Map-via-fakeFinalizingMap default branch. §test-utility-
> doesn't-want-gc-nondeterminism — applies cycle 156's
> §gc-as-side-channel warning concretely.
>
> §Synchronous-trap-bridge via `trapGuest` option using cycle
> 154's `nearTrapImpl` and the far side's `farUnserialize`
> for §sync-trap-by-crossing-the-boundary-immediately.
> §isException-tagged-tuple-result. §slotBody-hardcoded-as-
> canonical-marshal-form.
>
> §which-side's-marshal-tables-do-we-use answered by §marshal-
> side-tracks-object-ownership discipline.
>
> §Test-utility-composes-substrate pattern. §Distributed-
> protocol-test-fixture-as-genre.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge](../sections/endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge.md) | captp, eventual-send, hardened-javascript | current |

Tight 117-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `e56bf00f289ff8484094b785b11636b8bc71d87e`) via the local
  bare-clone.
- Last substantive touch 2025-10-09 by Kris Kowal in commit
  `e56bf00f` ("feat: Adopt @endo/harden"). Same coordinated-
  update commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
  132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152 + 154 +
  158 (17-file cluster).
- **Thirty-eighth comment-fragment ingest.** **Third
  @endo/captp source file ingested** after cycle 154's
  trap.js and cycle 156's finalize.js.
- Cycle 158 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane has been blocked for **52+ consecutive cycles**.
  Cycle 158 pivoted to comments-lane.
- One cohesion-honest section.
