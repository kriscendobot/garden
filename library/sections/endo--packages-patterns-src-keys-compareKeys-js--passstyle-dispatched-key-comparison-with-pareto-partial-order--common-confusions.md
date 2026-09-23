---
title: Common confusions
source: packages/patterns/src/keys/compareKeys.js
source_repo: endojs/endo
source_branch: master
source_commit: c63b8b709ecb25a32469f5eae1003a719c7f3608
source_date: 2026-03-26
source_authors: [Turadg Aleahmad]
source_lines: "1-265 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Fourteenth comment-fragment ingest. Sister file to cycle 102's
  checkKey.js (same author, same package, same shared idioms).
  Where checkKey.js defines the *Confirm/Is/Assert trio* validation
  pattern, this file defines the *partial-order comparison* surface
  for keys + collections. Four structurally interesting moves:
  (1) the *partial-order vs total-order* distinction — keys form a
  *partial order* (some pairs are incommensurate, signaled by `NaN`)
  unlike rank order which is a *total order* (every pair has a
  defined comparison); (2) the *Pareto-partial-order* algorithm for
  copyRecord comparison — same property set required; element-wise
  comparison must all-go-the-same-direction-or-be-equal else NaN;
  (3) the *ABSENT Symbol sentinel* unused-but-preserved scaffolding
  for the future copyMap-comparison decision, with a TODO that
  *names the cross-reference* (endo PR #1737 review thread); (4) the
  *number NaN special case* — NaN === NaN compares as 0 in this
  module (NaN is equal to itself) but NaN vs any non-NaN number
  returns NaN (incommensurate). Single-section cohesion-honest ingest
  (like cycle 103) — the 264-line file is *one comparison surface*
  with specialized handling per passStyle, plus the five-predicate
  wrapper suite.
parent: endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order
---

- **"`compareKeys` should always return -1, 0, or 1."** It does *not*. Keys form a *partial order*; some pairs are *incommensurate*. The fourth possible return is `NaN`. Callers must check via `Number.isNaN()` or use the five-predicate wrappers which all return false for NaN.
- **"`keyEQ(x, x)` should always be true."** It is, *for valid Keys*. `assertKey` would throw on a non-Key input. But `keyEQ(x, y)` where x and y are valid Keys of different passStyles returns false (because NaN ≠ 0). The reflexive case `keyEQ(x, x)` always returns true.
- **"Two `NaN` numbers compare as 0 — that contradicts IEEE-754."** It does. *Key semantics* deviates from IEEE-754 for NaN-self-equality. The §rationale: Keys must support reflexive equality for use in sets/maps; without it, `NaN` couldn't be a valid set element.
- **"`-0` and `0` should compare as different keys."** They don't. Rank order groups them in the same equivalence class; key order inherits that. `keyEQ(0, -0)` returns true. The §discipline matches `===` (where `0 === -0` is true) more than `Object.is` (where `Object.is(0, -0)` is false).
- **"Two remotables to the same logical entity should compare as equal."** They don't, unless they're `===` identical references. The §discipline: comparison cannot know whether two distinct references point to the same logical entity. Identity is the only signal available.
- **"copyRecord Pareto partial order is unnecessarily strict — `{a:1}` should be smaller than `{a:1, b:2}`."** They are *incommensurate* in this design, not ordered. The §rationale: different property sets are *different shapes*, and shape-vs-shape comparison would require ad-hoc rules. The §discipline keeps the comparison well-defined; if `{a:1}` and `{a:1, b:2}` need ordering, the caller can encode the absent property as a sentinel.
- **"The `_mapCompare` is dead code."** It is *unused but preserved*. The §TODO names the cross-reference to PR #1737 review thread where the CopyMap-comparison semantics are being decided. The scaffolding stays so the future decision can land cleanly.
- **"`Symbol('absent')` is just a private label."** It is *more*: `Symbol(...)` (with constructor) is *guaranteed unique per construction*; `Symbol.for(...)` (with global registry) is *the same symbol across compartments*. The §comment explicitly names this distinction. ABSENT must be unique per module to avoid colliding with any inbound data.
- **"The `assert(!Number.isNaN(left) \|\| !Number.isNaN(right))` in the number branch is defensive."** It is *the discriminator*: the §logic reaches this code only when `compareRank` returned non-zero. NaN-vs-NaN would have returned zero (via rank-equal); so reaching this point with both NaN would be a *rank-order bug*. The assert surfaces it.
- **"The keyLT family being false-for-incommensurate is a bug — caller can't distinguish equal vs incommensurate."** It is *deliberate*. Callers wanting the *not-greater-than-or-equal* semantic should use `!keyGT(x, y)`; callers wanting *strictly-less-than* should use `keyLT(x, y)`. The all-five-false-when-incommensurate behavior preserves the partial-order semantics; callers handle incommensurability by checking `Number.isNaN(compareKeys(x, y))` directly.
