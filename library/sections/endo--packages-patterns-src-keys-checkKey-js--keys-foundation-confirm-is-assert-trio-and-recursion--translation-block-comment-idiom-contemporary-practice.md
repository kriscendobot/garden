---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Confirm/Is/Assert trio` | The *one-predicate-three-entry-points* discipline; share one internal predicate across silent/throw/custom-rejector modes. |
| `Rejector` parameter | The *callable-or-false* dual-mode parameter; short-circuit via `reject && reject\`diagnostic\``. |
| `hideAndHardenFunction(isX)` | The *public-function-name-hiding* discipline; prevent `.name` leak as authority discriminator. |
| `Non-atom Keys are memoized` | The *WeakSet-cached-positive-judgements* idiom; speeds up repeated checks. |
| `Atom keys ... cannot inhabit a WeakSet` | The *primitive-types-need-early-return* discipline; WeakSets reject non-objects. |
| `Don't cache the undefined cases` / `must not memoize a negative judgement` | The *positives-only-memoization* discipline; preserves diagnostic on later `Fail` retry. |
| `Unexpected tags are just non-keys, but an unexpected passStyle is always an error.` | The *expected-vs-unexpected-state* trichotomy; unexpected-state throws regardless of reject parameter. |
| `For a copyMap to be a key, all its keys and values must be keys` | The *structural-validity-vs-key-eligibility* layered requirement. |
