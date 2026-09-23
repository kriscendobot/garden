---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 173. Chat-lane after cycle 172's designs-lane.
  §Endo-source-comment-fragment genre. **Sibling-to-cycle-
  152's-memo-race.js** (both in @endo/promise-kit) and
  §used-by-cycle-171's-stream-substrate.

  55-line file. Exports a single function:
  `makeReleasingExecutorKit`. **§Fifteenth file in the
  e56bf00f coordinated-update cluster** (cycles 108/110/
  115/118/123/125/132/134/138/140/144/167/169/171/173).

  **Single most structurally interesting move**: §three-
  state-internal-reference-lifecycle — `internalResolve`
  and `internalReject` traverse `undefined` (initial) →
  `function` (executor captured) → `null` (settled,
  references released).

  §Reference-release-on-settle discipline: §captured-
  executor-refs-cleared-after-settlement so §the-promise-
  can-be-GC'd-after-settlement even if the kit object is
  retained.

  §Three-states-encoded-as-three-JS-values: undefined-vs-
  null-meaningful-distinction. §undefined ≠ null. §The-
  falsy-check (`if (internalResolve)`) distinguishes state
  1 from states 0+2.

  §Executor-is-single-use (assert-on-double-invocation).
  §Resolve/reject-are-fire-once with §symmetric-release
  (resolve releases *both* internalResolve and
  internalReject; same on reject side).

  §Why-not-just-WeakRef: §timing-guarantees. WeakRef gives
  §release-when-GC-runs (arbitrarily later); this gives
  §immediate-release. §Cycle-156-finalize.js is the
  WeakValueMap sibling; that uses §weak-when-no-strong-
  reference; this uses §explicit-release-on-known-event.

  §Used-by-cycle-171-stream-substrate: makeStream uses
  makePromiseKit per cons-cell; §reference-release-on-
  settle is §what-makes-the-stream-queue-GC-friendly.
  §Cycle-171's-promise-as-pointer pattern §depends-on-
  this-hygiene.

  §The-makePromiseKit-factory-vs-this-kit distinction:
  this file is the §executor-half (resolve/reject +
  executor function, no promise); the caller passes the
  executor to a §promise-constructor-of-their-choice.
  §Decomposed-for-composition (HandledPromise, future
  variants, etc.).

  §Naming-discipline-§releasing-as-qualifier:
  `makeReleasingExecutorKit` names the §release-discipline
  in the function name. §If-your-function-does-cleanup-
  name-the-cleanup-in-the-function-name. Sibling to
  cycle 118 *defendPrototype*, cycle 90 *trackTurns*,
  cycle 138 *safe-promise*. §Action-verb-or-adjective-in-
  function-name @endo discipline.

  §The-pattern-named: §reference-release-on-settle micro-
  pattern with three components: §captured-state-as-
  mutable-let, §three-distinct-states distinguishable by
  JS value shape, §symmetric-release-on-first-firing.
  §Applicable to other one-shot factories (watchdog-timers,
  one-shot-event-emitters, single-use-cleanup-handlers).

  §assert-without-condition-is-just-Fail: relies on SES's
  assert default message; §assertion-is-genuine-invariant-
  check not §user-facing-error. §Distinct-from-Fail-X-
  template (cycles 87/96/98).

  §Comparison-with-cycle-152-memo-race.js: same package,
  same author, same §promise-lifecycle theme. Cycle 152 =
  §racing-with-cleanup; this = §reference-release-on-
  settle. §Both-named-cleanup-disciplines.

  §Gap-revealing-comparison with cycles 152/171/156/66/
  146/90.

  §Synthesis-target: slot machine's promise-based callbacks
  need this hygiene. §Any-factory-that-captures-one-shot-
  callbacks-benefits-from-this-pattern.

  §Tier-1 vocabulary borrowing: §three-state-internal-
  reference-lifecycle + §reference-release-on-settle +
  §releasing-as-qualifier-in-function-name + §symmetric-
  release-of-paired-references + §undefined-vs-null-
  meaningful-distinction.

  §Small-file-but-load-bearing-knowledge — sibling to
  cycle 167 where, cycle 169 atomics, cycle 171 stream.
  §The-substrate-files-are-often-the-shortest.

  Cycle 173 was nominally chat-lane (after cycle 172's
  designs-lane). Papers-lane blocked 67+ consecutive
  cycles.
---

> Abstract: `packages/promise-kit/src/promise-executor-
> kit.js` (55 lines) exports a single function:
> `makeReleasingExecutorKit`. The single most structurally
> interesting move is the **§three-state-internal-
> reference-lifecycle** (undefined → function → null) that
> implements §reference-release-on-settle.
>
> **Cycle 173 — chat-lane** after cycle 172's designs-lane.
> §Endo-source-comment-fragment genre.
>
> **§Sibling-to-cycle-152's-memo-race.js** (same package,
> same author, both §promise-lifecycle). **§Used-by-cycle-
> 171's-stream-substrate** (makePromiseKit per cons-cell).
>
> §Fifteenth file in the e56bf00f coordinated-update
> cluster.
>
> §Why-not-just-WeakRef: §timing-guarantees. WeakRef =
> §release-when-GC-runs; this = §immediate-release.
> Cycle 156 finalize.js is the WeakValueMap sibling.
>
> §The-makePromiseKit-factory-vs-this-kit: this file is
> the §executor-half only; the caller passes the executor
> to a promise-constructor-of-their-choice. §Decomposed-
> for-composition.
>
> §Naming-discipline-§releasing-as-qualifier: the function
> name encodes the §release-discipline. §If-your-function-
> does-cleanup-name-the-cleanup-in-the-function-name.
>
> §The-pattern-named: §reference-release-on-settle micro-
> pattern (§captured-state-as-mutable-let + §three-
> distinct-states + §symmetric-release-on-first-firing).
>
> §Synthesis-target: §slot-machine-promise-callbacks
> benefit from this hygiene. §Any-factory-that-captures-
> one-shot-callbacks-benefits.
>
> §Tier-1 borrowing: §three-state-internal-reference-
> lifecycle, §reference-release-on-settle, §releasing-
> as-qualifier-in-function-name, §symmetric-release-of-
> paired-references, §undefined-vs-null-meaningful-
> distinction.
>
> §Small-file-but-load-bearing-knowledge — sibling to
> cycle 167/169/171's small-files-with-large-knowledge-
> density observations.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits](../sections/endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits.md) | patterns, async-flow | current |

One cohesion-honest section. §The-reference-release-on-
settle-pattern-is-the-spine.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `e56bf00f`).
- Author: Kris Kowal (prompted).
- **Fifteenth file in the e56bf00f coordinated-update
  cluster** (cycles 108/110/115/118/123/125/132/134/138/
  140/144/167/169/171/173).
- Cycle 173 was nominally **chat-lane** (after cycle 172's
  designs-lane). Papers-lane has been blocked for **67+
  consecutive cycles**.
- One cohesion-honest section.
