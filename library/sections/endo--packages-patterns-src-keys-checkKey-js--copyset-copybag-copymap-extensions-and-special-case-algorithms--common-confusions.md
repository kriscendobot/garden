---
title: Common confusions
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

- **"`copySetMemo` and `keyMemo` are redundant — every copySet is also a key."** They are *not* redundant. The §memo for copySets caches the *structural-payload validation* result (tag-match + element rank-ordering + element-is-key). The §memo for keys caches the *Key-eligibility* result. A copySet that passes structural validation might still fail Key-eligibility if its elements include errors or promises — which is rare but possible. Each memo serves its own predicate.
- **"`makeCopyBagFromElements` could just use a Map for counting."** A Map would work for *exact-equality* counting; but copyBag uses *rank-equivalence* counting (two values that are full-order-equal share a count). The fullOrder antiComparator with adjacent-counting handles the rank-tie case correctly; a Map would treat rank-tied values as distinct.
- **"`fullCompare` history-dependent state could leak across calls."** It *cannot* — `makeFullOrderComparatorKit()` returns a *new* comparator kit each call. The state lives in the closure; when the function returns, the closure is unreferenced and GC'd. The §comment names this discipline explicitly.
- **"`getCopyMapEntries` should just return an array — the iterator adds complexity."** The §dual-API (`getCopyMapEntries` lazy vs `getCopyMapEntryArray` eager) lets consumers pick based on access pattern. Lazy iteration avoids the upfront allocation for partial-iteration consumers.
- **"The `ownKeys(rest).length === 0` check is paranoid."** It is *correct*. Without it, a copyMap with extra properties (e.g., `{ keys, values, extraField }`) would pass other checks but be malformed. The strict invariant catches this immediately.
- **"`copyMapKeySet` should re-validate the keys."** It should *not* — the input is already an `assertCopyMap`-validated copyMap; its keys array is already in copySet's internal form. Re-validation would be wasted work.
- **"The `makeCopyMap` TODO is a bug that should be fixed."** It is a *known limit with named dependency*. The TODO references `patternMatchers.js`'s *copyMap cover issue*; closing the gap requires adding a validation criterion. The §discipline is to *name the dependency in the TODO* so a future maintainer knows which other file to update alongside.
- **"`compareAntiRank` vs `compareRank` — they should be the same."** They are *reverse-ordered* siblings. The choice between them is per-call: `makeCopyMap` uses anti (reverse) order because it wants rank-tied keys to *cluster together at the same position* in the sort. The detail matters for the adjacent-equality scans elsewhere.
- **"`harden({ done: false, value: [...] })` per `next()` is allocation-heavy."** Each step's iterator result is a *fresh object*; harden makes it immutable. The discipline trades allocation cost for the *no-shared-mutable-iterator-state* invariant. Iterator results that survive across `next()` calls would be a capability-discipline violation.
