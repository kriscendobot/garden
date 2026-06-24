---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns key/CopyTagged surface.
- `endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion` — the previous section: Confirm/Is/Assert trio pattern definition + Atom/Scalar/Key + keyMemo + confirmKeyInternal recursion.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — the rank-order regime; `sortByRank`, `compareAntiRank`, and `makeFullOrderComparatorKit` come from there.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; uses these collection shapes.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — the source of `passStyleOf`, `getTag`, `makeTagged`, `Far`.
- `endo--pkg-patterns-readme--*` — the @endo/patterns README; high-level surface.
