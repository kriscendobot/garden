---
title: Abstract
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
source_lines: "1-103, 483-544 (Atom/Scalar entry + Keys with memoization + the late-file confirmKeyInternal recursion)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Thirteenth comment-fragment ingest. Turadg Aleahmad-authored
  Keys-foundation surface of @endo/patterns. The file defines the
  *Confirm/Is/Assert trio* pattern that every key-shaped check
  follows: one underlying `confirmX(val, reject)` boolean predicate
  with an optional Rejector that doubles as `false` (silent boolean
  return) or `Fail` (throw with diagnostic). Three structural ideas:
  (1) the §Rejector-as-dual-mode parameter — the same internal
  function services *isX* (silent) and *assertX* (throw) without
  duplication; (2) the §`keyMemo` WeakSet with the *don't memoize
  negatives* discipline — caching positives speeds up repeated key
  checks; caching negatives would silence the diagnostic on a
  later `assertX` retry; (3) the §`hideAndHardenFunction` discipline
  applied to all is/assert exports so the function name doesn't
  leak as a privileged identifier through `.name`. The §recursion
  in `confirmKeyInternal` dispatches on passStyle with explicit
  `error`/`promise` rejection paths and an *unexpected passStyle
  throws* discipline that preserves the *unexpected-state-is-bug*
  trichotomy. Pairs structurally with the §cycle 84 rankOrder.js
  ingest (Mark Miller-authored marshal sister surface) and the
  §cycle 87 pass-style/error.js ingest (the underlying passStyle
  validation that this module's `passStyleOf` calls).
parent: endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion
---

The §file opens (lines 1-19) by importing `harden`, `Fail`+`q`+`hideAndHardenFunction` from `@endo/errors`, `Far`+`getTag`+`makeTagged`+`passStyleOf`+`isAtom` from `@endo/pass-style`, `compareAntiRank`+`makeFullOrderComparatorKit`+`sortByRank` from `@endo/marshal`, and `confirmElements`+`makeSetOfElements` from sibling `./copySet.js` / `confirmBagEntries`+`makeBagOfEntries` from `./copyBag.js`. The §opening JSDoc imports the canonical types `Rejector`/`Passable`/`Atom`/`CopyBag`/`CopyMap`/`CopySet`/`Key`/`ScalarKey`. The §Atom and Scalar keys section (lines 21-53) defines the *Confirm/Is/Assert trio* pattern that every key-shaped check in the module follows: `confirmScalarKey(val, reject)` is the underlying boolean predicate accepting any `Rejector`-typed value (a callable, `false`, or `Fail`); `isScalarKey(val) = confirmScalarKey(val, false)` is the silent boolean form; `assertScalarKey(val) = confirmScalarKey(val, Fail)` is the throw-on-failure form. All three are hardened, but `isX` and `assertX` are additionally wrapped via `hideAndHardenFunction` which removes the function's `.name` so it doesn't leak as a privileged identifier. The §Keys section (lines 55-103) defines the same trio for the general `Key` notion, with `keyMemo` WeakSet caching positive judgements for non-atom keys (atoms get the early-return path in `confirmKey` and *cannot* inhabit a WeakSet because they aren't reference-typed). The §`confirmKey` body has the explicit *don't cache the undefined cases, so that if it is tried again with `Fail` it'll throw a diagnostic again* discipline, plus the symmetric *we must not memoize a negative judgement, so that if it is tried again with `Fail`, it will still produce a useful diagnostic*. The §`confirmKeyInternal` (lines 483-544) is the recursion-on-passStyle dispatch that handles each passStyle: `remotable` → true (ScalarKey corner case); `copyRecord` → all values must be keys; `copyArray` → all elements must be keys; `tagged` → switch on tag (`copySet`/`copyBag`/`copyMap` recursively-check); `error`/`promise` → reject with named diagnostic; *default → throw* (unexpected passStyle is *always* an error, vs unexpected tag which is *just non-key*).
