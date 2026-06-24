---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate; this module is part of @endo/patterns.
- [[patterns]] (topic) — the @endo/patterns key/CopyTagged surface.
- `endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms` — the next section: per-collection trio definitions, the makeCopyBagFromElements adjacent-equality counting algorithm, the makeCopyMap reverse-rank-sort with TODO, the Far iterator for getCopyMapEntries.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — the source of the `passStyle` discriminator dispatched on here.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; this module's `error` case is the gate that uses pass-style's error coercion.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — the in-memory rank-order regime; consumes Keys as comparator inputs.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; uses Keys for keyed-store byte encoding.
- `endo--pkg-patterns-readme--*` — the patterns package README; the high-level surface this module's foundation.
