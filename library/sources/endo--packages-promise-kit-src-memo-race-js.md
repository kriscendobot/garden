---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/promise-kit/src/memo-race.js
source_line_range: 1-170
file_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
file_commit_date: 2025-10-09
file_commit_author: Kris Kowal
comment_subject: memoRace with WeakMap deferred-sets and finally-cleanup vs native Promise.race memory leak
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-fifth comment-fragment ingest (cycle 152). 170-line
  @endo/promise-kit *memory-safe-race* primitive. **First
  @endo/promise-kit source file ingested** (the cluster
  previously had only the package README at
  `endo--pkg-promise-kit-readme.md`).

  Authored by Brian Kim ([nodejs/node#17469 comment](https://
  github.com/nodejs/node/issues/17469#issuecomment-685216777),
  2017); dedicated to public domain via the Unlicense (full
  text in file header). Latest touch 2025-10-09 by Kris Kowal
  in cycle 108's coordinated-update commit `e56bf00f` (the
  @endo/harden migration).

  §Load-bearing-bug: §native-Promise.race-memory-leak. When
  `Promise.race(P1, P2, P3, ...)` runs and P1 settles but P2/
  P3/... never settle, the attached then-handlers retain
  references to the race-result-promise. Result: result
  pinned for the lifetime of the longest-lived input.
  §long-lived-promise-pins-races problem.

  Single most structurally interesting move: §WeakMap-shared-
  deferred-sets architecture. `knownPromises = new WeakMap()`
  maps each value → `PromiseMemoRecord`. Records have two
  shapes: `{ settled: false, deferreds: Set<Deferred> }` for
  pending; `{ settled: true, deferreds: undefined }` (frozen)
  for terminal. §shared-record-across-races: if same value
  appears in multiple races, they share *one* memo record.
  §one-then-per-value-lifetime invariant — `.then()` called
  *once* per value, gated by `if (!record)`. Subsequent races
  register deferreds in existing Set. §amortize-one-then-
  across-many-races optimization.

  §when-the-value-settles broadcast: `Promise.resolve(value)
  .then` fires once; `markSettled(record)` returns *the
  entire Set of waiting deferreds*; handler iterates and
  notifies. §broadcast-pattern-via-shared-set.

  §markSettled atomic-transition discipline: (1) read
  deferreds Set; (2) replace with undefined + settled: true;
  (3) Object.freeze the record; (4) return captured Set.
  §freeze-after-transition makes terminal record immutable.
  §state-machine-with-frozen-terminal-state idiom. §idempotent-
  markSettled property — second call returns empty Set.

  §primitive-fake-settled-record idiom: primitives can't be
  WeakMap keys, so return harden({ settled: true }) signaling
  "settled". Caller's `Promise.resolve(value).then(...)`
  resolves immediately for primitives. §primitive-bypass-via-
  fake-record. §harden-the-fake-record matches §frozen-after-
  transition discipline.

  §TODO marker at top: *Consolidate with `isPrimitive` that's
  currently in `@endo/pass-style`. Layering constraints make
  this tricky*. §honest-duplication acknowledgment + §layering-
  constraints-block-DRY observation (@endo/promise-kit sits
  below @endo/pass-style; importing creates cycle). Cycle
  142's passStyle-helpers.js also duplicates isPrimitive
  (with different §safer-but-slower-on-XS trade-off).

  §Finally-cleanup the memory-leak fix: `result.finally(() =>
  { for value of cachedValues: getMemoRecord(value).deferreds
  ?.delete(deferred) })`. After result settles, deferred
  removed from every still-pending input's Set; *no* path
  from pending input holds result promise. §the-deferred-no-
  longer-holds-the-result-promise. §finally-vs-then-for-
  cleanup choice — `.finally` runs after both resolve and
  reject paths without affecting chain value; makes cleanup
  intent visible.

  §cachedValues §iterable-might-not-be-rerunnable defense:
  generators / one-shot iterables would exhaust on first
  for-loop; finally would see empty iterable. §single-pass-
  with-cached-array idiom.

  §`this`-as-PromiseConstructor §subclassable-design
  discipline matches standard ECMAScript Promise.* static
  methods; §interop-with-promise-subclasses property.

  §named-function-via-object-destructure idiom: `const {
  race } = { race(values) { ... } }`. Method-syntax makes
  function non-constructable and prototype-less. §don't-let-
  callers-`new`-this-function discipline. §`export { race as
  memoRace }` rename for §api-name-vs-impl-name asymmetry.

  Position in @endo/promise-kit: one of four src files (is-
  promise.js / memo-race.js / promise-executor-kit.js /
  types.js). The *only* one with substantial structural
  cleverness. §related-but-distinct from cycle 66's handled-
  promise.js — HandledPromise is eventual-send substrate;
  memoRace is memory hygiene.

  Cycle 152 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 46+ consecutive cycles. Pivoted to
  comments-lane.
---

> Abstract: `memo-race.js` (170 lines) is the @endo/promise-
> kit *memory-safe-race* primitive. Authored by Brian Kim
> (public-domain Unlicense, 2017). Last-touched 2025-10-09 by
> Kris Kowal in cycle 108's coordinated-update commit.
>
> **First @endo/promise-kit source file ingested.**
>
> §Load-bearing-bug: §native-Promise.race-memory-leak —
> attached then-handlers on never-settling inputs retain
> references to the race-result, pinning it.
>
> **Single most structurally interesting move**: §WeakMap-
> shared-deferred-sets. `knownPromises = new WeakMap<value,
> PromiseMemoRecord>`. §one-then-per-value-lifetime invariant
> + §shared-record-across-races + §amortize-one-then-across-
> many-races optimization.
>
> §markSettled §atomic-transition: read deferreds → replace
> with undefined+settled → freeze → return Set. §state-
> machine-with-frozen-terminal-state. §idempotent property.
>
> §primitive-fake-settled-record idiom: primitives can't key
> WeakMap; return harden({settled: true}) signaling settled.
> Caller's `Promise.resolve(value).then` resolves immediately.
>
> §Finally-cleanup the memory-leak fix: after race settles,
> remove deferred from every still-pending input's Set.
> §the-deferred-no-longer-holds-the-result-promise.
>
> §cachedValues defends against one-shot iterables.
>
> §`this`-as-PromiseConstructor for §subclassable-design.
>
> §named-function-via-object-destructure idiom for §method-
> syntax-non-constructable + §named-function property.
>
> §TODO acknowledges duplicated `isPrimitive` with §layering-
> constraints-block-DRY observation (@endo/promise-kit sits
> below @endo/pass-style).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak](../sections/endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak.md) | eventual-send, hardened-javascript, async-flow | current |

Tight 170-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `e56bf00f289ff8484094b785b11636b8bc71d87e`) via the local
  bare-clone.
- Authored by Brian Kim (nodejs/node#17469 comment, 2017),
  public domain via the Unlicense.
- Last substantive touch 2025-10-09 by Kris Kowal in commit
  `e56bf00f` ("feat: Adopt @endo/harden"). Same coordinated-
  update commit as cycles 108 + 110 + 115 + 118 + 123 + 125 +
  132 + 134 + 136 + 138 + 140 + 144 + 148 + 150 + 152.
- Prior substantive touches: Mark S. Miller 2025-06-23
  (faster-isObject refactor), Turadg Aleahmad 2024-08-19 /
  2022-09-30 (TypeScript), Mark S. Miller 2022-07-27
  (more-hardens).
- **Thirty-fifth comment-fragment ingest.** **First
  @endo/promise-kit source file ingested.**
- Cycle 152 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane blocked **46+ consecutive cycles**. Cycle 152
  pivoted to comments-lane.
- One cohesion-honest section.
