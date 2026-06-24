---
title: The *Confirm/Is/Assert trio* pattern — every key-shaped check exposes three entry points sharing one internal predicate: `confirmX(val, reject)` (the underlying boolean predicate that consults the optional `Rejector`), `isX(val)` (the *no-diagnostic* form via `confirmX(val, false)`), and `assertX(val)` (the *throw-on-failure* form via `confirmX(val, Fail)`); the §`Rejector` callable parameter that *doubles* as `false` (silent), as `Fail` (throw), or as a custom rejecting hook (test-collector); the §`hideAndHardenFunction` discipline applied to all exported is/assert functions so the function names don't leak through `.name`; the *Atom and Scalar keys* surface (`confirmScalarKey` accepts any atom or remotable, rejects copy-tagged passables); the §`keyMemo` WeakSet that caches positive judgements for non-atom keys (atoms are handled by an early return and *cannot* inhabit a WeakSet); the explicit *don't memoize negatives* discipline (so re-trying with `Fail` produces a diagnostic instead of a silent cache hit); the §`confirmKeyInternal` recursion-on-passStyle that dispatches across `remotable`/`copyRecord`/`copyArray`/`tagged` and rejects `error`/`promise` with named diagnostic; the §*unexpected passStyle throws* discipline (vs unexpected-tag being just non-key) which preserves the *unexpected-state-is-bug* trichotomy
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--abstract.md)
- [Body](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--body.md)
- [Connection to the wider library](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--see-also.md)
- [Common confusions](endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion--common-confusions.md)
