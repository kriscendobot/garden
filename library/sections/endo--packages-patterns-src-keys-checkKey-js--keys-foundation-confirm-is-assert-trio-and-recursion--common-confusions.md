---
title: Common confusions
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

- **"`confirmX` should just throw on failure — why the Rejector parameter?"** The Rejector parameter lets *one* predicate service multiple modes. Without it, you'd need separate functions for silent-boolean, throwing-assert, and test-collecting modes. The single-internal-predicate discipline keeps the logic in one place.
- **"`isAtom` early return in `confirmKey` is redundant — `confirmKeyInternal` would handle atoms too."** It would *not* — `confirmKeyInternal` calls `passStyleOf(val)` which returns the pass-style; atoms have pass-styles like `'string'`, `'number'`, `'bigint'`, `'boolean'`, `'undefined'`, `'null'`, `'symbol'`, none of which appear in the `confirmKeyInternal` switch. The early-return is the *correct* fast path; without it, atoms would hit the *unexpected-passStyle throws* default and crash.
- **"`hideAndHardenFunction` is just a perf optimization."** It is *not* — it removes the function's `.name`. The motivation is *capability discipline*: a function's name could be used as an authority discriminator (a code pattern that branches on `fn.name`); the discipline prevents this leak.
- **"`keyMemo` will leak memory across compartments."** It's a WeakSet — entries are GC'd when the underlying value is unreachable. The §memo is per-compartment-load and tracks only values still referenced elsewhere; no leak.
- **"The `reject && reject\`...\`` idiom prevents constructing the diagnostic in silent mode."** It does — the tagged template `reject\`...\`` is *not evaluated* when `reject` is `false` because `&&` short-circuits. The diagnostic-template construction is the §expensive part (interpolating `q(passStyle)` + `val`); the short-circuit avoids it.
- **"Don't memoize negatives means slow re-runs of failing checks."** Yes — and *intentionally so*. Failing checks are the diagnostic-emission path; making them slow but correct is the right trade-off. Positive checks (the hot path in steady state) are fast.
- **"`confirmKeyInternal` recursion could blow the stack on deeply-nested values."** It could, but pass-style values typically have bounded depth. The same risk applies to `passStyleOf` itself. The discipline accepts the bounded-depth assumption.
- **"`unexpected passStyle throws` means a maintainer adding a new passStyle will see this module crash."** Exactly — that's the *discovery* mechanism. The crash names *unexpected passStyle X: <val>* which tells the maintainer *which* passStyle is missing handling. Silent-skip would mask the gap.
- **"The `copyMap` case checks `everyCopyMapValue(val, checkIt)` — that's redundant with `confirmCopyMap`."** It is *not*. `confirmCopyMap` validates that the copyMap's *keys* are keys (a copyMap structural requirement). `everyCopyMapValue` additionally checks that the *values* are keys — required for the copyMap *itself* to be a Key (eligible for use as a key in another collection). The two requirements are *layered* (structural validity + value-eligibility for Key).
