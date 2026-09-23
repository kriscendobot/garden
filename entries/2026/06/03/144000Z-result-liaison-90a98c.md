---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--90a98c
ts: 2026-06-03T14:40:00Z
ref_id: 90a98c
---

# Cycle 158 result — captp/src/loopback.js (thirty-eighth comment-fragment ingest; third @endo/captp source file)

Cycle 158 of the librarian arc. Nominally chat-lane (exhausted at
20/20); papers-lane blocked **52+ consecutive cycles**. Pivoted to
comments-lane.

## Source

`endo/packages/captp/src/loopback.js` (117 lines). Kris Kowal
authored; last touched 2025-10-09 in cycle 108's coordinated-update
commit `e56bf00f`.

**Third @endo/captp source file ingested** after cycle 154's
trap.js and cycle 156's finalize.js. The loopback *composes* both
of them — the in-process CapTP test fixture demonstrates how the
trap and the finalizing-map work in practice.

## Structural moves captured

- **Single most structurally interesting move**: §two-CapTP-
  instances-cross-wired architecture. Each side receives *the
  other's* dispatch function as its *send* hook. §forward-
  reference-via-arrow (`o => farDispatch(o)` wraps farDispatch
  before it exists at call site). §closure-captures-binding-not-
  value JS-language fact made load-bearing. §eslint-disable-no-
  use-before-define explicit comments → §eslint-as-design-
  discipline.

- **§Single-bootstrap-shared-by-both-sides**: same `Far('refGetter',
  { getRef(nonce) })` exo passed to both `makeCapTP` calls.
  §getRef-also-deletes pattern (use-once-then-remove discipline);
  §nonce-as-handshake-key observation.

- **§makeRefMaker closure factory**: §two-callers-one-pattern-via-
  closure (makeFar/makeNear differ only in which bootstrap they
  ask). §Uniform-async-shape; §harden-the-value-before-set.

- **§Uses-finalize.js-Weak-Value-Map**: calls cycle 156's
  `makeFinalizingMap()` *without arguments* → §plain-Map-via-
  fakeFinalizingMap default branch. §Test-utility-doesn't-want-
  gc-nondeterminism observation — concretely applies cycle 156's
  §gc-as-side-channel warning by *not* using weak-values mode.

- **§Synchronous-trap-bridge via `trapGuest`**: cycle 154's
  `nearTrapImpl` invoked synchronously through §sync-trap-by-
  crossing-the-boundary-immediately pattern. §use-the-far-side's-
  marshal-functions (uses far's `farUnserialize`/`farSerialize`
  for the *near*-side trap). §trap-bypasses-the-async-protocol
  property. §isException-tagged-tuple-result `[isException,
  serialized]`; §tagged-tuple-because-no-Promise-rejection-
  channel. §slotBody-hardcoded canonical-marshal-string.

- **§which-side's-marshal-tables-do-we-use** answered by §marshal-
  side-tracks-object-ownership discipline.

- **§Re-export-E-from-captp** convenience; §single-entry-point-
  for-test-fixtures.

- **§Test-utility-composes-substrate** pattern: reading the
  loopback teaches the production code by *seeing how it's used*.
  §Distributed-protocol-test-fixture-as-genre.

## Output summary

- **Source slug**: `endo--packages-captp-src-loopback-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge.md`
- **Topics**: captp, eventual-send, hardened-javascript
- **Library totals**: 662 sections from 203 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 52+ consecutive cycles); pivoted to comments-lane

## Cluster note

Coordinated-update commit `e56bf00f` cluster grows to **17 files**:
cycles 108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 +
140 + 144 + 148 + 150 + 152 + 154 + 158. The @endo/captp cluster
now has three of six substantial source files ingested (trap.js +
finalize.js + loopback.js); captp.js (1012 lines, wire protocol)
and atomics.js (170 lines, SharedArrayBuffer substrate) remain
candidates.

Cycle 158 closes. Schedule next wake 1500s for cycle 159.
