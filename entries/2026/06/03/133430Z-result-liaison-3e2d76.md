---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--3e2d76
ts: 2026-06-03T13:34:30Z
ref_id: 3e2d76
---

# Cycle 156 result — captp/src/finalize.js (thirty-seventh comment-fragment ingest)

Cycle 156 of the librarian arc. Nominally chat-lane (exhausted at
20/20); **papers-lane blocked 50+ consecutive cycles — milestone**.
Pivoted to comments-lane.

## Source

`endo/packages/captp/src/finalize.js` (141 lines). Mark S. Miller
authored. Last touched 2025-06-23 (commit `5efcf7dd0`, *refactor
(pass-style): faster `isObject` (#2860)*). Not in cycle 108's
coordinated-update commit cluster — predates the @endo/harden
migration.

**Second @endo/captp source file ingested** (after cycle 154's
trap.js).

## Structural moves captured

- **§Weak-on-values-not-on-keys distinction**: dual of std JS
  WeakMap. §Multi-map-coordinated-removal via
  FinalizationRegistry. §Keys-stay-but-entries-disappear semantic.

- **Single most structurally interesting move**: §gc-as-side-
  channel warning *named explicitly in JSDoc*. §Timing-independent-
  side-channel observation (unlike most side channels needing a
  clock). §Blockchain-replay hazard: *could cause validators to
  differ from each other, preventing consensus*. §Nondeterminism-
  breaks-consensus. §Primitive-exists-but-must-not-be-used-in-some-
  contexts discipline.

- **§Two-mode design** with §graceful-fallback-via-
  fakeFinalizingMap (plain Map wrapped as `Far('fakeFinalizingMap')`
  when WeakRef unavailable or `weakValues=false`). §Honest-
  tagging-when-degraded; §dangerous-mode-not-default.

- **§FinalizationRegistry callback routes through `delete`** —
  §unified-finalize-path (gc / explicit delete / set-overwrite all
  converge). §Unregister-immediately-suppresses-finalization
  assumption with §honest-acknowledgment-of-spec-uncertainty in
  explicit TODO.

- **§JS-standards-WeakRef-end-of-turn-stability invariant**: §method-
  by-method derefing classification (has/get/set/delete deref;
  clearWithoutFinalizing/getSize don't). §getSize-may-lie
  observation. §Atomicity-within-a-turn-via-deref property.

- **§has-must-deref-or-it-lies discipline**: defines `has` via
  `get` to force deref. §Replace-finalizes-old discipline for set.
  §`!isPrimitive(ref)` assert (imports from cycle 142's
  @endo/pass-style).

- **§clearWithoutFinalizing-exempt semantics**: §teardown-bypass
  discipline. *Our semantics are to finalize upon explicit delete,
  set, or gc; clearWithoutFinalizing is exempt*.

- **§TODO-with-issue-link** to endo#1514. §Far-as-the-protective-
  wrapper + §RemotableBrand-typing for cross-process passing.

## Output summary

- **Source slug**: `endo--packages-captp-src-finalize-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability.md`
- **Topics**: captp, hardened-javascript, capability-security
- **Library totals**: 660 sections from 201 source documents
- **Lane rotation**: nominally chat-lane (exhausted); papers-lane
  blocked **50 cycles — milestone**

Cycle 156 closes. Schedule next wake 1500s for cycle 157.
