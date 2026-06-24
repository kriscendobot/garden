---
title: Abstract
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
source_lines: "105-481 (CopySet + CopyBag + CopyMap sections including makeCopyBagFromElements, makeCopyMap, getCopyMapEntries Far iterator, copyMapKeySet shortcut)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  The three-collection extension surface of @endo/patterns/keys.
  Three structural ideas: (1) the §Confirm/Is/Assert trio pattern
  (introduced in the previous section) is *uniformly applied* to
  CopySet, CopyBag, and CopyMap — each gets its own memo WeakSet,
  confirm/is/assert trio, and structural-payload validation; (2) the
  §makeCopyBagFromElements algorithm is a worked example of
  *sort-then-adjacent-counting* (sortByRank + while-equal-advance),
  with explicit *history-dependent state ... does not survive*
  warning for the fullCompare; (3) the §makeCopyMap algorithm uses
  *reverse rank sorting* via compareAntiRank to colocate keys with
  values, including an honest TODO about the *copyMap cover issue
  in patternMatchers.js* that depends on additional validation.
  The §`getCopyMapEntries` returning a `Far(iterable)` exotic
  rather than an array is the *lazy-iteration-with-immutability*
  discipline. The §`copyMapKeySet` is the *internal-form-shortcut*
  — a copyMap's keys are *already* in copySet's internal form, so
  the conversion is a tag-wrap-only operation with no
  re-validation.
parent: endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms
---

The §CopySet section (lines 105-184) defines `confirmCopySet`/`isCopySet`/`assertCopySet`/`getCopySetKeys`/`everyCopySetKey`/`makeCopySet` following the Confirm/Is/Assert trio pattern from the previous section. The §`confirmCopySet` checks `passStyleOf(s) === 'tagged' && getTag(s) === 'copySet'`, then delegates to sibling `confirmElements(s.payload, reject)` (from `./copySet.js`) and to `confirmKey(s.payload, reject)` for payload validation. The §memo WeakSet caches positive judgements. The §CopyBag section (lines 186-290) mirrors CopySet's shape for `tagged: 'copyBag'` with `confirmCopyBag` delegating to `confirmBagEntries`. The §`makeCopyBagFromElements` (lines 268-290) is a worked example of *sort-then-adjacent-counting*: it builds a fullOrder antiComparator via `makeFullOrderComparatorKit().antiComparator`, sorts the elements, then scans adjacent-equal runs counting them into `[key, BigInt(count)]` entries; the §comment names the *history-dependent state* warning — the fullCompare *does not survive* the call. The §CopyMap section (lines 292-481) has the more-complex `payload: { keys, values }` shape — `payload` must be a `copyRecord` with *only* `keys` and `values` properties (enforced via `ownKeys(rest).length === 0` after destructuring rest); keys themselves must be keys; values must be a `copyArray`; keys and values arrays must be equal length. The §`getCopyMapEntries` returns a `Far('CopyMap entries iterable', ...)` exotic — an explicitly-hardened iterable that produces *one hardened-result-object per `next()` call*. The §`makeCopyMap` (lines 465-481) sorts entries by `compareAntiRank` (reverse rank order) to colocate keys-of-the-same-equivalence-class with their values rank-sorted; the §honest TODO names the *copyMap cover issue explained in patternMatchers.js* as a future-work item that depends on additional validation. The §`copyMapKeySet` (lines 454-457) is the *internal-form-shortcut*: a copyMap's keys are already in the internal form used by copySets, so `makeTagged('copySet', m.payload.keys)` constructs the keyset without re-validation.
