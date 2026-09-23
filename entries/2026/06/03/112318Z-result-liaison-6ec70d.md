---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--6ec70d
ts: 2026-06-03T11:23:18Z
ref_id: 6ec70d
---

# Cycle 152 result — promise-kit/src/memo-race.js (thirty-fifth comment-fragment ingest; first @endo/promise-kit source file)

Cycle 152 of the librarian arc. Nominally chat-lane (exhausted at
20/20); papers-lane blocked **46+ consecutive cycles**. Pivoted to
comments-lane.

## Source

`endo/packages/promise-kit/src/memo-race.js` (170 lines). Authored
by Brian Kim ([nodejs/node#17469 comment](https://github.com/nodejs/node/issues/17469#issuecomment-685216777), 2017); dedicated to
public domain via the **Unlicense**. Last touched 2025-10-09 by Kris
Kowal in cycle 108's coordinated-update commit `e56bf00f` (@endo/
harden migration).

**First @endo/promise-kit source file ingested** (the cluster
previously had only the package README at
`endo--pkg-promise-kit-readme.md`).

## Structural moves captured

- **§Load-bearing-bug**: §native-Promise.race-memory-leak — when
  one input settles but others never do, the engine's then-handlers
  on the never-settling inputs retain references to the race-result-
  promise, pinning it for the lifetime of the longest-lived input.

- **Single most structurally interesting move**: §WeakMap-shared-
  deferred-sets architecture. `knownPromises = new WeakMap<value,
  PromiseMemoRecord>` lets multiple races on the same value share
  *one* memo record. §one-then-per-value-lifetime invariant +
  §amortize-one-then-across-many-races + §broadcast-pattern-via-
  shared-set.

- **§markSettled atomic-transition**: read deferreds → replace with
  undefined+settled → freeze → return Set. §state-machine-with-
  frozen-terminal-state idiom. §idempotent property.

- **§primitive-fake-settled-record idiom**: primitives can't be
  WeakMap keys; return `harden({ settled: true })` signaling
  settled. Caller's `Promise.resolve(value).then` resolves
  immediately.

- **§TODO at top**: *Consolidate with `isPrimitive` that's currently
  in `@endo/pass-style`. Layering constraints make this tricky*.
  §honest-duplication + §layering-constraints-block-DRY observation
  (@endo/promise-kit sits below @endo/pass-style).

- **§Finally-cleanup the memory-leak fix**: after race settles,
  deferred removed from every still-pending input's Set → *no* path
  from pending input holds result promise. §finally-vs-then-for-
  cleanup makes intent visible.

- **§cachedValues defends §iterable-might-not-be-rerunnable**:
  generators / one-shot iterables would exhaust on first for-loop;
  finally would see empty iterable.

- **§`this`-as-PromiseConstructor §subclassable-design** matches
  standard ECMAScript Promise.* static methods.

- **§named-function-via-object-destructure idiom**: `const { race }
  = { race(values) { ... } }`. §Method-syntax-non-constructable +
  §named-function property.

## Output summary

- **Source slug**: `endo--packages-promise-kit-src-memo-race-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak.md`
- **Topics**: eventual-send, hardened-javascript, async-flow
- **Library totals**: 656 sections from 197 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 46+ consecutive cycles); pivoted to comments-lane

## Cluster note

Coordinated-update commit `e56bf00f` cluster grows to 15 files:
cycles 108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 +
140 + 144 + 148 + 150 + 152. This is the @endo/harden migration's
canonical-update trail — every file Kris Kowal touched in commit
`e56bf00f` (2025-10-09) carries the same migration signature, making
the cluster traceable as a single coordinated change.

Cycle 152 closes. Schedule next wake 1500s for cycle 153.
