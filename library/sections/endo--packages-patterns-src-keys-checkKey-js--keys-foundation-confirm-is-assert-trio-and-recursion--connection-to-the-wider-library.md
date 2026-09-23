---
title: Connection to the wider library
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

This section is the **canonical *one-predicate-three-public-entry-points* discipline**. Three threads:

1. **The `confirmX` / `isX` / `assertX` trio pattern** — one internal predicate exposes three external entry points (silent boolean / throw-on-failure / Rejector-parameterized). Reusable for any *check-with-optional-diagnostic* surface.

2. **The Rejector-as-dual-mode parameter** — the same callable parameter doubles as `false` (silent) or `Fail` (throw). The `reject && reject\`...\`` short-circuit idiom is the canonical implementation.

3. **The keyMemo with don't-memoize-negatives discipline** — a WeakSet caches positive judgements but never negatives. The §rationale: positives are stable across calls; negatives may want a diagnostic on a later `assertX` retry.

The §`confirmKeyInternal` recursion-on-passStyle structurally complements:

- **`endo--packages-pass-style-src-passStyleOf-js--*`** (cycle 71) — the source of the `passStyle` discriminator this module dispatches on.
- **`endo--packages-marshal-src-rankorder-js--*`** (cycle 84) — the in-memory rank-order regime that consumes Keys as comparators.
- **`endo--packages-marshal-src-encodepassable-js--*`** (cycle 81) — the rank-order-preserving encoder that uses Keys for keyed-store key bytes.
