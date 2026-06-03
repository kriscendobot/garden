---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--291b2a
ts: 2026-06-03T23:03:27Z
ref_id: 291b2a
---

# Cycle 173: endo packages/promise-kit/src/promise-executor-kit.js (reference-release-on-settle micro-pattern)

Cycle 173 — chat-lane after cycle 172's designs-lane.
§Endo-source-comment-fragment genre.

§Sibling-to-cycle-152's-memo-race.js (same package, same
author, both §promise-lifecycle) and §used-by-cycle-171's-
stream-substrate (makePromiseKit per cons-cell). The
§reference-release-on-settle discipline is §what-makes-
the-stream-queue-GC-friendly.

Note: the researcher-gap-tracker message (`224238Z`) was
filed earlier this turn; cycle 173 picked freely (this
small @endo/promise-kit file) and didn't pivot to the
tracked `designs/gateway-package.md`. That's fine —
gateway-package.md will surface when a designs-lane cycle
naturally reaches it.

## Source

`endojs/endo packages/promise-kit/src/promise-executor-
kit.js`. Author Kris Kowal (prompted). 55 lines. File
last-touched in commit `e56bf00f` (**fifteenth file in
the e56bf00f coordinated-update cluster**).

## Sections written (1)

`endo--packages-promise-kit-src-promise-executor-kit-js--
reference-release-on-settle-with-three-state-resolve-
reject-lifecycle-for-GC-friendly-promise-kits.md` (352
lines; commit `2bb3c946`).

**§Cohesion-honest section count**: One. §The-reference-
release-on-settle-pattern-is-the-spine.

## Single most structurally interesting move

**§Three-state-internal-reference-lifecycle**:
`internalResolve` and `internalReject` traverse `undefined`
(initial) → `function` (executor captured) → `null`
(settled, references released).

§undefined-vs-null-meaningful-distinction: state encoded
via JS value shape. §The-falsy-check (`if
(internalResolve)`) distinguishes state 1 from states 0+2
(both falsy but different).

## §The-pattern-named: §reference-release-on-settle

A §micro-pattern with three components:

1. §Captured-state-as-mutable-let (not const).
2. §Three-distinct-states distinguishable by JS value
   shape.
3. §Symmetric-release-on-first-firing (both halves of the
   pair are released, regardless of which side fired).

§Applicable beyond promise kits: watchdog-timers,
one-shot-event-emitters, single-use-cleanup-handlers.

## §Why-not-just-WeakRef

§Timing-guarantees. WeakRef gives §release-when-GC-runs
(arbitrarily later); this gives §immediate-release.

§Cycle-156's-finalize.js (WeakValueMap) is the sibling:
§weak-when-no-strong-reference vs §explicit-release-on-
known-event. §Two-different-promises-about-GC.

## §Used-by-cycle-171-stream-substrate

`packages/stream/index.js` calls `makePromiseKit()` to
create the §functional-async-queue's cons-cells. §If-
promise-kits-didn't-release-internal-refs, the cons-cell
chain would retain each resolve function until the
cons-cell itself was collected. With this discipline, each
settled cons-cell's promise can be GC'd §independently-
of-cons-cell-lifetime. §Cycle-171's-promise-as-pointer
pattern §depends-on-this-hygiene.

## §Naming-discipline-§releasing-as-qualifier

`makeReleasingExecutorKit` names the §release-discipline
in the function name. §If-your-function-does-cleanup-
name-the-cleanup-in-the-function-name.

Sibling pattern: cycle 118 *defendPrototype*, cycle 90
*trackTurns*, cycle 138 *safe-promise*. §Action-verb-or-
adjective-in-function-name @endo discipline.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 152 (memo-race.js) | §Sibling-file-in-same-package; §promise-lifecycle |
| 171 (stream/index.js) | §Consumer-of-makePromiseKit; this is §what-makes-the-stream-queue-GC-friendly |
| 156 (finalize.js) | §WeakValueMap sibling; §weak-vs-explicit-release |
| 66 (handled-promise.js) | §Promise-constructor that this kit's executor could feed |
| 146 (E.js) | §Consumer-of-HandledPromise |

## §Tier-1 vocabulary borrowing candidates

§Three-state-internal-reference-lifecycle, §reference-
release-on-settle, §releasing-as-qualifier-in-function-
name, §symmetric-release-of-paired-references, §undefined-
vs-null-meaningful-distinction.

## §Synthesis-target

§Slot machine library's promise-based callbacks (game-
session-handlers, event-loop-callbacks) need this
hygiene. §Any-factory-that-captures-one-shot-callbacks
benefits from this pattern.

## Files written / edited

- `library/sections/endo--packages-promise-kit-src-
  promise-executor-kit-js--reference-release-on-settle-
  with-three-state-resolve-reject-lifecycle-for-GC-
  friendly-promise-kits.md` (352 lines; commit `2bb3c946`)
- `library/sources/endo--packages-promise-kit-src-
  promise-executor-kit-js.md` (new source page)
- `library/sources/README.md` (cycle-173 row added above
  stream/index.js)
- `library/sections/README.md` (cycle-173 entry; totals
  bumped 677/218 → 678/219)
- `library/topics/patterns.md` (cycle-173 row)
- `library/topics/async-flow.md` (cycle-173 row)
- `library/keywords.md` (49 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

677 / 218 → **678 sections from 219 source documents**.

## Lane rotation note

Cycle 173 was nominally **chat-lane** (after cycle 172's
designs-lane). Papers-lane blocked **67+ consecutive
cycles**.

§Designs/chat-alternation maintained for eight cycles
(166-173). §Steady-rotation-discipline.

## §The §small-files-with-large-knowledge-density family

Recent cycles have built up a §family of small-substrate-
files:
- Cycle 165: platform-specific.md (92 lines)
- Cycle 167: @endo/where/index.js (115 lines)
- Cycle 169: @endo/captp/atomics.js (170 lines)
- Cycle 171: @endo/stream/index.js (247 lines)
- Cycle 173: @endo/promise-kit/src/promise-executor-kit.js
  (55 lines)

§The-substrate-files-are-often-the-shortest. §Reading-the-
shortest-files-tells-you-the-substrate.

## Cycle 173 — done. Schedule cycle 174.
