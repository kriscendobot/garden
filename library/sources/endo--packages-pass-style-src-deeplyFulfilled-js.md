---
source: packages/pass-style/src/deeplyFulfilled.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-ninth comment-fragment ingest. 153-line file by Kris
  Kowal in commit `e56bf00f` — same coordinated-update cluster
  as cycles 108/110/115/118/123/125/132/134/136/138. Single
  export `deeplyFulfilled(val)` — *deep Promise.all specialized
  for Passables*: recursively replaces every promise in a
  Passable's pass-by-copy structure with its fulfillment.

  §Three failure modes (per JSDoc): reject (any rejected promise
  propagates); never-settle (no timeout; waits forever); not-
  Passable (val itself or any transitive fulfillment that isn't
  Passable → reject).

  Single most structurally interesting move: §non-hardened-
  promise tolerance at top level. The opening branches handle
  isAtom + isPromise *before* the passStyleOf switch. The §inline
  comment: *if `val` is a promise but not a passable promise,
  for example, because it is not hardened, isPromise will return
  true, which is ok here because we unwrap it to its settlement
  and dispense with the promise*. The §exemption-is-top-level-
  only discipline — non-hardened promises nested inside a
  Passable would fail (because their containing
  copyRecord/copyArray's passStyleOf check would throw). The
  exception is narrow and intentional.

  §Seven-case switch on passStyle:
    copyRecord — recursively deeplyFulfilled each value;
                 fromEntries + harden
    copyArray  — recursively each element; Promise.all + harden
    byteArray  — pass through unchanged (almost dead code; isAtom
                 already handles)
    tagged     — recursively the payload; makeTagged(tag, payload)
    remotable  — pass through unchanged (leaf)
    error      — pass through unchanged (leaf)
    promise    — E.when(prom, nonp => deeplyFulfilled(nonp))

  Three leaf-styles pass through (byteArray/remotable/error);
  two composite-styles recurse (copyRecord/copyArray); one
  wrapper-style recurses into payload (tagged); one
  special-style awaits and recurses (promise).

  §Key-status-deferred-to-patterns observation: *if val or its
  parts are non-key Passables only because they contain
  promises, the deeply fulfilled forms of val or its parts may
  be keys. This is for the higher "@endo/patterns" level of
  abstraction to determine, because it defines the Key notion
  in question*. The §layering discipline: this file doesn't know
  about Keys; the result is a Passable, the Key-status is the
  patterns layer's concern.

  §E.when vs await usage: uses E.when(...) to await promises
  rather than plain await. Rationale: await operates on JS
  promises only; E.when operates on JS promises *and* on
  HandledPromises (cycle 66) — including those routed through
  CapTP to remote vats. The §use-E.when-not-await discipline
  lets this work on remote eventual-send promises.

  Five `@ts-expect-error not assignable to type
  'DeeplyAwaited<T>'` markers acknowledge a TypeScript
  limitation; §opening TODO links issue #1257 (*Figure out why
  we need these at-expect-error directives below and fix if
  possible*).

  §Three-types-copied-from-@agoric/internal TODO appears three
  times in the opening JSDoc (Simplify / Callable /
  DeeplyAwaitedObject): *Currently copied from @agoric/internal
  utils.js. TODO Should migrate here and then, if needed,
  reexported there*. The §canonical-home-yet-to-be-resolved
  discipline.

  §The bridge between pass-style and eventual-send: pass-style
  says copyRecords must contain only Passables, promises are not
  Passables, deeply-fulfilled forms are Passables; eventual-
  send says promises route through E() to local-delivery or
  remote-CapTP. deeplyFulfilled resolves the embedded promises
  so the result is fully-Passable for `marshal()`.

  Cycle 140 was nominally chat-lane (cycle 139 was designs).
  Chat-lane exhausted at 20/20. Cycle 140 pivoted to comments-
  lane. Papers-lane has been blocked for 34+ consecutive cycles.
---

> Abstract: `packages/pass-style/src/deeplyFulfilled.js` (153
> lines, Kris Kowal, commit `e56bf00f`) is the *deep Promise.all
> for Passables* primitive. Single export `deeplyFulfilled(val)`
> recursively replaces every promise in a Passable's pass-by-
> copy structure with its fulfillment.
>
> §Three failure modes: reject (propagates); never-settle (no
> timeout); not-Passable (rejects).
>
> **The single most structurally interesting move**: the §non-
> hardened-promise tolerance at top level. `isPromise` is
> checked *before* `passStyleOf` — a non-hardened top-level
> promise is unwrapped to its settlement; non-hardened nested
> promises would fail (because their containing copyRecord's
> passStyleOf throws). §Exemption-is-top-level-only.
>
> §Seven-case switch on passStyle: three leaf-pass-throughs
> (byteArray/remotable/error), two composite-recurses
> (copyRecord/copyArray), one wrapper-recurse (tagged), one
> await-and-recurse (promise).
>
> §Key-status-deferred-to-patterns: this file doesn't know
> about Keys; the @endo/patterns layer above determines whether
> the deeply-fulfilled Passable is a Key.
>
> §Use-E.when-not-await discipline lets this work on remote
> eventual-send (HandledPromise) values in addition to local
> JS promises.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level](../sections/endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level.md) | pass-style, eventual-send | current |

Tight 153-line file. The single function exports the *bridge*
between pass-style's leaf-oriented validation and eventual-send's
promise-routing. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@e56bf00f` (`master`) via
  the local bare-clone.
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`.
  Same coordinated-update commit as cycles 108, 110, 115, 118,
  123, 125, 132, 134, 136, 138.
- Verified file existence and structure via the local bare-clone:
  153 lines + 1 export (deeplyFulfilled) + 3 JSDoc TODOs about
  migrating types from @agoric/internal + 5
  @ts-expect-error markers.
- **Twenty-ninth comment-fragment ingest.** Continues the
  @endo/pass-style cluster (cycles 71 + 87 + 134 + 136 + 138 +
  140).
- Cycle 140 was nominally **chat-lane** (cycle 139 was designs).
  Chat-lane is exhausted (20/20). Papers-lane has been blocked
  for **34+ consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 140 pivoted to comments-lane.
- One cohesion-honest section.
