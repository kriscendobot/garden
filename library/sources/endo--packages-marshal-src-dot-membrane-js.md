---
source: packages/marshal/src/dot-membrane.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-24
source_authors: [Turadg Aleahmad]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-first comment-fragment ingest. 164-line file by Turadg
  Aleahmad in commit `ec42cb7b` (2026-04-24) — newer than the
  `e56bf00f` and `c05c9a88` clusters.

  Single export `makeDotMembraneKit(target) → {proxy, revoke}`.
  This is the *full membrane* implementation built on top of
  marshal — uses serialize/unserialize as the *implementation
  mechanism* for the membrane.

  Single most structurally interesting move: the §dot-membrane-
  via-marshal idiom — *the same machinery that sends capabilities
  over a network suffices to wrap capabilities in a local
  revocable proxy*. The §serialize-and-then-unserialize-in-the-
  other-direction pattern: any value `mine` becomes `yours`
  via `mySerialize` + `yourUnserialize` (the mirror converter's
  unserialize).

  §Mirror-converter recursive setup: `makeConverter` takes an
  optional `mirrorConverter`. The outer call passes nothing,
  recurses with `makeConverter(converter)` passing itself as
  the mirror's mirror. Mirror destructured under mirror-side
  names: `mineToYours` → `yoursToMine`; `convertMineToYours` →
  `convertYoursToMine`; `myUnserialize` → `yourUnserialize`;
  `pass` → `passBack`. The §every-mirror-name-is-the-other-
  direction discipline.

  §Pass / passBack symmetric pair: `pass = mine =>
  yourUnserialize(mySerialize(mine))`; `passBack` is the
  mirror's `pass` going the other way. Inside the §remotable
  case: args cross *back* (yours → mine via passBack); result
  and exceptions cross *forward* (mine → yours via pass).

  §Revocation via undefining the mineToYours WeakMap. Setting
  `mineToYours = undefined` makes the next call to
  `convertMineToYours` throw `ReferenceError(Revoked:
  ${optReasonString})`. §Two-step-revocation: `myRevoke` calls
  `optInnerRevoke` (the mirror's revoke), so single `revoke()`
  propagates to both sides.

  §`mineIf-vs-mine` GC-friendliness comment: *We use mineIf
  rather than mine so that mine is not accessible after
  revocation. This gives the correct error behavior, but may
  not actually enable mine to be gc'ed, depending on the JS
  engine*. §honest-not-yet-perfect — TODO: *Could rewrite to
  keep scopes more separate, so post-revoke gc works more often*.

  §Two-level metaReason error handling for promises: three-level
  fallback chain catches non-passable myFulfillment/myReason →
  catches non-passable metaReason → finally rejects with raw
  metaMetaReason. §each-level-might-throw discipline. §TODO note:
  *verify that metaReason must be my-side-safe, or rather, that
  the passing of it is your-side-safe*.

  §Far-functions-have-no-static-methods assumption: branches
  remotable case by typeof mine — function form uses
  myMethodToYours() (no optVerb); object form uses
  getRemotableMethodNames + per-method translation table. §NOTE:
  *Assumes that a far function has no "static" methods. This is
  the current marshal design, but revisit this if we change our
  minds*.

  §Temporal-dead-zone hack: `convertSlotToVal` is created as a
  wrapper around `convertYoursToMine` *before*
  `convertYoursToMine` is destructured. JS arrow-function-
  captures-the-binding-not-the-value lets the wrapper *reference*
  the binding before it exists.

  §makeDotMembraneKit one-line export wraps `makeConverter` to
  return `{proxy, revoke}` — user gets a wrapped target and a
  revocation method. Calling `revoke()` disables the membrane
  permanently.

  §How this file integrates the marshal + pass-style + eventual-
  send substrate: it's the *crown jewel* of @endo/marshal —
  marshal's serialization, paired with itself, becomes a full
  membrane with revocation. Direct integration of cycles
  67-69 (marshal) + 71/87/134/136 (pass-style) + 66/130/132
  (eventual-send).

  Cycle 144 was nominally chat-lane (cycle 143 was designs).
  Chat-lane exhausted at 20/20. Cycle 144 pivoted to comments-
  lane. Papers-lane has been blocked for 38+ consecutive cycles.
  First @endo/marshal source file ingested since cycle 84/85's
  rankOrder.js. Author Turadg Aleahmad — same as cycle 120's
  keycollection-operators.js, cycle 127's getGuardPayloads.js,
  and cycle 142's passStyle-helpers.js (the four Turadg-authored
  files this librarian work has ingested).
---

> Abstract: `packages/marshal/src/dot-membrane.js` (164 lines,
> Turadg Aleahmad, commit `ec42cb7b`) is the *full membrane*
> implementation that exports `makeDotMembraneKit(target) →
> {proxy, revoke}`. The structural surprise: the membrane is
> built by *running marshal twice* (once each direction).
> Marshal's serialize / unserialize pair *is* the
> membrane-crossing mechanism.
>
> **The single most structurally interesting move**: the
> §dot-membrane-via-marshal idiom — *the same machinery that
> sends capabilities over a network suffices to wrap
> capabilities in a local revocable proxy*.
>
> §Mirror-converter recursive setup: two converters reference
> each other via destructured-under-mirror-side-names bindings
> (mineToYours → yoursToMine, etc.). The §every-mirror-name-is-
> the-other-direction discipline.
>
> §Revocation via undefining the mineToYours WeakMap; §two-step-
> revocation propagates to the mirror. §mineIf-vs-mine GC-
> friendliness comment: *correct error behavior but may not
> actually enable mine to be gc'ed*.
>
> §Two-level metaReason error handling for promises (three-
> level fallback chain). §Far-functions-have-no-static-methods
> assumption branches the remotable case. §Temporal-dead-zone
> hack via arrow-function-captures-the-binding-not-the-value.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap](../sections/endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap.md) | marshal, capability-security | current |

Tight 164-line file. The §makeConverter + §mirror-converter +
§pass-passBack-pair + §revocation form one coherent membrane
mechanism. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@ec42cb7b` (`master`) via
  the local bare-clone.
- Last touched 2026-04-24 by Turadg Aleahmad in commit
  `ec42cb7b`.
- Verified file existence and structure via the local bare-clone:
  164 lines + 1 export (makeDotMembraneKit) + 1 private factory
  (makeConverter).
- **Thirty-first comment-fragment ingest.** First @endo/marshal
  source file ingested since cycle 84/85's rankOrder.js sections.
  Pairs with cycles 67-69 (marshal/encodePassable/encodeToSmall-
  caps) + 71/87/134/136/138/140/142 (pass-style cluster) +
  66/130/132 (eventual-send) to show the *crown jewel* of how
  these substrates compose.
- Cycle 144 was nominally **chat-lane** (cycle 143 was designs).
  Chat-lane is exhausted (20/20). Papers-lane has been blocked
  for **38+ consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 144 pivoted to comments-lane.
- One cohesion-honest section.
