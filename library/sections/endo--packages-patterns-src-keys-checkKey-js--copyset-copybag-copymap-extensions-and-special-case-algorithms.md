---
title: The §CopySet section that applies the Confirm/Is/Assert trio to the `tagged: 'copySet'` shape — `copySetMemo` WeakSet + `confirmCopySet` checking tag-match + delegating to sibling `confirmElements`/`confirmKey` for payload validation; the §CopyBag section that mirrors CopySet's shape for `tagged: 'copyBag'`; the §`makeCopyBagFromElements` algorithm — `sortByRank` against `makeFullOrderComparatorKit().antiComparator` then adjacent-equality counting (`while (j < sorted.length && fullCompare(k, sorted[j]) === 0) j += 1;`) to build the `[key, BigInt(count)]` entries — the *history-dependent state* warning that this fullOrder *does not survive* the call; the §CopyMap section with the more-complex `payload: { keys, values }` shape — payload must be a `copyRecord` with *only* `keys` and `values` properties (`ownKeys(rest).length === 0` invariant), keys themselves keys, values a `copyArray`, equal-length keys/values; the `getCopyMapEntries` returning a `Far('CopyMap entries iterable', ...)` exotic iterator (not just an array) for lazy iteration; the §`makeCopyMap` algorithm — *reverse rank sorting the entries* via `compareAntiRank` to colocate keys-of-the-same-equivalence-class with their values rank-sorted, plus the §explicit TODO that names the *copyMap cover issue* in patternMatchers.js as a future-work item that depends on additional validation; the §`copyMapKeySet` shortcut — a copyMap's keys are *already* in the internal form used by copySets, so `makeTagged('copySet', m.payload.keys)` constructs the keyset without re-validation
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--abstract.md)
- [Body](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--body.md)
- [Connection to the wider library](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--see-also.md)
- [Common confusions](endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms--common-confusions.md)
